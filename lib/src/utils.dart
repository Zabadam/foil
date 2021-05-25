/// Provides utilities for copying `Gradient`s
/// - [GradientUtils] - 📋 `copyWith`
/// - [LinearGradientUtils] - 📋 `copyWith`
/// - [RadialGradientUtils] - 📋 `copyWith`
/// - [SweepGradientUtils] - 📋 `copyWith`
library foil;

import 'package:flutter/painting.dart';

import 'models/steps.dart';

/// Offers [copyWith] method to make duplicate `Gradient`s.
extension LinearGradientUtils on LinearGradient {
  /// 📋 Returns a new copy of this `LinearGradient` with any provided
  /// optional parameters overriding those of `this`.
  LinearGradient copyWith({
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    List<Color>? colors,
    List<double>? stops,
    TileMode? tileMode,
    GradientTransform? transform,
  }) =>
      LinearGradient(
        begin: begin ?? this.begin,
        end: end ?? this.end,
        colors: colors ?? this.colors,
        stops: stops ?? this.stops,
        tileMode: tileMode ?? this.tileMode,
        transform: transform ?? this.transform,
      );
}

/// Offers [copyWith] method to make duplicate `Gradient`s.
extension RadialGradientUtils on RadialGradient {
  /// 📋 Returns a new copy of this `RadialGradient` with any provided
  /// optional parameters overriding those of `this`.
  RadialGradient copyWith({
    AlignmentGeometry? center,
    double? radius,
    List<Color>? colors,
    List<double>? stops,
    TileMode? tileMode,
    AlignmentGeometry? focal,
    double? focalRadius,
    GradientTransform? transform,
  }) =>
      RadialGradient(
        center: center ?? this.center,
        radius: radius ?? this.radius,
        colors: colors ?? this.colors,
        stops: stops ?? this.stops,
        tileMode: tileMode ?? this.tileMode,
        focal: focal ?? this.focal,
        focalRadius: focalRadius ?? this.focalRadius,
        transform: transform ?? this.transform,
      );
}

/// Offers [copyWith] method to make duplicate `Gradient`s.
extension SweepGradientUtils on SweepGradient {
  /// 📋 Returns a new copy of this `SweepGradient` with any provided
  /// optional parameters overriding those of `this`.
  SweepGradient copyWith({
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    List<Color>? colors,
    List<double>? stops,
    TileMode? tileMode,
    GradientTransform? transform,
  }) =>
      SweepGradient(
        center: center ?? this.center,
        startAngle: startAngle ?? this.startAngle,
        endAngle: endAngle ?? this.endAngle,
        colors: colors ?? this.colors,
        stops: stops ?? this.stops,
        tileMode: tileMode ?? this.tileMode,
        transform: transform ?? this.transform,
      );
}

// TODO: Reconsider. Check <T>?
/// Offers [copyWith] method to make duplicate `Gradient`s.
extension GradientUtils on Gradient {
  /// 📋 Returns a new copy of this `Gradient` with any appropriate
  /// optional parameters overriding those of `this`.
  ///
  /// Recognizes [LinearGradient], [RadialGradient], & [SweepGradient],
  /// as well as this package's [LinearSteps], [RadialSteps], & [SweepSteps].
  ///
  /// Defaults back to [LinearGradient] if `Type` cannot be matched.
  ///
  /// ```dart
  /// Gradient copyWith({
  // ignore: lines_longer_than_80_chars
  ///   List<Color>? colors, List<double>? stops, GradientTransform? transform, TileMode? tileMode,
  ///   // Linear
  ///   AlignmentGeometry? begin, AlignmentGeometry? end,
  ///   // Radial or Sweep
  ///   AlignmentGeometry? center,
  ///   // Radial
  ///   double? radius, AlignmentGeometry? focal, double? focalRadius,
  ///   // Sweep
  ///   double? startAngle, double? endAngle,
  /// })
  /// ```
  Gradient copyWith({
    List<Color>? colors,
    List<double>? stops,
    GradientTransform? transform,
    TileMode? tileMode,
    // Linear
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    // Radial or Sweep
    AlignmentGeometry? center,
    // Radial
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    // Sweep
    double? startAngle,
    double? endAngle,
  }) =>
      (this is RadialGradient)
          ? RadialGradient(
              colors: colors ?? this.colors,
              stops: stops ?? this.stops,
              transform: transform ?? this.transform,
              tileMode: tileMode ?? (this as RadialGradient).tileMode,
              center: center ?? (this as RadialGradient).center,
              radius: radius ?? (this as RadialGradient).radius,
              focal: focal ?? (this as RadialGradient).focal,
              focalRadius: focalRadius ?? (this as RadialGradient).focalRadius,
            )
          : (this is SweepGradient)
              ? SweepGradient(
                  colors: colors ?? this.colors,
                  stops: stops ?? this.stops,
                  transform: transform ?? this.transform,
                  tileMode: tileMode ?? (this as SweepGradient).tileMode,
                  center: center ?? (this as SweepGradient).center,
                  startAngle: startAngle ?? (this as SweepGradient).startAngle,
                  endAngle: endAngle ?? (this as SweepGradient).endAngle,
                )
              : (this is LinearSteps)
                  ? LinearSteps(
                      colors: colors ?? this.colors,
                      stops: stops ?? this.stops,
                      transform: transform ?? this.transform,
                      tileMode: tileMode ?? (this as LinearSteps).tileMode,
                      begin: begin ?? (this as LinearSteps).begin,
                      end: end ?? (this as LinearSteps).end,
                    )
                  : (this is RadialSteps)
                      ? RadialSteps(
                          colors: colors ?? this.colors,
                          stops: stops ?? this.stops,
                          transform: transform ?? this.transform,
                          tileMode: tileMode ?? (this as RadialSteps).tileMode,
                          center: center ?? (this as RadialSteps).center,
                          radius: radius ?? (this as RadialSteps).radius,
                          focal: focal ?? (this as RadialSteps).focal,
                          focalRadius:
                              focalRadius ?? (this as RadialSteps).focalRadius,
                        )
                      : (this is SweepSteps)
                          ? SweepSteps(
                              colors: colors ?? this.colors,
                              stops: stops ?? this.stops,
                              transform: transform ?? this.transform,
                              tileMode:
                                  tileMode ?? (this as SweepSteps).tileMode,
                              center: center ?? (this as SweepSteps).center,
                              startAngle:
                                  startAngle ?? (this as SweepSteps).startAngle,
                              endAngle:
                                  endAngle ?? (this as SweepSteps).endAngle,
                            )
                          : LinearGradient(
                              colors: colors ?? this.colors,
                              stops: stops ?? this.stops,
                              transform: transform ?? this.transform,
                              tileMode:
                                  tileMode ?? (this as LinearGradient).tileMode,
                              begin: begin ?? (this as LinearGradient).begin,
                              end: end ?? (this as LinearGradient).end,
                            );
}
