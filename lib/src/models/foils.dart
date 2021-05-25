/// Provides `Foils` abstract class with static `const` [Gradient]s.
library foil;

import 'package:flutter/material.dart';

import 'steps.dart';

/// {@template foils}
/// Pre-rolled `Gradient`s for deployment as `Foil.gradient`
/// or anywhere else a `Gradient` is called for.
/// - [linearRainbow]
/// - [linearLooping]
/// - [linearLoopingReversed]
/// - [gymClassParachute]
/// - [oilslick]
/// {@endtemplate}
abstract class Foils {
  // ------------------
  // LINEAR GRADIENTS |
  // ------------------

  /// Consider [linearLooping] except instead of looping back to start,
  /// the final [Colors.pink] is followed by one extra [Colors.red]
  /// as the smooth loop.
  ///
  /// To create a new `LinearGradient` that has these colors,
  /// consider `Foils.linearRainbow.copyWith(...)`.
  static const linearRainbow = LinearGradient(
    tileMode: TileMode.repeated,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.pink,
      Colors.red,
    ],
  );

  /// Consider [linearRainbow] except the order of colors is reversed.
  ///
  /// To create a new `LinearGradient` that has these colors,
  /// consider `Foils.linearReversed.copyWith(...)`.
  static const linearReversed = LinearGradient(
    tileMode: TileMode.repeated,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.pink,
      Colors.purple,
      Colors.indigo,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.red,
      Colors.pink,
    ],
  );

  /// {@template rainbow}
  /// Runs through the Material-specified 🎨 "ROYGBIPP"
  /// then loops back to the start.
  ///
  /// Begins `Gradient` at `topLeft` and ends at `bottomRight`. \
  /// Uses [TileMode.repeated] for good measure.
  //
  // ignore: lines_longer_than_80_chars
  /// ##### 🎨 *ROYGBIPP here means red, orange, yellow, green, blue, indigo, purple, pink.*
  ///
  /// To create a new `LinearGradient` that has these colors,
  /// consider `Foils.linearLooping.copyWith(...)`.
  /// {@endtemplate}
  static const linearLooping = LinearGradient(
    tileMode: TileMode.repeated,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.pink,
      Colors.pink,
      Colors.purple,
      Colors.indigo,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.red,
    ],
  );

  /// Consider [linearLooping] but progresses: "PPIBGYOR".
  ///
  /// To create a new `LinearGradient` that has these colors,
  /// consider `Foils.linearLoopingReversed.copyWith(...)`.
  static const linearLoopingReversed = LinearGradient(
    tileMode: TileMode.repeated,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.pink,
      Colors.purple,
      Colors.indigo,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.red,
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.pink,
    ],
  );

  // ------------------
  // RADIAL GRADIENTS |
  // ------------------

  /// A [RadialGradient] that resembles a stylized oil slick.
  ///
  /// To create a new `RadialGradient` that has these colors,
  /// consider `Foils.oilslick.copyWith(...)`,
  /// providing desired `center`, `radius`, or `focal`, etc.
  ///
  /// 🔗 [source](https://www.reddit.com/r/mildlyinteresting/comments/30ipxb/this_oil_slick_puddle_in_my_driveway/)
  /// ![An oilslick on a driveway](https://i.imgur.com/S0Gx5Lc.jpg)
  static const oilslick = RadialGradient(
    tileMode: TileMode.repeated,
    radius: 0.25,
    colors: [
      Color(0xAA888981),
      Color(0xCCCF99B3),
      Color(0xCC86C09F),
      Color(0xCC7993B4),
      Color(0xEE9B78B9),
      Color(0xCCB2928C),
      Color(0x9984AF9F),
      Color(0xAA888981), // smooth loop
    ],
  );

  // -----------------
  // SWEEP GRADIENTS |
  // -----------------

  /// A multicolored [SweepGradient] that looks like a children's gymnasium \
  /// teamwork-activity parachute or the classic children's toy "Sit'n Spin", \
  /// but with blurry edges as if it were spinning.
  ///
  /// To create a new `SweepGradient` that has these colors, consider \
  /// `Foils.sitAndSpin.copyWith(...)`,  providing the desired \
  /// `startAngle`, `endAngle`, and/or `center`.
  ///
  /// See [gymClassParachute] for a sweep with hard steps.
  ///
  /// ![Gym Class Parachute Activity - gif](https://i.imgur.com/mjFfsHx.gif)
  static const sitAndSpin = SweepGradient(
    tileMode: TileMode.repeated,
    startAngle: 0.0,
    endAngle: 3.14159265 * 0.5, // ¼ rotation + TileMode.repeated
    // endAngle: 3.14159265 * 2, // full rotation
    colors: <Color>[
      Color(0xFFEA4335),
      // Color(0xFFB65BF7), // additional purple, but not "classic"
      Color(0xFF4285F4),
      Color(0xFFFBBC05),
      Color(0xFF34A853),
      // Color(0xFFEB679C), // additional pink, but not "classic"
      Color(0xFFEA4335), // smooth loop
    ],
  );

  // ------------------
  // STEPS GRADIENTS |
  // ------------------

  /// A [RadialSteps] that progresses through the rainbow only once.
  ///
  /// To create a new `RadialSteps` that has these colors,
  /// consider `Foils.rainbow.copyWith(...)`
  /// providing desired `radius`, `center`, or `tileMode`, etc.
  ///
  /// `Foils.rainbow.copyWith(tileMode: TileMode.clamp)` would extend
  /// the red band to infinity.
  static const rainbow = RadialSteps(
    tileMode: TileMode.decal,
    radius: 0.6,
    colors: [
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      Colors.pink,
      Colors.purple,
      Colors.indigo,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.red,
    ],
  );

  /// A multicolored [SweepSteps] that looks like a children's
  /// gymnasium teamwork-activity parachute.
  ///
  /// To create a new `SweepSteps` that has these colors, consider \
  /// `Foils.gymClassParachute.copyWith(...)`,  providing the desired \
  /// `startAngle`, `endAngle`, and/or `center`.
  ///
  /// ![Gym Class Parachute Activity - gif](https://i.imgur.com/mjFfsHx.gif)
  static const gymClassParachute = SweepSteps(
    tileMode: TileMode.repeated,
    startAngle: 0.0,
    endAngle: 3.14159265 * 0.5, // ¼ rotation + TileMode.repeated
    // endAngle: 3.14159265 * 2, // full rotation
    colors: <Color>[
      Color(0xFFEA4335),
      // Color(0xFFB65BF7), // additional purple, but not "classic"
      Color(0xFF4285F4),
      Color(0xFFFBBC05),
      Color(0xFF34A853),
      // Color(0xFFEB679C), // additional pink, but not "classic"
    ],
  );

  /// A [LinearSteps] that progresses through the rainbow.
  ///
  /// To create a new `LinearSteps` that has these colors,
  /// consider `Foils.stepBowLinear.copyWith(...)`.
  static const stepBowLinear = LinearSteps(
    tileMode: TileMode.repeated,
    begin: Alignment.topLeft,
    end: Alignment.centerLeft,
    colors: [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.pink,
    ],
  );

  /// A [RadialSteps] that progresses through the rainbow.
  ///
  /// To create a new `RadialSteps` that has these colors,
  /// consider `Foils.stepBowRadial.copyWith(...)`
  /// providing desired `radius`, `center`, or `focal`, etc.
  static const stepBowRadial = RadialSteps(
    tileMode: TileMode.repeated,
    radius: 0.5,
    colors: [
      Colors.pink,
      Colors.purple,
      Colors.indigo,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.orange,
      Colors.red,
    ],
  );

  /// A [SweepSteps] that progresses through the rainbow.
  ///
  /// To create a new `SweepSteps` that has these colors,
  /// consider `Foils.stepBowSweep.copyWith(...)`
  /// providing desired `startAngle`, `endAngle`, or `center`, etc.
  static const stepBowSweep = SweepSteps(
    tileMode: TileMode.repeated,
    startAngle: 0.0,
    endAngle: 3.14159265 * 0.5, // ¼ rotation + TileMode.repeated
    // endAngle: 3.14159265 * 2, // full rotation
    colors: [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
      Colors.pink,
    ],
  );
}
