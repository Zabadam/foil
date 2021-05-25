// WORK IN PROGRESS
/// Provides `Roll` for defining a large area for a gradient shader
/// to apply to each `Foil` underneath it.
library foil;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../models/crinkle.dart';
import '../models/scalar.dart';
import '../models/transformation.dart';

/// {@macro roll}
class Roll extends StatefulWidget with Diagnosticable {
  /// {@template roll}
  /// Provide a `Roll` for `Foil`.
  ///
  /// ### Sharing Gradients
  /// A [gradient] in an ancestral `Roll` may be provided to a descendent `Foil`
  /// as its `Foil.gradient` if one is not explicitly perscribed in the `Foil`.
  /// - If neither an ancestral `Roll` nor a `Foil` dictates its own `gradient`,
  ///   then the default is `Foils.rainbows.linear`.
  /// - A descendent that provides its own `Foil.gradient`
  ///   will override this [gradient].
  ///
  /// ### Animations
  /// This `Roll` can also serve to provide animation properties
  /// to a descendent `Foil`, regardless if its serving its [gradient].
  ///
  /// The [crinkle] parameter defaults to [Crinkle.smooth] which is
  /// not animated (although each `Roll` has its own `AnimationController`).
  /// A `Crinkle` dictates speed, intensity, and directionality of animation.
  /// - [Crinkle.twinkling] is a very slow moving preset
  /// - [Crinkle.vivacious] is a highly-animated preset
  /// - Build your own or opt to [Crinkle.copyWith] a preset
  ///   - [Crinkle.scalar] property can be used to invert, scale, or negate axes
  ///   - [Crinkle.period] determines the loop `Duration`
  ///
  /// ### A *Literally* Shared `Gradient`
  /// TODO:
  ///
  /// Ideally a `Roll` will allow the definition of a swath of space,
  /// dictated by the tree underneath it, to shade with a single larger
  /// `Gradient`from which any descendent `Foil` widgets could be offset/masked.
  /// {@endtemplate}
  const Roll({
    Key? key,
    this.gradient,
    this.crinkle = Crinkle.smooth,
    this.child,
  }) : super(key: key);

  /// The `Gradient` to provide to any children `Foil` widgets.
  ///
  /// A [gradient] in an ancestral `Roll` may be provided to a descendent `Foil`
  /// as its `Foil.gradient` if one is not explicitly perscribed in the `Foil`.
  /// - If neither an ancestral `Roll` nor a `Foil` dictates its own `gradient`,
  ///   then the default is `Foils.rainbows.loopingLinear`.
  /// - A descendent that provides its own `Foil.gradient`
  ///   will override this [gradient].
  final Gradient? gradient;

  /// This `Roll` can also serve to provide animation properties to
  /// a descendent `Foil`, regardless if its serving its [gradient].
  ///
  /// This [crinkle] parameter defaults to [Crinkle.smooth] which
  /// is not animated (although each Roll has its own `AnimationController`).
  /// A `Crinkle` dictates speed, intensity, and directionality of animation.
  /// - [Crinkle.twinkling] is a very slow moving preset
  /// - [Crinkle.vivacious] is a highly-animated preset
  /// - Build your own or opt to [Crinkle.copyWith] a preset
  ///   - [Crinkle.scalar] property can be used to invert, scale, or negate axes
  ///   - [Crinkle.period] determines the loop Duration
  final Crinkle crinkle;

  /// The widget directly below `this` one in the tree.
  final Widget? child;

  /// Returns the nearest [RollState] ancestor.
  static RollState? of(BuildContext context) =>
      context.findAncestorStateOfType<RollState>();

  @override
  RollState createState() => RollState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
          DiagnosticsProperty<Crinkle>('crinkle', crinkle, defaultValue: null))
      ..add(DiagnosticsProperty<Gradient>('gradient', gradient,
          defaultValue: null));
  }
}

/// Provide a `Roll` of `Foil` such that any descendents may
/// obtain their `Foil.gradient` value from this definition.
///
/// Also provides animation properties regardless of whether
/// it is serving its [gradient] or not.
class RollState extends State<Roll> with SingleTickerProviderStateMixin {
  AnimationController? _rollController;

  /// Access to the internal [AnimationController] for this `RollState`.
  ValueListenable? get rollListenable => _rollController;

  /// The `Gradient` to provide to any children `Foil` widgets.
  Gradient? get gradient => widget.gradient;

  /// Returns whether this `RollState.widget.crinkle.isAnimated`.
  bool get isAnimated => widget.crinkle.isAnimated;

  /// Returns this `RollState.widget.crinkle.scalar` for animation.
  Scalar get scalar => widget.crinkle.scalar;

  /// Returns this `RollState.widget.crinkle.transform` for animation.
  TransformGradient? get transform => widget.crinkle.transform;

  /// Returns the `size` of the [RenderBox] representing this `RollState`.
  Size get size => (context.findRenderObject() as RenderBox).size;

  /// Whether the [RenderBox] representing this `RollState` has size.
  bool get isSized => (context.findRenderObject() == null)
      ? false
      : (context.findRenderObject() as RenderBox).hasSize;

  /// Returns an `Offset` of the provided `RenderBox descendent`,
  /// along with any additional passed `offset`, within this parent [Roll].
  Offset getDescendantOffset({
    required RenderBox descendant,
    Offset offset = Offset.zero,
  }) =>
      descendant.localToGlobal(offset,
          ancestor: context.findRenderObject() as RenderBox);

  @override
  void initState() {
    super.initState();
    // We will do it anyway for now
    // so that a `Crinkle.isAnimated` may be toggled freely.
    // if (widget.crinkle.isAnimated)
    _initController();
  }

  void _initController() {
    _rollController = AnimationController.unbounded(vsync: this)
      ..repeat(
        // TODO: update these values if changed
        min: widget.crinkle.min,
        max: widget.crinkle.max,
        period: widget.crinkle.period,
        reverse: widget.crinkle.shouldReverse,
      );
  }

  @override
  void dispose() {
    _rollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child ?? const SizedBox();
}
