/// Provides `Foil` wrapper widget
library foil;

import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

import '../animation.dart';
import '../models/foils.dart';
import '../sensors.dart';

/// {@macro foil}
class Foil extends StatefulWidget {
  /// {@template foil}
  /// Wrap a widget with `Foil`, providing a rainbow shimmer \
  /// that twinkles as the accelerometer moves.
  ///
  /// The "rainbow" may be any [gradient] of choice. \
  /// Some pre-rolled are available in [Foils].
  /// {@endtemplate}
  const Foil({
    Key? key,
    this.unwrapped = false,
    this.gradient = Foils.rainbow,
    required this.child,
    this.speed = const Duration(milliseconds: 150),
    this.curve = Curves.ease,
  }) : super(key: key);

  /// Wrap a widget with colored `Foil`, providing a  \
  /// dynamic shimmer that twinkles as the accelerometer moves, \
  /// colored by a looping [LinearGradient] formed from `colors`.
  Foil.colored({
    Key? key,
    this.unwrapped = false,
    required List<Color> colors,
    required this.child,
    this.speed = const Duration(milliseconds: 150),
    this.curve = Curves.ease,
  })  : gradient = LinearGradient(
          colors: colors + colors.reversed.toList(),
          tileMode: TileMode.mirror,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        super(key: key);

  /// Consider some pre-rolled [Foils].
  ///
  /// {@macro unwrapped}
  ///
  /// The default is `Foils.rainbow`: \
  //
  /// Runs through the Material-specified 🎨 "ROYGBIPP"
  /// then loops back to the start.
  //
  // ignore: lines_longer_than_80_chars
  /// ##### 🎨 *ROYGBIPP here means red, orange, yellow, green, blue, indigo, purple, pink.*
  final Gradient gradient;

  /// {@template unwrapped}
  /// If [unwrapped] is `true`, this `Foil`'s [gradient] will be inactive. \
  /// Default is `false`.
  /// {@endtemplate}
  final bool unwrapped;

  /// Wrap this `child` in `Foil`. \
  /// Ideally a single static `Widget`.
  final Widget child;

  /// How rapidly this `Foil` *twinkles* according to device sensor movements.
  ///
  /// That is to say, [speed] is a `Duration` that dictates the animation
  /// of the transformation of this `Foil`'s [gradient].
  final Duration speed;

  /// The `Curve` for the intrinsic animation of this `Foil`.
  final Curve curve;

  @override
  State<StatefulWidget> createState() => _FoilState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Gradient>('gradient', gradient,
          defaultValue: null))
      ..add(DiagnosticsProperty<Duration>('speed', speed, defaultValue: null))
      ..add(DiagnosticsProperty<bool>('unwrapped', unwrapped,
          defaultValue: null));
  }
}

class _FoilState extends State<Foil> {
  double normalizedX = 0, normalizedY = 0;

  @override
  Widget build(BuildContext context) => SensorListener(
        disabled: widget.unwrapped,
        step: const Duration(milliseconds: 1),
        scalar: const [1.0, 1.0], // [x, y]
        onStep: (x, y) => setState(() {
          normalizedX = x;
          normalizedY = y;
        }),
        child: AnimatedFoil(
          gradient: widget.gradient,
          rolloutX: normalizedX,
          rolloutY: normalizedY,
          duration: widget.speed,
          curve: widget.curve,
          child: widget.child,
        ),
      );
}
