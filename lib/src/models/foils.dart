/// Provides `Foils` abstract class with static `const` [Gradient]s.
library foil;

import 'dart:math' as math;

import '../common.dart';

// import 'steps.dart';

/// {@template foils}
/// Pre-rolled `Gradient`s for deployment as `Foil.gradient`
/// or anywhere else a `Gradient` is called for.
/// {@endtemplate}
///
/// Like some things, but want ot change others? Try out `Gradient.copyWith()`.
/// - [linearRainbow] + [linearReversed]
/// - [linearLooping] + [linearLoopingReversed]
/// - [gymClassParachute] + [sitAndSpin]
/// - [oilslick]
/// - [stepBowLinear], [stepBowRadial] + [stepBowSweep]
/// - [rainbow] decal
///
/// ![\`Foils.rainbow\`](https://raw.githubusercontent.com/Zabadam/foil/master/doc/Foils.rainbow.gif) \
/// ![four varieties of linear rainbow gradient](https://raw.githubusercontent.com/Zabadam/foil/master/doc/Foils.linear.gif)
/// ![\`oilslick\`](https://raw.githubusercontent.com/Zabadam/foil/master/doc/Foils.oilslick.gif) \
/// ![\`sitAndSpin\`, and \`gymClassParachute\`](https://raw.githubusercontent.com/Zabadam/foil/master/doc/Foils.gymClass.gif) \
/// ![three new gradients called \`Steps\`](https://raw.githubusercontent.com/Zabadam/foil/master/doc/Foils.stepBow.gif)
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
  ///
  /// ![four varieties of linear rainbow gradient](https://raw.githubusercontent.com/Zabadam/foil/master/doc/Foils.linear.gif)
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
  ///
  /// ![four varieties of linear rainbow gradient](https://raw.githubusercontent.com/Zabadam/foil/master/doc/Foils.linear.gif)
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
  ///
  /// ![four varieties of linear rainbow gradient](https://raw.githubusercontent.com/Zabadam/foil/master/doc/Foils.linear.gif)
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
  ///
  /// ![four varieties of linear rainbow gradient](https://raw.githubusercontent.com/Zabadam/foil/master/doc/Foils.linear.gif)
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

  /// A `LinearGradient` from topLeft to bottomRight that resembles
  /// a pane of glass, with streaks of more-opaque white slicing the gradient.
  static const glass = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x64FFFFFF), // const Color(0xFFFFFFFF).withOpacity(0.25),
      Color(0xA2FFFFFF), // const Color(0xFFFFFFFF).withOpacity(0.40),
      Color(0x74FFFFFF), // const Color(0xFFFFFFFF).withOpacity(0.29),
      Color(0x94FFFFFF), // const Color(0xFFFFFFFF).withOpacity(0.37),
      Color(0x64FFFFFF), // const Color(0xFFFFFFFF).withOpacity(0.25),
      Color(0x71FFFFFF), // const Color(0xFFFFFFFF).withOpacity(0.28),
      Color(0x41FFFFFF), // const Color(0xFFFFFFFF).withOpacity(0.16),
      Color(0x51FFFFFF), // const Color(0xFFFFFFFF).withOpacity(0.20),
      Color(0x92FFFFFF), // const Color(0xFFFFFFFF).withOpacity(0.36),
      Color(0x59FFFFFF), // const Color(0xFFFFFFFF).withOpacity(0.23),
      Color(0x38FFFFFF), // const Color(0xFFFFFFFF).withOpacity(0.15),
      Color(0x25FFFFFF), // const Color(0xFFFFFFFF).withOpacity(0.10),
      Color(0x41FFFFFF), // const Color(0xFFFFFFFF).withOpacity(0.16),
      Color(0x64FFFFFF), // const Color(0xFFFFFFFF).withOpacity(0.25),
    ],
    stops: [
      0.00,
      0.10,
      0.10,
      0.15,
      0.30,
      0.30,
      0.50,
      0.50,
      0.60,
      0.60,
      0.80,
      0.85,
      0.85,
      1.00,
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
  /// ![\`oilslick\`](https://raw.githubusercontent.com/Zabadam/foil/master/doc/Foils.oilslick.gif)
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
  /// `Foils.sitAndSpin.copyWith(...)`, such as:
  /// > ```dart
  /// > copyWith(startAngle: 0.0, endAngle: 0.5 * 3.1416) // 0.5 * math.pi
  /// > // To use math.pi: import 'dart:math' as math`;
  /// > ```
  ///
  /// to align the four colors differently.
  ///
  /// See [gymClassParachute] for a sweep with hard steps. \
  /// ![\`sitAndSpin\`, and \`gymClassParachute\`](https://raw.githubusercontent.com/Zabadam/foil/master/doc/Foils.gymClass.gif) \
  /// ![Gym Class Parachute Activity - gif](https://i.imgur.com/mjFfsHx.gif)
  static const sitAndSpin = SweepGradient(
    tileMode: TileMode.repeated,
    startAngle: 0.0,
    endAngle: math.pi * 0.5, // ¼ rotation + TileMode.repeated
    // endAngle: math.pi * 2, // full rotation
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
  ///
  /// ![\`Foils.rainbow\`](https://raw.githubusercontent.com/Zabadam/foil/master/doc/Foils.rainbow.gif)
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
  /// To create a new `SweepSteps` that has these colors, \
  /// consider `Foils.gymClassParachute.copyWith(...)`, such as:
  /// > ```dart
  /// > copyWith(startAngle: 0.0, endAngle: 0.5 * 3.1416) // 0.5 * math.pi
  /// > // To use math.pi: import 'dart:math' as math`;
  /// > ```
  ///
  /// to align the four colors differently.
  ///
  /// See [gymClassParachute] for a sweep with hard steps. \
  /// ![\`sitAndSpin\`, and \`gymClassParachute\`](https://raw.githubusercontent.com/Zabadam/foil/master/doc/Foils.gymClass.gif) \
  /// ![Gym Class Parachute Activity - gif](https://i.imgur.com/mjFfsHx.gif)
  static const gymClassParachute = SweepSteps(
    tileMode: TileMode.repeated,
    startAngle: -0.0625 * math.pi,
    endAngle: 0.4375 * math.pi, // ¼ rotation + TileMode.repeated
    /// full rotation
    // startAngle: 0.0,
    // endAngle: 2.0 * math.pi,
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
  ///
  /// ![three new gradients called \`Steps\`](https://raw.githubusercontent.com/Zabadam/foil/master/doc/Foils.stepBow.gif)
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
  ///
  /// ![three new gradients called \`Steps\`](https://raw.githubusercontent.com/Zabadam/foil/master/doc/Foils.stepBow.gif)
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
  ///
  /// ![three new gradients called \`Steps\`](https://raw.githubusercontent.com/Zabadam/foil/master/doc/Foils.stepBow.gif)
  static const stepBowSweep = SweepSteps(
    tileMode: TileMode.repeated,
    startAngle: 0.0,
    endAngle: math.pi * 0.5, // ¼ rotation + TileMode.repeated
    // endAngle: math.pi * 2, // full rotation
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
