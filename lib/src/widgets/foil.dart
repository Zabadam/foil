/// Provides the [new Foil] wrapper widget, as well as gradient-building
/// [new Foil.colored] and self-contained [new Foil.sheet].
library foil;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

import '../animation.dart';
import '../models/crinkle.dart';
import '../models/foils.dart';
import '../models/nill.dart';
import '../models/scalar.dart';
import '../models/sheet.dart';
import '../models/steps.dart';
import 'roll.dart';
import 'sensors.dart';

/// {@macro foil}
class Foil extends StatefulWidget {
  /// {@template foil}
  /// Wrap a widget with `Foil`, providing a rainbow shimmer \
  /// that twinkles as the accelerometer moves.
  ///
  /// The "rainbow" may be any [gradient] of choice. \
  /// Some pre-rolled are available in [Foils].
  ///
  /// Paramater `bool` [isUnwrapped] toggles this `Foil`'s invisibility. \
  /// Default is `false.`
  ///
  /// ### Accelerometer
  /// Disable this `Foil`'s reaction to accelerometer sensor motion by \
  /// `useSensor: false`. Default is `true`.
  ///
  /// Influence the intensity of this `Foil`'s reaction to accelerometer motion \
  /// by providing a custom `Scalar` [scalar]. Default is [Scalar.identity] \
  /// which has both a `horizontal` and `vertical` multiplier of `+1.0`.
  ///
  /// (Not to be confused with a potential and optional `Crinkle.scalar`, \
  /// provided by wrapping `Foil` in a `Roll` and declaring `Roll.crinkle`. \
  /// This [Scalar] is used to scale axis-dependent animation values.)
  ///
  /// ### Using a `Roll` of `Foil`
  /// Optionally a [Roll] may be deployed higher up in the widget tree. \
  /// This ancestor offers two additional features to any [Foil] underneath it.
  ///
  /// Either declare a [Roll.gradient] to which any descendent `Foil`
  /// may fallback and/or provide a [Roll.crinkle] to make declarations about
  /// gradient animation beyond accelerometer sensors data.
  ///
  /// See [Crinkle] for more information.
  ///
  /// ### Transitioning
  /// Control how rapidly this `Foil` transforms its [gradient]
  /// with [speed] and define the animation [curve]. \
  /// Defaults are `150ms` and [Curves.ease].
  ///
  /// Furthermore, provide [duration] to dictate how long
  /// intrinsic animations of this `Foil`'s [gradient] will take.
  /// [duration] is also used if [isUnwrapped] is made `true` as the duration
  /// over which [gradient] will [Gradient.lerp] to an appropriately-`Type`d
  /// transparent gradient for tweening.
  ///
  /// There is hard-coded recognition for linear, radial, and sweep [Gradient]s, \
  /// as well as the additional [LinearSteps], [RadialSteps], and [SweepSteps] \
  /// variants that this package provides. Falls back to [LinearGradient]
  /// ([nillLG]) if `Type` cannot be matched.
  ///
  /// Upon completion of any tween to a new [gradient], this `Foil` will
  /// call [onEnd], an optional void callback.
  /// {@endtemplate}
  const Foil({
    Key? key,
    this.isUnwrapped = false,
    this.opacity = 1.0,
    this.useSensor = true,
    this.gradient,
    this.blendMode = BlendMode.srcATop,
    this.scalar = const Scalar(),
    this.unwrappedGradient,
    required this.child,
    this.speed = const Duration(milliseconds: 150),
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.ease,
    this.onEnd,
  })  : sheet = const Sheet(),
        _box = null,
        super(key: key);

  /// Wrap a widget with colored `Foil`, providing a  \
  /// dynamic shimmer that twinkles as the accelerometer moves, \
  /// colored by a looping [LinearGradient] formed from `colors`.
  ///
  /// Influence the intensity of this `Foil`'s reaction to accelerometer motion \
  /// by providing a custom `Scalar` [scalar]. Default is `const Scalar()` \
  /// which has both a `horizontal` and `vertical` multiplier of `1.0`.
  ///
  /// Paramater `bool` [isUnwrapped] toggles this `Foil`'s invisibility. \
  /// Default is `false.`
  ///
  /// Control how rapidly this `Foil` transforms its [gradient]
  /// with [speed] and define the animation [curve].
  /// Defaults are `150ms` and [Curves.ease].
  ///
  /// Furthermore, provide [duration] to dictate how long
  /// intrinsic animations of this `Foil`'s [gradient] will take.
  /// [duration] is also used if [isUnwrapped] is made `true` as the duration
  /// over which [gradient] will [Gradient.lerp] to an appropriately-`Type`d
  /// transparent gradient for tweening.
  Foil.colored({
    Key? key,
    this.isUnwrapped = false,
    this.opacity = 1.0,
    this.useSensor = true,
    required List<Color> colors,
    this.blendMode = BlendMode.srcATop,
    this.scalar = Scalar.identity,
    this.unwrappedGradient,
    required this.child,
    this.speed = const Duration(milliseconds: 150),
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.ease,
    this.onEnd,
  })  : sheet = const Sheet(),
        _box = null,
        // TODO: update default
        gradient = LinearGradient(
          colors: colors + colors.reversed.toList(),
          tileMode: TileMode.mirror,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        super(key: key);

  /// Create a sizeable `Widget` with the specified [gradient] and all the
  /// same properties as a standard `Foil`, but as its own standalone
  /// [AnimatedContainer] with or without a [child].
  ///
  /// Use [sheet] to stylize the container.
  Foil.sheet({
    Key? key,
    this.sheet = const Sheet(),
    this.isUnwrapped = false,
    this.opacity = 1.0,
    this.useSensor = true,
    this.gradient,
    this.blendMode = BlendMode.srcATop,
    this.scalar = Scalar.identity,
    this.unwrappedGradient,
    Widget? child,
    this.speed = const Duration(milliseconds: 150),
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.ease,
    this.onEnd,
  })  : child = child ?? const SizedBox(),
        _box = AnimatedContainer(
          width: sheet.width,
          height: sheet.height,
          margin: sheet.margin,
          padding: sheet.padding,
          alignment: sheet.alignment,
          color: sheet.color,
          decoration: sheet.decoration,
          foregroundDecoration: sheet.foregroundDecoration,
          clipBehavior: sheet.clipBehavior,
          constraints: sheet.constraints,
          transform: sheet.transform,
          transformAlignment: sheet.transformAlignment,
          duration: duration,
          curve: curve,
          child: child,
        ),
        super(key: key);

  /// {@template unwrapped}
  /// If [isUnwrapped] is `true`, this `Foil`'s [gradient] will be inactive. \
  /// Default is `false`.
  /// {@endtemplate}
  final bool isUnwrapped;

  /// Override the alpha channels in this `Foil`'s [gradient] by providing
  /// an [opacity] value by which the gradient will be [Gradient.scale]d.
  final double opacity;

  /// Customize the visual appearance of this `Foil`. \
  /// If [isUnwrapped] is `true`, this `Foil`'s [gradient] will be deactivated,
  /// smoothly transitioning to an invisible state.
  ///
  /// It is recommended to use a [Gradient] \
  /// that starts and ends with the same `Color`. \
  /// [LinearSteps] or the other steps gradients could handle this aspect.
  ///
  /// This `Gradient` will intrinsically animate to any changed
  /// [gradient] value by [Gradient.lerp] over [duration] and [curve].
  ///
  /// Consider some pre-rolled [Foils]. \
  /// The default is `Foils.linearLooping` if this `Foil`
  /// is not given a [gradient].
  ///
  /// ### Using a `Roll` of `Foil`
  /// Optionally a [Roll] may be deployed higher up in the widget tree.
  ///
  /// Declare a [Roll.gradient] to which any descendent `Foil`
  /// may fallback, though this [gradient] will override any `Roll`s'.
  final Gradient? gradient;

  /// Override the empty, transparent `Gradient` that this `Foil` transitions
  /// to when [isUnwrapped] is made true.
  ///
  /// By default, an attempt is made to match the `Type` of gradient to an
  /// appropriately-typed empty gradient.
  ///
  /// See [nillLG], et al.
  final Gradient? unwrappedGradient;

  /// A `Scalar` provides an opportunity to modify horizontal and vertical
  /// accelerometer sensor data independently before they translate to `Foil`
  /// [gradient] "twinkling" transformation (offset/translation).
  ///
  /// Scale up the motion factor by providing [Scalar.horizontal] or
  /// [Scalar.vertical] a value greater than `1.0`,
  /// or scale down the influence by providing `0 <= scalar <= 1.0`.
  final Scalar scalar;

  /// The [BlendMode] utilized in painting this `Foil`'s [gradient]
  /// over its [child].
  ///
  /// Default is [BlendMode.srcATop], which will envelop the child
  /// in the [gradient] entirely, masking the gradient out in areas
  /// where the child is transparent.
  /// > Note that if the gradient has transparency itself, then the child
  /// will be visible through it.
  /// > [Foils.oilslick] is one such `Gradient` with transparency, for example.
  ///
  /// Utilizing [BlendMode.srcIn] will paint only this `Foil`'s [gradient], \
  /// masking out the [child] entirely.
  /// ---
  /// Other `BlendMode`s may be experimented with to achieve neat results
  /// when combined with bespoke `Gradient`s.
  final BlendMode blendMode;

  /// Default is `true`. Optionally determine if this `Foil` is agnostic
  /// to accelerometer sensors data. In this case, it will be a simple static
  /// gradient mask.
  ///
  /// That is unless this `Foil` is wrapped in a ancestor `Roll`
  /// which has a `Crinkle` that defines animation properties.
  ///
  /// Those `Crinkle` animations can be applied regardless of the value
  /// of [useSensor].
  final bool useSensor;

  /// Wrap this `child` in `Foil`. \
  /// Ideally, for performance, a single static `Widget`.
  final Widget child;

  /// The `Duration` over which any changes to this
  /// `Foil`'s [gradient] will intrinsically animate.
  ///
  /// Furthermore, if [isUnwrapped] is made `true`, [gradient] will smoothly
  /// [Gradient.lerp] to an appropriately-`Type`d transparent gradient for
  /// tweening over [duration].
  final Duration duration;

  /// How rapidly this `Foil` *twinkles* according to device sensor movements.
  ///
  /// That is to say, [speed] is a `Duration` that dictates the animation
  /// of the transformation (offset/translation) of this `Foil`'s [gradient].
  final Duration speed;

  /// The `Curve` for the animation of this `Foil`, either by
  /// translation through accelerometer movements or by altering [gradient].
  final Curve curve;

  /// Register a callback `Function` to perform when this `Foil` finishes
  /// transitioning intrinsically from one [gradient] to another.
  final VoidCallback? onEnd;

  /// Made non-null by [Foil.sheet] and then wraps [child].
  final Widget? _box;

  /// Only applicable for a self-contained [Foil.sheet]. \
  /// Defaults `null` unless constructing a `Foil.sheet`, where default is
  /// [new Sheet].
  ///
  /// To style a `Foil.sheet`, provide a [Sheet] object. A `Sheet` is a simple
  /// wrapped for any of the potential parameters for a [Container].
  ///
  /// If no [Sheet.color] or `decoration` is provided, this widget will fallback
  /// to rendering as [Colors.black] in order to provide a mask for this `Foil`.
  final Sheet sheet;

  @override
  _FoilState createState() => _FoilState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('isUnwrapped', isUnwrapped,
          defaultValue: false))
      ..add(
          DiagnosticsProperty<bool>('useSensor', useSensor, defaultValue: true))
      ..add(DiagnosticsProperty<Scalar>('scalar', scalar, defaultValue: null))
      ..add(DiagnosticsProperty<BlendMode>('blendMode', blendMode,
          defaultValue: null))
      ..add(DiagnosticsProperty<Duration>('speed', speed, defaultValue: null))
      ..add(DiagnosticsProperty<Duration>('duration', duration,
          defaultValue: null))
      ..add(DiagnosticsProperty<Sheet>('sheet', sheet,
          defaultValue: null, ifNull: 'this is not a `Foil.sheet`'))
      ..add(DiagnosticsProperty<Gradient>('gradient', gradient,
          defaultValue: null));
  }
}

class _FoilState extends State<Foil> {
  /// Ranges from `-1.0..1.0` basedon on accelerometer sensor data.
  double normalizedX = 0, normalizedY = 0;

  /// Values come from [rollController] which drives an animation from any
  /// potential ancestral [Roll.crinkle]'s `Crinkle.min` -> `Crinkle.max`
  /// values. Further multiplied by `Crinkle.scalar`, a [Scalar] that allows
  /// per-axis scaling (up, down, negation, inversion).
  double rollX = 0, rollY = 0;

  /// A potential value from an [AnimationController]
  /// in a potential ancestral [Roll].
  ValueListenable? rollController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (rollController != null) {
      rollController!.removeListener(onRollChange);
    }
    rollController = Roll.of(context)?.rollListenable;
    if (rollController != null) {
      rollController!.addListener(onRollChange);
    }
  }

  @override
  void dispose() {
    rollController?.removeListener(onRollChange);
    super.dispose();
  }

  void onRollChange() => (!widget.isUnwrapped) ? setState(() {}) : null;

  @override
  Widget build(BuildContext context) {
    /// For inversion of axes for accelerometer data based on orientation.
    final isPortrait =
        (MediaQuery.maybeOf(context)?.orientation ?? Orientation.portrait) ==
            Orientation.portrait;

    /// There may be a [Roll] above this `Foil`.
    final roll = Roll.of(context);
    final gradient = widget.gradient ?? roll?.gradient ?? Foils.linearLooping;

    /// Plan is to *allow* the "cutting" of any descendent `Foil`s
    /// from an ancestral `Roll` gradient, but we're getting cast errors
    /// that "null is not of type RenderBox" when checking [roll.isSized].
    // final rollSize = roll?.size; // check ifSized first
    // ignore: lines_longer_than_80_chars
    // final rollOffset = roll?.getDescendantOffset(descendant: context.findRenderObject() as RenderBox);

    /// For smoother `lerp`s when unwrapping `Foil`.
    final effectiveGradient = widget.isUnwrapped
        ? widget.unwrappedGradient ??
            (gradient.runtimeType == RadialGradient
                ? nillRG
                : gradient.runtimeType == SweepGradient
                    ? nillSG
                    : gradient.runtimeType == LinearSteps
                        ? nillLS
                        : gradient.runtimeType == RadialSteps
                            ? nillRS
                            : gradient.runtimeType == SweepSteps
                                ? nillSS
                                : nillLG)
        : gradient.scale(widget.opacity);

    /// The `SensorListener` and `AnimatedFoil` need to be built regardless of
    /// whether a parent `Roll.crinkle.isAnimated` or not (or even exists).
    Widget _foil() => SensorListener(
          // disabled: widget.isUnwrapped, // stop sensor updates when unwrapped
          disabled: false,
          step: const Duration(milliseconds: 1),
          scalar: widget.scalar,
          onStep: (x, y) => setState(() {
            normalizedX = x;
            normalizedY = y;
          }),
          child: AnimatedFoil(
            gradient: effectiveGradient,
            rolloutX: [rollX, (isPortrait ? normalizedX : -normalizedY)],
            rolloutY: [rollY, (isPortrait ? -normalizedY : -normalizedX)],
            blendMode: widget.blendMode,
            useSensor: widget.useSensor,
            speed: widget.speed,
            duration: widget.duration,
            curve: widget.curve,
            onEnd: widget.onEnd,
            child: widget._box ?? widget.child, // _box created by `Foil.sheet`
          ),
        );

    return (roll != null && roll.isAnimated)
        ? ValueListenableBuilder(
            valueListenable: rollController!,
            builder: (_, value, child) {
              rollX = roll.scalar.horizontal * (value as double);
              rollY = roll.scalar.vertical * value;
              return _foil();
            },
          )
        : _foil();
  }
}
