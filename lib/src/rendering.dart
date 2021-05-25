/// Provides `StaticFoil` and `FoilShader`,
/// a [SingleChildRenderObjectWidget] and [RenderProxyBox] respectively.
library foil;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'models/transformation.dart';
import 'utils.dart';

/// {@macro static_foil}
///
/// {@macro foil_shader}
class StaticFoil extends SingleChildRenderObjectWidget {
  /// {@template static_foil}
  /// A [SingleChildRenderObjectWidget] that creates and updates a [FoilShader].
  /// {@endtemplate}
  ///
  /// {@macro foil_shader}
  const StaticFoil({
    Key? key,
    required this.gradient,
    required this.rolloutX,
    required this.rolloutY,
    required this.blendMode,
    required this.useSensor,
    this.transform,
    Widget? child,
  }) : super(key: key, child: child);

  /// {@template forwarded}
  /// Forwarded from `RolledOutFoil`, `AnimatedFoil`
  /// {@endtemplate}
  final Gradient gradient;

  /// {@macro forwarded}
  final List<double> rolloutX, rolloutY;

  /// {@macro forwarded}
  final BlendMode blendMode;

  /// {@macro forwarded}
  final bool useSensor;

  /// {@macro forwarded}
  final TransformGradient? transform;

  @override
  FoilShader createRenderObject(BuildContext context) {
    assert(debugCheckHasDirectionality(
      context,
      why: 'in order for GradientTransform to consider directionality',
    ));
    return FoilShader(
      gradient,
      rolloutX,
      rolloutY,
      blendMode,
      useSensor,
      transform,
      Directionality.maybeOf(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, FoilShader renderObject) =>
      renderObject
        ..gradient = gradient
        ..rolloutX = rolloutX
        ..rolloutY = rolloutY
        ..blendMode = blendMode
        ..useSensor = useSensor
        ..transform = transform
        ..directionality = Directionality.maybeOf(context);
}

/// {@macro foil_shader}
class FoilShader extends RenderLimitedBox {
  /// {@template foil_shader}
  /// A `FoilShader` is a [RenderProxyBox] responsible for
  /// the positioning and painting of the masked gradient of a `Foil`
  /// directly onto the child.
  /// {@endtemplate}
  FoilShader(
    this._gradient,
    this._rolloutX,
    this._rolloutY,
    this._blendMode,
    this._useSensor,
    this._transform,
    this._directionality,
  );

  Gradient _gradient;
  List<double> _rolloutX, _rolloutY;
  BlendMode _blendMode;
  bool _useSensor;
  TransformGradient? _transform;
  TextDirection? _directionality;

  /// {@template needs_paint}
  /// Provide a new value, marking `NeedsPaint` if different than before.
  /// {@endtemplate}
  set gradient(Gradient gradient) {
    if (_gradient == gradient) return;
    _gradient = gradient;
    markNeedsPaint();
  }

  /// {@macro needs_paint}
  set rolloutX(List<double> rollout) {
    if (_rolloutX == rollout) return;
    _rolloutX = rollout;
    markNeedsPaint();
  }

  /// {@macro needs_paint}
  set rolloutY(List<double> rollout) {
    if (_rolloutY == rollout) return;
    _rolloutY = rollout;
    markNeedsPaint();
  }

  /// {@macro needs_paint}
  set blendMode(BlendMode blendMode) {
    if (_blendMode == blendMode) return;
    _blendMode = blendMode;
    markNeedsPaint();
  }

  /// {@macro needs_paint}
  set useSensor(bool useSensor) {
    if (_useSensor == useSensor) return;
    _useSensor = useSensor;
    markNeedsPaint();
  }

  /// {@macro needs_paint}
  set transform(TransformGradient? transform) {
    if (_transform == transform) return;
    _transform = transform;
    markNeedsPaint();
  }

  /// {@macro needs_paint}
  set directionality(TextDirection? directionality) {
    if (_directionality == directionality) return;
    _directionality = directionality;
    markNeedsPaint();
  }

  @override
  bool get alwaysNeedsCompositing => child != null;

  @override
  ShaderMaskLayer? get layer => super.layer as ShaderMaskLayer?;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      assert(needsCompositing);
      final width = child!.size.width;
      final height = child!.size.height;

      /// If a `Crinkle` dictates animation such that _rollout[0] != 0,
      /// then `copyWith` the transform. Otherwise don't copyWith,
      /// as currently that method only returns one of the three
      /// pre-defined FLutter `Gradient`s or new Foil `Steps`.
      /// (What if a developer is using a bespoke `Gradient`?)
      /// TODO: Rethink `Gradient.copyWith`
      final gradient = (_rolloutX[0] != 0 || _rolloutY[0] != 0)
          ? _gradient.copyWith(
              transform: _transform?.call(_rolloutX[0], _rolloutY[0]) ??
                  TranslateGradient(
                      percentX: _rolloutX[0], percentY: _rolloutY[0]))
          : _gradient;

      // Centered when `AccelerometerEvent(0,0)` which is like
      // a phone lying flat on its back on a table.
      final rect = Rect.fromLTWH(
        (_useSensor ? width * _rolloutX[1] : 0.0),
        (_useSensor ? height * _rolloutY[1] : 0.0),
        width,
        height,
      );

      layer ??= ShaderMaskLayer();
      layer!
        ..shader = gradient.createShader(rect, textDirection: _directionality)
        ..maskRect = offset & size
        ..blendMode = _blendMode;
      context.pushLayer(layer!, super.paint, offset);
    } else // (child == null)
      layer = null;
  }
}
