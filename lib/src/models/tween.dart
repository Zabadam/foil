/// Provides `GradientTween` which specializes the interpolation
/// of [Tween<Gradient>] to use [Gradient.lerp].
library foil;

import 'package:flutter/widgets.dart';

/// {@macro gradient_tween}
class GradientTween extends Tween<Gradient?> {
  /// {@template gradient_tween}
  /// An interpolation between two `Gradient`s.
  ///
  /// This class specializes the interpolation of [Tween<Gradient>]
  /// to use [Gradient.lerp].
  ///
  /// See [Tween] for a discussion on how to use interpolation objects.
  /// {@endtemplate}
  GradientTween({Gradient? begin, Gradient? end})
      : super(begin: begin, end: end);

  /// Returns the value this variable has at the given animation clock value.
  @override
  Gradient lerp(double t) => Gradient.lerp(begin, end, t)!;
}
