/// Provides `StaticFoil` and `Foilage`
library foil;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class StaticFoil extends SingleChildRenderObjectWidget {
  const StaticFoil({
    Key? key,
    required this.gradient,
    required this.angleX,
    required this.angleY,
    Widget? child,
  }) : super(key: key, child: child);

  final Gradient gradient;
  final double angleX, angleY;

  @override
  Foilage createRenderObject(BuildContext context) =>
      Foilage(gradient, angleX, angleY);

  @override
  void updateRenderObject(BuildContext context, Foilage renderObject) =>
      renderObject
        ..gradient = gradient
        ..angleX = angleX
        ..angleY = angleY;
}

class Foilage extends RenderProxyBox {
  Foilage(this._gradient, this._angleX, this._angleY);

  Gradient _gradient;
  double _angleX, _angleY;

  set gradient(Gradient gradient) {
    if (gradient == _gradient) return;
    _gradient = gradient;
    markNeedsPaint();
  }

  set angleX(double angle) {
    if (angle == _angleX) return;
    _angleX = angle;
    markNeedsPaint();
  }

  set angleY(double angle) {
    if (angle == _angleY) return;
    _angleY = angle;
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
      final width = child?.size.width ?? context.estimatedBounds.width;
      final height = child?.size.height ?? context.estimatedBounds.height;
      final rect = Rect.fromLTWH(0.5 * width - width * _angleX,
          0.5 * height - height * _angleY, width, height);

      layer ??= ShaderMaskLayer();
      layer!
        ..shader = _gradient.createShader(rect)
        ..maskRect = offset & size
        ..blendMode = BlendMode.srcIn;
      context.pushLayer(layer!, super.paint, offset);
    } else // (child == null)
      layer = null;
  }
}
