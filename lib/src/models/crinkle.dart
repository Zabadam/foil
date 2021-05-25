/// Provides the `Crinkle` animation parameter object for `Roll`s.
library foil;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import 'scalar.dart';
import 'transformation.dart';

/// Provide animation to a piece of `Foil` by wrapping it in a `Roll`
/// with a specified `Crinkle`.
///
/// A new `Roll()` by default is not animated―because its `Crinkle` is
/// [smooth]―but a [new Crinkle] *is* animated by default.
///
/// See each parameter for more information.
///
/// ![animated by \`Roll.crinkle\`](https://raw.githubusercontent.com/Zabadam/foil/master/doc/crinkle.gif 'animated by \`Roll.crinkle\`')
class Crinkle with Diagnosticable {
  /// Provide animation to a piece of `Foil` by wrapping it in a `Roll`
  /// with a specified `Crinkle`.
  ///
  /// A new `Roll()` by default is not animated―because its `Crinkle` is
  /// [smooth]―but a [new Crinkle] *is* animated by default.
  ///
  /// See each parameter for more information.
  ///
  /// ![animated by \`Roll.crinkle\`](https://raw.githubusercontent.com/Zabadam/foil/master/doc/crinkle_small.gif 'animated by \`Roll.crinkle\`')
  const Crinkle({
    this.isAnimated = true,
    this.shouldReverse = true,
    this.min = -2.0,
    this.max = 2.0,
    this.scalar = Scalar.identity,
    this.period = const Duration(milliseconds: 2000),
    this.transform,
  });

  /// A new `Roll()` by default is not animated―because its `Crinkle` is
  /// [smooth]―but a [new Crinkle] *is* animated by default.
  ///
  /// The default for `shouldReverse` is `true` and will cause the repeating
  /// animation (which drives one-way every [period]) to cycle between
  /// the [min] and [max] values back and forth.
  final bool isAnimated, shouldReverse;

  /// The bounds of this `Crinkle`'s animation. Default drives `-2..2`.
  ///
  /// Any given animation value at "keyframe" `t` lies between [min] and [max].
  /// Say `t` is `0` as an animation has *just* begun, then [min] value
  /// (defaults `-2.0`) and its mathematical sign is the current animation
  /// value. This is provided to the gradient-transformation process, as a
  /// percentage-of-offset, to [transform].
  /// - This transformation applies seperately from and in addition to
  /// any accelerometer sensor data (unless `Foil.useSensor == false`).
  /// - If no [transform] is provided, default will be a [TranslateGradient].
  ///
  /// After one [period] our `t` would be `1.0` and [max] (default is `2.0`)
  /// is provided as the current animation value.
  ///
  /// Furthermore, this animation value is finally multiplied by the relevant
  /// [Scalar.horizontal] or [Scalar.vertical] factor, as well as its
  /// mathematical sign, before transforming the gradient.
  final double min, max;

  /// A final multiplier to scale the gradient translation, independently
  /// configurable for either [Scalar.horizontal] or [Scalar.vertical] axis.
  /// The default is [Scalar.identity] which makes no impact.
  ///
  /// These values apply in addition to any accelerometer sensor data already
  /// affecting a `Foil`'s gradient as well as the current animation value
  /// between [min] and [max].
  ///
  /// In addition to `Scalar({horizontal, vertical})`, \
  /// a named `const Scalar.xy(double x, [double y])` constructor is available.
  final Scalar scalar;

  /// The `Duration` of time for one animation pass in a single direction.
  /// If [shouldReverse], this `period` will pass twice before the animation
  /// returns to its original [min] value.
  final Duration period;

  /// Register a callback that accepts the `x` and `y` that are provided \
  /// from `Roll.rollListenable` * `Crinkle.scalar`, where that \
  /// animation value ranges from [min] to [max] over [period].
  ///
  /// If no [transform] is provided, default will be a [TranslateGradient].
  ///
  /// [GradientTransform], which this function is expected to return, \
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
  /// > Implementers may return `null` from this method, which achieves the same \
  /// > final effect as returning [Matrix4.identity].
  final TransformGradient? transform;

  /// This `Crinkle` is actually [smooth]... \
  /// this constant initializes [isAnimated] to `false`.
  static const Crinkle smooth = Crinkle(isAnimated: false);

  /// An extremely animated `Crinkle`.
  static const Crinkle vivacious = Crinkle(
    min: -5.0,
    max: 5.0,
    scalar: Scalar.xy(2, 2),
    period: Duration(milliseconds: 1000),
  );

  /// A gently animated `Crinkle`.
  ///
  /// ![animated by \`Crinkle.twinkling\`](https://raw.githubusercontent.com/Zabadam/foil/master/doc/crinkle_small.gif 'animated by \`Crinkle.twinkling\`')
  static const Crinkle twinkling = Crinkle(period: Duration(seconds: 30));

  /// An incredibly slow `Crinkle`.
  static const Crinkle crawling =
      Crinkle(min: -1.0, max: 1.0, period: Duration(minutes: 2));

  /// Testing.
  static const Crinkle loop = Crinkle(
    shouldReverse: false,
    min: -2.0,
    max: 2.8,
    scalar: Scalar.identity,
    period: Duration(milliseconds: 2500),
  );

  /// 📋 Returns a copy of this `Crinkle` with the provided optional
  /// parameters overriding those of `this`.
  Crinkle copyWith({
    bool? isAnimated,
    bool? shouldReverse,
    double? min,
    double? max,
    Scalar? scalar,
    Duration? period,
    TransformGradient? transform,
  }) =>
      Crinkle(
        isAnimated: isAnimated ?? this.isAnimated,
        shouldReverse: shouldReverse ?? this.shouldReverse,
        min: min ?? this.min,
        max: max ?? this.max,
        scalar: scalar ?? this.scalar,
        period: period ?? this.period,
        transform: transform ?? this.transform,
      );

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('isAnimated', isAnimated,
          defaultValue: false))
      ..add(DiagnosticsProperty<bool>('shouldReverse', shouldReverse,
          defaultValue: true))
      ..add(DoubleProperty('min', min, defaultValue: null))
      ..add(DoubleProperty('max', max, defaultValue: null))
      ..add(DiagnosticsProperty<Scalar>('scalar', scalar, defaultValue: null))
      ..add(DiagnosticsProperty<Duration>('period', period, defaultValue: null))
      ..add(DiagnosticsProperty<TransformGradient>('transform', transform,
          defaultValue: null));
  }
}
