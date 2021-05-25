/// Provides `AnimatedFoil`, which utilizes `GradientTween`,
/// as well as `RolledOutFoil`;
/// both [ImplicitlyAnimatedWidget]s to handle particular `Foil` properties.
//
// These two classes could be simplified by sharing parameters
// through some means (ParentData?), though they are both quite simple already.
library foil;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../foil.dart';
import 'models/tween.dart';
import 'rendering.dart';

/// {@macro animated_foil}
class AnimatedFoil extends ImplicitlyAnimatedWidget {
  /// {@template animated_foil}
  /// An `ImplicitlyAnimatedWidget` that renders a [gradient]-masked
  /// [RolledOutFoil] that is "rolled out," or translated,
  /// by percentages represented as [rolloutX] and [rolloutY].
  ///
  /// Use `duration` and `curve` to control the `animation`
  /// between old and new [gradient]s.
  /// {@endtemplate}
  const AnimatedFoil({
    Key? key,
    required this.gradient,
    required this.rolloutX,
    required this.rolloutY,
    required this.blendMode,
    required this.useSensor,
    required this.child,
    required this.speed,
    required Duration duration,
    Curve curve = Curves.linear,
    VoidCallback? onEnd,
  }) : super(key: key, duration: duration, curve: curve, onEnd: onEnd);

  /// The `Gradient` to pass to this `AnimatedFoil`'s [RolledOutFoil].
  final Gradient? gradient;

  /// A value between `-1..1` that describes how "rolled out"
  /// this `AnimatedFoil`'s [RolledOutFoil] is.
  ///
  /// That is to say, this value corresponds to a percentage of the
  /// [child]'s size to offset/translate the [gradient].
  ///
  /// `rolloutFoo[0]` correlates to [Crinkle] provided animation values
  /// and `rolloutFoo[1]` corresponds to sensor data.
  final List<double> rolloutX, rolloutY;

  /// {@template blend_mode}
  /// The [BlendMode] utilized in painting the `Foil` [gradient].
  /// {@endtemplate}
  final BlendMode blendMode;

  /// {@template use_sensor}
  /// Default is `true`, but if passed `false` then [FoilShader] in the
  /// [StaticFoil] will not consider accelerometer sensors data when
  /// transforming its gradient.
  /// Only animation by `Roll.crinkle` would translate the gradient then.
  /// {@endtemplate}
  final bool useSensor;

  /// The `Widget` to wrap in [RolledOutFoil].
  final Widget child;

  /// The `Duration` over which alterations to "rollout"s are animated. \
  /// Passed as `RolledOutFoil.duration`.
  final Duration speed;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _AnimatedFoilState();
}

class _AnimatedFoilState extends AnimatedWidgetBaseState<AnimatedFoil> {
  GradientTween? _gradient;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) => _gradient = visitor(
          _gradient,
          widget.gradient,
          (dynamic value) => GradientTween(begin: value as Gradient))
      as GradientTween?;

  @override
  Widget build(BuildContext context) => RolledOutFoil(
        gradient: _gradient!.evaluate(animation)!,
        rolloutX: widget.rolloutX,
        rolloutY: widget.rolloutY,
        blendMode: widget.blendMode,
        duration: widget.speed,
        curve: widget.curve,
        useSensor: widget.useSensor,
        child: widget.child,
      );
}

/// {@macro rolled_out_foil}
class RolledOutFoil extends ImplicitlyAnimatedWidget {
  /// {@template rolled_out_foil}
  /// An `ImplicitlyAnimatedWidget` that renders a [gradient]-masked
  /// [StaticFoil] that is "rolled out," or translated,
  /// by percentages represented as [rolloutX] and [rolloutY].
  ///
  /// Use `duration` and `curve` to control the `animation`
  /// between old and new rollouts.
  /// {@endtemplate}
  const RolledOutFoil({
    Key? key,
    required this.gradient,
    required this.rolloutX,
    required this.rolloutY,
    required this.child,
    required this.blendMode,
    required this.useSensor,
    required Duration duration,
    Curve curve = Curves.linear,
  }) : super(key: key, duration: duration, curve: curve);

  /// The evaluated `Gradient` to forward to this `AnimatedFoil`'s [StaticFoil].
  final Gradient gradient;

  /// A value between `-1..1` that describes how "rolled out"
  /// this `AnimatedFoil`'s [StaticFoil] is.
  ///
  /// That is to say, this value corresponds to a percentage of the
  /// [child]'s size to offset or translate the [gradient].
  ///
  /// `rolloutFoo[0]` correlates to [Crinkle] provided animation values
  /// and `rolloutFoo[1]` corresponds to sensor data.
  final List<double> rolloutX, rolloutY;

  /// {@template blend_mode}
  final BlendMode blendMode;

  /// {@template use_sensor}
  final bool useSensor;

  /// The `Widget` to wrap in [StaticFoil].
  final Widget child;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _RolledOutFoilState();
}

class _RolledOutFoilState extends AnimatedWidgetBaseState<RolledOutFoil> {
  Tween<double>? _rolloutX1, _rolloutY1, _rolloutX2, _rolloutY2;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _rolloutX1 = visitor(_rolloutX1, widget.rolloutX[0],
            (dynamic value) => Tween<double>(begin: value as double))
        as Tween<double>?;
    _rolloutY1 = visitor(_rolloutY1, widget.rolloutY[0],
            (dynamic value) => Tween<double>(begin: value as double))
        as Tween<double>?;
    _rolloutX2 = visitor(_rolloutX2, widget.rolloutX[1],
            (dynamic value) => Tween<double>(begin: value as double))
        as Tween<double>?;
    _rolloutY2 = visitor(_rolloutY2, widget.rolloutY[1],
            (dynamic value) => Tween<double>(begin: value as double))
        as Tween<double>?;
  }

  @override
  Widget build(BuildContext context) {
    final roll = Roll.of(context);
    return StaticFoil(
      gradient: widget.gradient,
      rolloutX: [
        _rolloutX1?.evaluate(animation) ?? 0.0,
        _rolloutX2?.evaluate(animation) ?? 0.0
      ],
      rolloutY: [
        _rolloutY1?.evaluate(animation) ?? 0.0,
        _rolloutY2?.evaluate(animation) ?? 0.0
      ],
      blendMode: widget.blendMode,
      useSensor: widget.useSensor,
      transform: roll?.transform,
      child: widget.child,
    );
  }
}
