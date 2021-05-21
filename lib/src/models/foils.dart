/// Provides `Foils` abstract class with static `const` [Gradient]s
library foil;

import 'package:flutter/material.dart';

/// {@template foils}
/// Pre-rolled `Gradient`s for deployment as `Foil.gradient`.
/// {@endtemplate}
abstract class Foils {
  /// {@template rainbow}
  /// Runs through the Material-specified 🎨 "ROYGBIPP"
  /// then loops back to the start.
  ///
  /// Begins `Gradient` at `topLeft` and ends at `bottomRight`. \
  /// Uses [TileMode.repeated] for good measure.
  //
  // ignore: lines_longer_than_80_chars
  /// ##### 🎨 *ROYGBIPP here means red, orange, yellow, green, blue, indigo, purple, pink.*
  /// {@endtemplate}
  static const rainbow = LinearGradient(
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
    tileMode: TileMode.repeated,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// The same as [rainbow] but progresses: "PPIBGYOR".
  static const rainbowReversed = LinearGradient(
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
    tileMode: TileMode.repeated,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Same as [rainbow] except instead of looping back to start,
  /// the final [Colors.pink] is followed by one extra [Colors.red]
  /// as the smooth loop.
  static const rainbowOnce = LinearGradient(
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
    tileMode: TileMode.repeated,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// A gradient that looks like a stylized "oil slick" as a `RadialGradient`.
  static const oilslick = RadialGradient(
    colors: [
      Color(0x99CEEDB3),
      Color(0x99D5773D),
      Color(0x9949BBEB),
      Color(0x999A3E82),
      Color(0x99E8BBC9),
      Color(0x998CD1E0),
      Color(0x99CEEDB3),
    ],
    tileMode: TileMode.repeated,
    radius: 0.5,
  );
}
