/// Provides three types of extended `Gradient`s aptly named `Steps`,
/// as they do not gradate but instead hard-transition.
/// - [LinearSteps], [RadialSteps], [SweepSteps]
library foil;

import 'dart:collection' as collection;
import 'dart:math' as math;
import 'dart:typed_data' as data;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart' show listEquals, objectRuntimeType;
import 'package:flutter/painting.dart';
import 'package:flutter/material.dart' show Colors;

/// Copied from [Gradient].
class _ColorsAndStops {
  _ColorsAndStops(this.colors, this.stops);
  final List<Color> colors;
  final List<double> stops;
}

/// Take a `List` and returns a `List` of the same type with duplicated entries.
List<T> _duplicateEntries<T>(List<T> list) => list.fold<List<T>>(
    <T>[], (List<T> list, T entry) => list..addAll(<T>[entry, entry]));

/// Resolve the provided [transform] against the [bounds] & [textDirection].
data.Float64List? _resolveTransform(GradientTransform? transform, Rect bounds,
        TextDirection? textDirection) =>
    transform?.transform(bounds, textDirection: textDirection)?.storage;

/// Without a provided list of `stops`, a `Steps` will generate its own.
List<double> _impliedStops(int length) {
  final len = length == 0 ? 1 : length;
  var stops = <double>[0.0];
  for (var i = 1; i < len; i++) stops.add(i / len);
  return stops..add(1.0);
  // return _duplicateEntries(stops)
  //   ..insert(0, 0.0)
  //   ..add(1.0);
}

/// Originally copied from [Gradient]. Modified to support fewer `Color`s. \
/// Calculate the color at position [t] of the gradient
/// defined by [colors] and [stops].
Color _sample(List<Color> colors, List<double> stops, double t) {
  final _colors = (colors.isEmpty) ? [Colors.transparent] : colors;
  final _stops = (stops.isEmpty) ? [0.0] : stops;

  if (t <= _stops.first) return _colors.first;
  if (t >= _stops.last) return _colors.last;
  final index = _stops.lastIndexWhere((double s) => s <= t);
  assert(index != -1);
  return Color.lerp(
    _colors[index],
    _colors[index + 1],
    (t - _stops[index]) / (_stops[index + 1] - _stops[index]),
  )!;
}

/// Originally copied from [Gradient]. Modified to support fewer `Color`s. \
/// Interpolate two `List`s of `Color` *and* `double` stops at `t`.
_ColorsAndStops _interpolateColorsAndStops(
  List<Color> aColors,
  List<double> aStops,
  List<Color> bColors,
  List<double> bStops,
  double t,
) {
  assert(aStops.length == aColors.length);
  assert(bStops.length == bColors.length);
  final stops = collection.SplayTreeSet<double>()
    ..addAll(aStops)
    ..addAll(bStops);
  final interpolatedStops = stops.toList(growable: false);
  final interpolatedColors = interpolatedStops
      .map<Color>((double stop) => Color.lerp(
          _sample(aColors, aStops, stop), _sample(bColors, bStops, stop), t)!)
      .toList(growable: false);
  return _ColorsAndStops(interpolatedColors, interpolatedStops);
}

/// Duplicates entries as necessary to achieve the `Steps` look,
/// then forwards to [_interpolateColorsAndStops].
_ColorsAndStops _interpolate(Gradient a, Gradient b, double t) {
  return _interpolateColorsAndStops(
    // _duplicateEntries(a.colors),
    // _impliedStops(a.colors.length),
    // _duplicateEntries(b.colors),
    // _impliedStops(b.colors.length),
    a.colors,
    _impliedStops(a.colors.length)..removeLast(),
    b.colors,
    _impliedStops(b.colors.length)..removeLast(),
    t,
  );
}

/// A 2D linear stepped "gradient".
///
/// This class is used to represent linear steps, abstracting out
/// the arguments to the [new ui.Gradient.linear] constructor from `dart:ui`.
///
/// A `LinearSteps` has two anchor points, [begin] and [end]. The [begin] point
/// corresponds to `0.0`, and the [end] point corresponds to `1.0`.
/// These points are expressed in fractions.
///
/// The [colors] are a `List<Color>`.
/// The [stops] list, if specified, must have the same length as [colors].
/// It specifies fractions of the vector from start to end, between
/// `0.0` and `1.0`, for each color.
/// If it is `null`, a uniform distribution is assumed.
///
/// The region of the canvas before [begin] and after [end]
/// is colored according to [tileMode].
///
/// Typically this class is used with [BoxDecoration], which does the painting.
/// To use a [LinearSteps] to paint directly on a canvas, see [createShader].
///
/// {@tool snippet}
/// ### The right-most example is this `LinearSteps`
/// ![the right-most example is this LinearSteps](https://raw.githubusercontent.com/Zabadam/foil/master/doc/Foils.stepBow.gif 'the right-most example is this LinearSteps')
/// ```dart
/// final stepBowLinear = Container(
///   decoration: BoxDecoration(
///     gradient: LinearSteps(
///       tileMode: TileMode.repeated,
///       begin: Alignment.topLeft,
///       end: Alignment.centerLeft,
///       colors: [
///         Colors.red, Colors.orange, Colors.yellow, Colors.green,
///         Colors.blue, Colors.indigo, Colors.purple, Colors.pink,
///       ],
///     ),
///   ),
/// );
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [LinearGradient], which represents a true linear gradient
///  * [RadialSteps], a variety of [RadialGradient] that, like this `Gradient`,
///    steps instead of gradating
///  * [BoxDecoration], which can take a [LinearSteps] in its
///    [BoxDecoration.gradient] property.
class LinearSteps extends Gradient {
  /// Construct a new `LinearSteps` type `Gradient`.
  ///
  /// This gradient resembles a [LinearGradient] but its [colors]
  /// are not smoothly gradated between, but instead hard-transition,
  /// like steps.
  ///
  /// ### The right-most example is a `LinearSteps`
  /// ![the right-most example is a LinearSteps](https://raw.githubusercontent.com/Zabadam/foil/master/doc/Foils.stepBow.gif 'the right-most example is a LinearSteps')
  const LinearSteps({
    this.begin = Alignment.centerLeft,
    this.end = Alignment.centerRight,
    required List<Color> colors,
    List<double>? stops,
    this.tileMode = TileMode.clamp,
    GradientTransform? transform,
  }) : super(colors: colors, stops: stops, transform: transform);

  /// The offset at which stop `0.0` of this `LinearSteps` is placed.
  ///
  /// If this is an [Alignment], then it is expressed as a vector from
  /// coordinate `(0.0, 0.0)`, in a coordinate space that maps the center of the
  /// paint box at `(0.0, 0.0)` and the bottom right at `(1.0, 1.0)`.
  ///
  /// For example, a `begin` offset of `(-1.0, 0.0)`
  /// is half way down the left side of the box.
  ///
  /// It can also be an [AlignmentDirectional], where the start is the `left`
  /// in left-to-right contexts and the `right` in right-to-left contexts.
  /// If a text-direction-dependent value is provided here,
  /// then the [createShader] method will need to be given a [TextDirection].
  ///
  /// Copied from [LinearGradient].
  final AlignmentGeometry begin;

  /// The offset at which stop `1.0` of this `LinearSteps` is placed.
  ///
  /// If this is an [Alignment], then it is expressed as a vector from
  /// coordinate `(0.0, 0.0)`, in a coordinate space that maps the center of the
  /// paint box at `(0.0, 0.0)` and the bottom right at `(1.0, 1.0)`.
  ///
  /// For example, an `end` offset of `(1.0, 0.0)`
  /// is half way down the right side of the box.
  ///
  /// It can also be an [AlignmentDirectional], where the start is the `left`
  /// in left-to-right contexts and the `right` in right-to-left contexts.
  /// If a text-direction-dependent value is provided here,
  /// then the [createShader] method will need to be given a [TextDirection].
  ///
  /// Copied from [LinearGradient].
  final AlignmentGeometry end;

  /// How this `LinearSteps` should tile the plane beyond
  /// the region before [begin] and after [end].
  ///
  /// For details, see [TileMode].
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/tile_mode_clamp_linear.png)
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/tile_mode_mirror_linear.png)
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/tile_mode_repeated_linear.png)
  ///
  /// Copied from [LinearGradient].
  final TileMode tileMode;

  /// Creates a `ui.Gradient.linear` with duplicated `colors` and `stops`.
  @override
  Shader createShader(Rect rect, {TextDirection? textDirection}) =>
      ui.Gradient.linear(
        begin.resolve(textDirection).withinRect(rect),
        end.resolve(textDirection).withinRect(rect),
        _duplicateEntries(colors),
        _duplicateEntries(_impliedStops(colors.length))
          ..remove(0)
          ..removeLast(),
        tileMode,
        _resolveTransform(transform, rect, textDirection),
      );

  /// Returns a new [LinearSteps] with its colors scaled by the given factor.
  /// Since the alpha channel is what receives the scale factor,
  /// `0.0` or less results in a gradient that is fully transparent.
  @override
  LinearSteps scale(double factor) => copyWith(
        colors: colors
            .map<Color>((Color color) => Color.lerp(null, color, factor)!)
            .toList(),
      );

  @override
  Gradient? lerpFrom(Gradient? a, double t) => (a == null || (a is LinearSteps))
      ? LinearSteps.lerp(a as LinearSteps?, this, t)
      : super.lerpFrom(a, t);

  @override
  Gradient? lerpTo(Gradient? b, double t) => (b == null || (b is LinearSteps))
      ? LinearSteps.lerp(this, b as LinearSteps?, t)
      : super.lerpTo(b, t);

  /// Copied from [LinearGradient]. \
  /// Linearly interpolate between two [LinearSteps].
  ///
  /// If either `LinearSteps` is `null`, this function linearly interpolates
  /// from a `LinearSteps` that matches the other in [begin], [end], [stops] and
  /// [tileMode] and with the same [colors] but transparent (using [scale]).
  ///
  /// If neither `LinearSteps` is `null`,
  /// they must have the same number of [colors].
  ///
  /// The `t` argument represents a position on the timeline, with `0.0` meaning
  /// that the interpolation has not started, returning `a` (or something
  /// equivalent to `a`), `1.0` meaning that the interpolation has finished,
  /// returning `b` (or something equivalent to `b`), and values in between
  /// meaning that the interpolation is at the relevant point on the timeline
  /// between `a` and `b`. The interpolation can be extrapolated beyond `0.0`
  /// and `1.0`, so negative values and values greater than `1.0` are valid
  /// (and can easily be generated by curves such as `Curves.elasticInOut`).
  ///
  /// Values for `t` are usually obtained from an [Animation<double>],
  /// such as an `AnimationController`.
  static LinearSteps? lerp(LinearSteps? a, LinearSteps? b, double t) {
    if (a == null && b == null) return null;
    if (a == null) return b!.scale(t);
    if (b == null) return a.scale(1.0 - t);
    final interpolated = _interpolate(a, b, t);
    return LinearSteps(
      begin: AlignmentGeometry.lerp(a.begin, b.begin, t)!,
      end: AlignmentGeometry.lerp(a.end, b.end, t)!,
      colors: interpolated.colors,
      stops: interpolated.stops,
      // TODO: interpolate tile mode
      tileMode: t < 0.5 ? a.tileMode : b.tileMode,
    );
  }

  /// 📋 Returns a new copy of this `LinearSteps` with any provided
  /// optional parameters overriding those of `this`.
  LinearSteps copyWith({
    List<Color>? colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) =>
      LinearSteps(
        colors: colors ?? this.colors,
        stops: stops ?? this.stops,
        begin: begin ?? this.begin,
        end: end ?? this.end,
        tileMode: tileMode ?? this.tileMode,
        transform: transform ?? this.transform,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is LinearSteps &&
        other.begin == begin &&
        other.end == end &&
        other.tileMode == tileMode &&
        listEquals<Color>(other.colors, colors) &&
        listEquals<double>(other.stops, stops);
  }

  @override
  int get hashCode =>
      hashValues(begin, end, tileMode, hashList(colors), hashList(stops));

  @override
  String toString() => '${objectRuntimeType(this, 'LinearSteps')}'
      '($begin, $end, $colors, $stops, $tileMode)';
}

/// A 2D radial stepping "gradient".
///
/// This class represent radial steps, abstracting out
/// the arguments to the [new ui.Gradient.radial] constructor from `dart:ui`.
///
/// A normal `RadialSteps` has a [center] and a [radius]. The [center] point
/// corresponds to `0.0`, and the ring at [radius] from the center corresponds
/// to `1.0`. These lengths are expressed in fractions.
///
/// It is also possible to create a two-point (or focal pointed) `RadialSteps`
/// (which is sometimes referred to as a two point conic gradient, but is not
/// the same as a CSS conic gradient which corresponds to a [SweepSteps]).
///
/// A [focal] point and [focalRadius] can be specified similarly to
/// [center] and [radius], which will make the rendered gradient appear
/// to be pointed or directed in the direction of the [focal] point.
/// This is only important if [focal] and [center] are not equal or
/// [focalRadius] is greater than `0.0` (as this case is visually identical to a
/// normal `RadialSteps`).
///
/// One important case to avoid is having [focal] and [center] both resolve
/// to [Offset.zero] when [focalRadius] is greater than  `0.0`.
/// In such a case, a valid shader cannot be created by the framework.
///
/// The [colors] are described by a `List<Color>`.
/// The [stops] list, if specified, must have the same length as [colors].
/// It specifies fractions of the [radius] between `0.0` and `1.0`,
/// giving concentric rings for each color stop.
/// If it is `null`, a uniform distribution is assumed.
///
/// The region of the canvas beyond [radius] from the [center]
/// is painted according to [tileMode].
///
/// Typically this class is used with [BoxDecoration], which does the painting.
/// To use a [RadialSteps] to paint directly on a canvas, see [createShader].
///
/// {@tool snippet}
/// ### The center example is this `RadialSteps`
/// ![the center example is this RadialSteps](https://raw.githubusercontent.com/Zabadam/foil/master/doc/Foils.stepBow.gif 'the center example is this RadialSteps')
///
/// ```dart
/// final stepBowRadial = Container(
///   decoration: BoxDecoration(
///     gradient: RadialSteps(
///       tileMode: TileMode.repeated,
///       radius: 0.5,
///       colors: [
///         Colors.pink, Colors.purple, Colors.indigo, Colors.blue,
///         Colors.green, Colors.yellow, Colors.orange, Colors.red,
///       ],
///     );
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [RadialGradient], which represents a true radial gradient
///  * [SweepSteps], a variety of [SweepGradient] that, like this `Gradient`,
///    steps instead of gradating, but sweeps an arc instead of expanding
///    from a center
///  * [BoxDecoration], which can take a [RadialSteps] in its
///    [BoxDecoration.gradient] property.
class RadialSteps extends Gradient {
  /// Construct a new `RadialSteps` type `Gradient`.
  ///
  /// This gradient resembles a [RadialGradient] but its [colors]
  /// are not smoothly gradated between, but instead hard-transition,
  /// like steps.
  ///
  /// ### The center example is a `RadialSteps`
  /// ![the center example is a RadialSteps](https://raw.githubusercontent.com/Zabadam/foil/master/doc/Foils.stepBow.gif 'the center example is a RadialSteps')
  const RadialSteps({
    this.center = Alignment.center,
    this.radius = 0.5,
    required List<Color> colors,
    List<double>? stops,
    this.focal,
    this.focalRadius = 0.0,
    this.tileMode = TileMode.clamp,
    GradientTransform? transform,
  }) : super(colors: colors, stops: stops, transform: transform);

  /// The center of this `RadialSteps` as an offset into the
  /// `(-1.0, -1.0) x (1.0, 1.0)` square describing the `Gradient`
  /// which will be mapped onto the paint box.
  ///
  /// For example, an alignment of `(0.0, 0.0)` will place
  /// this `RadialSteps` in the center of the box.
  ///
  /// If this is an [Alignment], then it is expressed as a vector from
  /// coordinate `(0.0, 0.0)`, in a coordinate space that maps the center
  /// of the paint box at `(0.0, 0.0)` and the bottom right at `(1.0, 1.0)`.
  ///
  /// It can also be an [AlignmentDirectional], where the start is the `left`
  /// in left-to-right contexts and the `right` in right-to-left contexts.
  /// If a text-direction-dependent value is provided here,
  /// then the [createShader] method will need to be given a [TextDirection].
  ///
  /// Copied from [RadialGradient].
  final AlignmentGeometry center;

  /// The `radius` of this `RadialSteps` as a fraction of
  /// the shortest side of the paint box.
  ///
  /// For example, if a `RadialSteps` is painted on a box that is
  /// `100.0` pixels wide and `200.0` pixels tall, then a `radius` of `1.0`
  /// will place the `1.0` stop at `100.0` pixels from the [center].
  ///
  /// Copied from [RadialGradient].
  final double radius;

  /// The `focal` point of this `RadialSteps`.
  /// If specified, the `RadialSteps` will appear to be focused
  /// along the vector from [center] to `focal`.
  ///
  /// See [center] for a description of how the coordinates are mapped.
  ///
  /// If this value is specified and [focalRadius] is greater than `0.0`,
  /// care should be taken to ensure that either this value or [center]
  /// will not both resolve to [Offset.zero], which would fail
  /// to create a valid `RadialSteps`.
  ///
  /// Copied from [RadialGradient].
  final AlignmentGeometry? focal;

  /// The radius of the focal point of this `RadialSteps`
  /// as a fraction of the shortest side of the paint box.
  ///
  /// For example, if a `RadialSteps` is painted on a box that is
  /// `100.0` pixels wide and `200.0` pixels tall, then a `radius` of `1.0`
  /// will place the `1.0` stop at 100.0 pixels from the [focal] point.
  ///
  /// If this value is specified and is greater than 0.0, either [focal] or
  /// [center] must not resolve to [Offset.zero], which would fail to create
  /// a valid gradient.
  ///
  /// Copied from [RadialGradient].
  final double focalRadius;

  /// How this `RadialSteps` should tile the plane
  /// beyond the outer ring at [radius] pixels from the [center].
  ///
  /// For details, see [TileMode].
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/tile_mode_clamp_radial.png)
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/tile_mode_mirror_radial.png)
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/tile_mode_repeated_radial.png)
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/tile_mode_clamp_radialWithFocal.png)
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/tile_mode_mirror_radialWithFocal.png)
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/tile_mode_repeated_radialWithFocal.png)
  ///
  /// Copied from [RadialGradient].
  final TileMode tileMode;

  /// Creates a `ui.Gradient.radial` with duplicated `colors` and `stops`.
  @override
  Shader createShader(Rect rect, {TextDirection? textDirection}) =>
      ui.Gradient.radial(
        center.resolve(textDirection).withinRect(rect),
        radius * rect.shortestSide,
        _duplicateEntries(colors),
        _duplicateEntries(_impliedStops(colors.length))
          ..remove(0)
          ..removeLast(),
        tileMode,
        _resolveTransform(transform, rect, textDirection),
        focal == null ? null : focal!.resolve(textDirection).withinRect(rect),
        focalRadius * rect.shortestSide,
      );

  /// Returns a new [RadialSteps] with its colors scaled by the given factor.
  /// Since the alpha channel is what receives the scale factor,
  /// `0.0` or less results in a gradient that is fully transparent.
  @override
  RadialSteps scale(double factor) => copyWith(
        colors: colors
            .map<Color>((Color color) => Color.lerp(null, color, factor)!)
            .toList(),
      );

  @override
  Gradient? lerpFrom(Gradient? a, double t) => (a == null || (a is RadialSteps))
      ? RadialSteps.lerp(a as RadialSteps?, this, t)
      : super.lerpFrom(a, t);

  @override
  Gradient? lerpTo(Gradient? b, double t) => (b == null || (b is RadialSteps))
      ? RadialSteps.lerp(this, b as RadialSteps?, t)
      : super.lerpTo(b, t);

  /// Copied from [RadialGradient]. \
  /// Linearly interpolate between two [RadialSteps]s.
  ///
  /// If either gradient is null, this function linearly interpolates from a
  /// a gradient that matches the other gradient in [center], [radius], [stops]
  /// and [tileMode] and with the same [colors] but transparent (using [scale]).
  ///
  /// If neither gradient is null, they must have the same number of [colors].
  ///
  /// The `t` argument represents a position on the timeline, with 0.0 meaning
  /// that the interpolation has not started, returning `a` (or something
  /// equivalent to `a`), 1.0 meaning that the interpolation has finished,
  /// returning `b` (or something equivalent to `b`), and values in between
  /// meaning that the interpolation is at the relevant point on the timeline
  /// between `a` and `b`. The interpolation can be extrapolated beyond 0.0 and
  /// 1.0, so negative values and values greater than 1.0 are valid (and can
  /// easily be generated by curves such as `Curves.elasticInOut`).
  ///
  /// Values for `t` are usually obtained from an [Animation<double>], such as
  /// an `AnimationController`.
  static RadialSteps? lerp(RadialSteps? a, RadialSteps? b, double t) {
    if (a == null && b == null) return null;
    if (a == null) return b!.scale(t);
    if (b == null) return a.scale(1.0 - t);
    final interpolated = _interpolate(a, b, t);
    return RadialSteps(
      center: AlignmentGeometry.lerp(a.center, b.center, t)!,
      radius: math.max(0.0, ui.lerpDouble(a.radius, b.radius, t)!),
      colors: interpolated.colors,
      stops: interpolated.stops,
      // TODO: interpolate tile mode
      tileMode: t < 0.5 ? a.tileMode : b.tileMode,
      focal: AlignmentGeometry.lerp(a.focal, b.focal, t),
      focalRadius:
          math.max(0.0, ui.lerpDouble(a.focalRadius, b.focalRadius, t)!),
    );
  }

  /// 📋 Returns a new copy of this `RadialSteps` with any provided
  /// optional parameters overriding those of `this`.
  RadialSteps copyWith({
    List<Color>? colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
    GradientTransform? transform,
  }) =>
      RadialSteps(
        colors: colors ?? this.colors,
        stops: stops ?? this.stops,
        center: center ?? this.center,
        radius: radius ?? this.radius,
        focal: focal ?? this.focal,
        focalRadius: focalRadius ?? this.focalRadius,
        tileMode: tileMode ?? this.tileMode,
        transform: transform ?? this.transform,
      );

  @override
  bool operator ==(Object other) => (identical(this, other))
      ? true
      : (other.runtimeType != runtimeType)
          ? false
          : other is RadialSteps &&
              other.center == center &&
              other.radius == radius &&
              other.tileMode == tileMode &&
              listEquals<Color>(other.colors, colors) &&
              listEquals<double>(other.stops, stops) &&
              other.focal == focal &&
              other.focalRadius == focalRadius;

  @override
  int get hashCode => hashValues(center, radius, tileMode, hashList(colors),
      hashList(stops), focal, focalRadius);

  @override
  String toString() => '${objectRuntimeType(this, 'RadialSteps')}'
      '($center, $radius, $colors, $stops, $tileMode, $focal, $focalRadius)';
}

/// A 2D stepping sweep "gradient".
///
/// This class represents sweep steps, abstracting out
/// the arguments to the [new ui.Gradient.sweep] constructor from `dart:ui`.
///
/// A `SweepSteps` has a [center], a [startAngle], and an [endAngle].
/// The [startAngle] corresponds to `0.0`, and [endAngle] corresponds to `1.0`.
/// These angles are expressed in radians.
///
/// The [colors] are described by a `List<Color>`.
/// The [stops] list, if specified, must have the same length as [colors].
/// It specifies fractions of the vector from start to end, between
/// `0.0` and `1.0`, for each color.
/// If it is `null`, a uniform distribution is assumed.
///
/// The region of the canvas before [startAngle] and after [endAngle]
/// is painted according to [tileMode].
///
/// Typically this class is used with [BoxDecoration], which does the painting.
/// To use a [SweepSteps] to paint directly on a canvas, see [createShader].
///
/// {@tool snippet}
/// ### The left-most example is this `SweepSteps`
/// ![the left-most example is this SweepSteps](https://raw.githubusercontent.com/Zabadam/foil/master/doc/Foils.stepBow.gif 'the left-most example is this SweepSteps')
///
/// ```dart
/// final stepBowSweep = Container(
///   decoration: BoxDecoration(
///     gradient: SweepSteps(
///       tileMode: TileMode.repeated,
///       startAngle: 0.0,
///       endAngle: math.pi * 0.5, // ¼ rotation + TileMode.repeated
///       // endAngle: math.pi * 2, // full rotation
///       colors: [
///         Colors.red, Colors.orange, Colors.yellow, Colors.green,
///         Colors.blue, Colors.indigo, Colors.purple, Colors.pink,
///       ],
///     ),
///   )
/// );
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [SweepGradient], which represents a true sweeping gradient
///  * [RadialSteps], a variety of [RadialGradient] that, like this `Gradient`,
///    steps instead of gradating
///  * [BoxDecoration], which can take a [SweepSteps] in its
///    [BoxDecoration.gradient] property.
class SweepSteps extends Gradient {
  /// Construct a new `SweepSteps` type `Gradient`.
  ///
  /// This gradient resembles a [SweepGradient] but its [colors]
  /// are not smoothly gradated between, but instead hard-transition,
  /// like steps.
  ///
  /// ### The left-most example is a `SweepSteps`
  /// ![the left-most example is a SweepSteps](https://raw.githubusercontent.com/Zabadam/foil/master/doc/Foils.stepBow.gif 'the left-most example is a SweepSteps')
  const SweepSteps({
    this.center = Alignment.center,
    this.startAngle = 0.0,
    this.endAngle = math.pi * 2,
    required List<Color> colors,
    List<double>? stops,
    this.tileMode = TileMode.clamp,
    GradientTransform? transform,
  }) : super(colors: colors, stops: stops, transform: transform);

  /// The center of this `SweepSteps`, as an offset into the
  /// `(-1.0, -1.0) x (1.0, 1.0)` square describing the `Gradient`
  /// which will be mapped onto the paint box.
  ///
  /// For example, an alignment of `(0.0, 0.0)`
  /// will place this `SweepSteps` in the center of the box.
  ///
  /// If this is an [Alignment], then it is expressed as a vector from
  /// coordinate `(0.0, 0.0)` in a coordinate space that maps the center of the
  /// paint box at `(0.0, 0.0)` and the bottom right at `(1.0, 1.0)`.
  ///
  /// It can also be an [AlignmentDirectional], where the start is the `left`
  /// in left-to-right contexts and the `right` in right-to-left contexts.
  /// If a text-direction-dependent value is provided here,
  /// then the [createShader] method will need to be given a [TextDirection].
  ///
  /// Copied from [SweepGradient].
  final AlignmentGeometry center;

  /// The angle in radians at which stop `0.0` of this `SweepSteps` is placed.
  ///
  /// Defaults to `0.0` rad.
  ///
  /// Copied from [SweepGradient].
  final double startAngle;

  /// The angle in radians at which stop `1.0` of this `SweepSteps` is placed.
  ///
  /// Defaults to `math.pi * 2` rad.
  ///
  /// Copied from [SweepGradient].
  final double endAngle;

  /// How this `SweepSteps` should tile the plane
  /// beyond the region before [startAngle] and after [endAngle].
  ///
  /// For details, see [TileMode].
  ///
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/tile_mode_clamp_sweep.png)
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/tile_mode_mirror_sweep.png)
  /// ![](https://flutter.github.io/assets-for-api-docs/assets/dart-ui/tile_mode_repeated_sweep.png)
  ///
  /// Copied from [SweepGradient].
  final TileMode tileMode;

  /// Creates a `ui.Gradient.sweep` with duplicated `colors` and `stops`.
  @override
  Shader createShader(Rect rect, {TextDirection? textDirection}) =>
      ui.Gradient.sweep(
        center.resolve(textDirection).withinRect(rect),
        _duplicateEntries(colors),
        _duplicateEntries(_impliedStops(colors.length))
          ..remove(0)
          ..removeLast(),
        tileMode,
        startAngle,
        endAngle,
        _resolveTransform(transform, rect, textDirection),
      );

  /// Returns a new [SweepSteps] with its colors scaled by the given factor.
  /// Since the alpha channel is what receives the scale factor,
  /// `0.0` or less results in a gradient that is fully transparent.
  @override
  SweepSteps scale(double factor) => copyWith(
        colors: colors
            .map<Color>((Color color) => Color.lerp(null, color, factor)!)
            .toList(),
      );

  @override
  Gradient? lerpFrom(Gradient? a, double t) => (a == null || (a is SweepSteps))
      ? SweepSteps.lerp(a as SweepSteps?, this, t)
      : super.lerpFrom(a, t);

  @override
  Gradient? lerpTo(Gradient? b, double t) => (b == null || (b is SweepSteps))
      ? SweepSteps.lerp(this, b as SweepSteps?, t)
      : super.lerpTo(b, t);

  /// Copied from [SweepGradient]. \
  /// Linearly interpolate between two [SweepSteps]s.
  ///
  /// If either gradient is null, then the non-null gradient is returned with
  /// its color scaled in the same way as the [scale] function.
  ///
  /// If neither gradient is null, they must have the same number of [colors].
  ///
  /// The `t` argument represents a position on the timeline, with 0.0 meaning
  /// that the interpolation has not started, returning `a` (or something
  /// equivalent to `a`), 1.0 meaning that the interpolation has finished,
  /// returning `b` (or something equivalent to `b`), and values in between
  /// meaning that the interpolation is at the relevant point on the timeline
  /// between `a` and `b`. The interpolation can be extrapolated beyond 0.0 and
  /// 1.0, so negative values and values greater than 1.0 are valid (and can
  /// easily be generated by curves such as `Curves.elasticInOut`).
  ///
  /// Values for `t` are usually obtained from an [Animation<double>], such as
  /// an `AnimationController`.
  static SweepSteps? lerp(SweepSteps? a, SweepSteps? b, double t) {
    if (a == null && b == null) return null;
    if (a == null) return b!.scale(t);
    if (b == null) return a.scale(1.0 - t);
    final interpolated = _interpolate(a, b, t);
    return SweepSteps(
      center: AlignmentGeometry.lerp(a.center, b.center, t)!,
      startAngle: math.max(0.0, ui.lerpDouble(a.startAngle, b.startAngle, t)!),
      endAngle: math.max(0.0, ui.lerpDouble(a.endAngle, b.endAngle, t)!),
      colors: interpolated.colors,
      stops: interpolated.stops,
      // TODO: interpolate tile mode
      tileMode: t < 0.5 ? a.tileMode : b.tileMode,
    );
  }

  /// 📋 Returns a new copy of this `SweepSteps` with any provided
  /// optional parameters overriding those of `this`.
  SweepSteps copyWith({
    List<Color>? colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) =>
      SweepSteps(
        colors: colors ?? this.colors,
        stops: stops ?? this.stops,
        center: center ?? this.center,
        startAngle: startAngle ?? this.startAngle,
        endAngle: endAngle ?? this.endAngle,
        tileMode: tileMode ?? this.tileMode,
        transform: transform ?? this.transform,
      );

  @override
  bool operator ==(Object other) => (identical(this, other))
      ? true
      : (other.runtimeType != runtimeType)
          ? false
          : other is SweepSteps &&
              other.center == center &&
              other.startAngle == startAngle &&
              other.endAngle == endAngle &&
              other.tileMode == tileMode &&
              listEquals<Color>(other.colors, colors) &&
              listEquals<double>(other.stops, stops);

  @override
  int get hashCode => hashValues(center, startAngle, endAngle, tileMode,
      hashList(colors), hashList(stops));

  @override
  String toString() => '${objectRuntimeType(this, 'SweepSteps')}'
      '($center, $startAngle, $endAngle, $colors, $stops, $tileMode)';
}
