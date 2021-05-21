/// Provides `AnimatedFoil`, as well as `GradientTween` and `nill`
library foil;

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Colors;

import 'rendering.dart';

/// An empty, transparent [LinearGradient].
const nill = LinearGradient(colors: [Colors.transparent, Colors.transparent]);

/// {@macro gradient_tween}
class GradientTween extends Tween<Gradient> {
  /// {@template gradient_tween}
  /// If either `begin` or `end` is `null`,
  /// the transparent gradient [nill] is used in its place.
  ///
  /// Return [Gradient.lerp] at `t`.
  /// {@endtemplate}
  GradientTween({Gradient? begin, Gradient? end})
      : super(begin: begin, end: end);

  @override
  Gradient lerp(double t) => Gradient.lerp(begin ?? nill, end ?? nill, t)!;
}

/// {@macro animated_foil}
class AnimatedFoil extends ImplicitlyAnimatedWidget {
  /// {@template animated_foil}
  /// An `ImplicitlyAnimatedWidget` that renders a [gradient]-masked
  /// [StaticFoil] that is "rolled out" by percentages represented as
  /// [rolloutX] and [rolloutY].
  ///
  /// Use `duration` and `curve` to control the `animation`
  /// between old and new values.
  /// {@endtemplate}
  const AnimatedFoil({
    Key? key,
    required this.gradient,
    required this.rolloutX,
    required this.rolloutY,
    required this.child,
    required Duration duration,
    Curve curve = Curves.linear,
  }) : super(key: key, duration: duration, curve: curve);

  /// The `Gradient` to pass to this `AnimatedFoil`'s [StaticFoil].
  final Gradient gradient;

  /// A value between `0..1` that describes how "rolled out"
  /// this `AnimatedFoil`'s [StaticFoil] is.
  ///
  /// That is to say, this value corresponds to a percentage of the
  /// [child]'s size to offset or translate the [gradient].
  final double rolloutX, rolloutY;

  /// The `Widget` to wrap in [StaticFoil].
  final Widget child;

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _AnimatedFoilState();
}

class _AnimatedFoilState extends AnimatedWidgetBaseState<AnimatedFoil> {
  GradientTween? _gradient;
  Tween<double>? _rolloutX, _rolloutY;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _gradient = visitor(
            _gradient,
            widget.gradient,
            (dynamic e) =>
                GradientTween(begin: e as Gradient, end: widget.gradient))
        as GradientTween;
    _rolloutX = visitor(_rolloutX, widget.rolloutX,
        (dynamic e) => Tween<double>(begin: e as double)) as Tween<double>;
    _rolloutY = visitor(_rolloutY, widget.rolloutY,
        (dynamic e) => Tween<double>(begin: e as double)) as Tween<double>;
  }

  @override
  Widget build(BuildContext context) => StaticFoil(
        gradient: _gradient?.evaluate(animation) ?? nill,
        angleX: _rolloutX?.evaluate(animation) ?? 0.0,
        angleY: _rolloutY?.evaluate(animation) ?? 0.0,
        child: widget.child,
      );
}
