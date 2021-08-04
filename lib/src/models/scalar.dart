/// Provides `Scalar` parameter object for scaling axis-based double data.
library foil;

import '../common.dart';

/// A `Scalar` provides an opportunity to scale axis-based `double` data.
/// Default constructor takes named paramters per axis. Use [Scalar.xy]
/// as a shortcut to only provide positional `double` values.
/// - `Scalar.xy(5)` is equivalent to
///   `Scalar(horizontal: 5, vertical: 5)` and still `const`.
///
/// ### For use with `Foil`s
/// Accelerometer sensor data may be scaled independently before they
/// translate to gradient "twinkling" transformation (offset/translation).
///
/// Scale up the motion factor by providing [Scalar.horizontal] or
/// [Scalar.vertical] a value greater than `1.0`,
/// or scale down the influence by providing `0 <= scalar <= 1.0`.
///
/// ![scaling accelerometer data](https://raw.githubusercontent.com/Zabadam/foil/master/doc/scalar_small.gif 'scaling accelerometer data')
///
/// ### For use with `Roll`s
/// In the case of a `Roll`, a `Scalar` object provides a means to direct
/// animation of the gradient if `isAnimated` is true. Also see the
/// `min` and `max` values.
class Scalar with Diagnosticable {
  /// A `Scalar` provides an opportunity to scale axis-based `double` data.
  /// Default constructor takes named paramters per axis. Use [Scalar.xy]
  /// as a shortcut to only provide positional `double` values.
  /// - `Scalar.xy(5)` is equivalent to
  ///   `Scalar(horizontal: 5, vertical: 5)` and still `const`.
  ///
  /// ### For use with `Foil`s
  /// Accelerometer sensor data may be scaled independently before they
  /// translate to gradient "twinkling" transformation (offset/translation).
  ///
  /// Scale up the motion factor by providing [Scalar.horizontal] or
  /// [Scalar.vertical] a value greater than `1.0`,
  /// or scale down the influence by providing `0 <= scalar <= 1.0`.
  ///
  /// ![scaling accelerometer data](https://raw.githubusercontent.com/Zabadam/foil/master/doc/scalar_small.gif 'scaling accelerometer data')
  ///
  /// ### For use with `Roll`s
  /// In the case of a `Roll`, a `Scalar` object provides a means to direct
  /// animation of the gradient if `isAnimated` is true. Also see the
  /// `min` and `max` values.
  const Scalar({
    this.horizontal = 1.0,
    this.vertical = 1.0,
  });

  /// Positionally provide an `x` or [Scalar.horizontal] value then
  /// a `y` or [Scalar.vertical] value; returns a constructed `Scalar` object.
  ///
  /// The `y` paramater is optional and will be filled with `x` if absent.
  /// - `Scalar.xy(5)` is equivalent to
  ///   `Scalar(horizontal: 5, vertical: 5)` and still `const`.
  const Scalar.xy(double x, [double? y])
      // ignore: prefer_initializing_formals
      : horizontal = x,
        vertical = y ?? x;

  /// A `double` that defaults to `1.0` that scales `Foil` data.
  ///
  /// In the case of a `Foil` constructor, that means scaling the computed
  /// accelerometer sensor data, either up or down.
  ///
  /// This provides the opportunity to nullify an axis of influence,
  /// increase or decrease the influence of an axis,
  /// or even reverse one's impact.
  ///
  /// In terms of `Roll` construction, a `Scalar` object provides a means
  /// to direct animation of the gradient if `isAnimated` is true.
  /// Also see the `min` and `max` values.
  final double horizontal, vertical;

  /// A static `Scalar` with both `horizontal` and `vertical`
  /// properties equal to `1.0`.
  static const identity = Scalar(horizontal: 1.0, vertical: 1.0);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('horizontal', horizontal, defaultValue: 1.0))
      ..add(DoubleProperty('vertical', vertical, defaultValue: 1.0));
  }
}
