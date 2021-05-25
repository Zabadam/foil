/// Provides `TransformGradient` typedef, a function accepting a
/// `double x` & `double y` and returning a `GradientTransform`,
/// as well as `TranslateGradient`, the default `TransformGradient`
/// for this package.
library foil;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

/// The definition of a `Function` that positionally accepts a \
/// `double x` then `double y` and returns a [GradientTransform], \
/// such as the default for this package: [TranslateGradient].
///
/// In terms of `Foil` this callback is registered as `Roll.foil`, \
/// and the `x` and `y` that are provided come from the
/// `AnimationController.value` * `Crinkle.scalar`, where
/// that `value` ranges from `Crinkle.min` to `Crinkle.max`.
///
/// `GradientTransform`, which this function is expected to return, \
/// is an abstract class with a single method that transforms the \
/// gradient based on bounds and text direction.
///
/// Extend that class and override `transform()`, returning some [Matrix4].
///
/// > ```dart
/// > @override
/// > Matrix4? transform(Rect bounds, {TextDirection? textDirection});
/// > ```
/// > When a [Gradient] creates its [Shader], it will call this method to \
/// > determine what transform to apply to the shader for the given [Rect] and \
/// > [TextDirection]. \
/// > Implementers may return null from this method, which achieves the same \
/// > final effect as returning [Matrix4.identity].
typedef TransformGradient = GradientTransform Function(double x, double y);

/// {@macro translate_gradient}
class TranslateGradient extends GradientTransform with Diagnosticable {
  /// {@template translate_gradient}
  /// This class's [transform] method considers [TextDirection] and
  /// will consider positive values as translation to the right if `ltr`
  /// and translate left for positive values if `rtl`.
  ///
  /// The default [TransformGradient] for `Foil`.
  /// {@endtemplate}
  const TranslateGradient({required this.percentX, required this.percentY});

  /// An unbounded `double` that represents a percentage of the [Rect] `bounds`
  /// to translate the gradient. May be positive or negative.
  /// May exceed `± 1.0`.
  ///
  /// If [TextDirection] is `ltr`, positive [percentX] values translate
  /// the gradient forward to the right. If it is `rtl`, positive [percentX]
  /// values translate the gradient forward to the left.
  final double percentX, percentY;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(
        (textDirection == TextDirection.rtl ? -1.0 : 1.0) *
            bounds.width *
            percentX,
        bounds.height * percentY,
        0.0,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('percentX', percentX, defaultValue: null))
      ..add(DoubleProperty('percentY', percentY, defaultValue: null));
  }
}
