/// Provides `Sheet` parameter wrapper object that mimics the properties
/// for [Container] used in styling  a `new Foil.sheet()`.
library foil;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// {@macro sheet}
class Sheet with Diagnosticable {
  /// {@template sheet}
  /// A wrapper for the parameters that pertain to an `Animated`/[Container].
  ///
  /// If not provided an initializing `color` nor
  /// `decoration`, this field defaults to [Colors.black] so that a `Foil.sheet`
  /// has pixels to which it can mask its gradient.
  ///
  /// Note that if provided a [decoration], but that [Decoration] has no color,
  /// and no initializing `color` value was provided either, this `Sheet` may
  /// potentially result in a layer that has no pixels to which a `Foil`
  /// may be masked.
  ///
  /// See also:
  /// - [new Container], whose properties this `Sheet` mimics
  /// {@endtemplate}
  const Sheet({
    Color? color,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.alignment,
    this.decoration,
    this.foregroundDecoration,
    this.clipBehavior = Clip.none,
    this.constraints,
    this.transform,
    this.transformAlignment,
  }) : color = (color == null && decoration == null) ? Colors.black : color;

  /// Background color. If not provided an initializing `color` nor
  /// `decoration`, this field defaults to [Colors.black] so that a `Foil.sheet`
  /// has pixels to which it can mask its gradient.
  ///
  /// Note that if provided a [decoration], but that [Decoration] has no color,
  /// and no initializing `color` value was provided either, this `Sheet` may
  /// potentially result in a layer that has no pixels to which a `Foil`
  /// may be masked.
  final Color? color;

  /// Provide intrinsic dimensions.
  final double? width, height;

  /// `EdgeInsets` to apply on the outside edge, condensing the space
  /// available to the container and content within it.
  final EdgeInsetsGeometry? margin;

  /// `EdgeInsets` to apply on the inner edge, padding the content within.
  final EdgeInsetsGeometry? padding;

  /// See [Container.alignment].
  final AlignmentGeometry? alignment;

  /// A [Decoration], likely a [BoxDecoration] or [ShapeDecoration],
  /// to apply as a background. This can define color, shape, border and more.
  final Decoration? decoration;

  /// A [Decoration], likely a [BoxDecoration], to apply as a decoration
  /// in the front layer of presentation.
  final Decoration? foregroundDecoration;

  /// Default is [Clip.none] which allows visual overflow. \
  /// Clipping has performance implications. See also: [Container.clipBehavior].
  final Clip clipBehavior;

  /// Constrain dimensions.
  final BoxConstraints? constraints;

  /// A [Matrix4] is a complex array of 0s or other values that describe
  /// how to translate, rotate, offset, shift perspective, or otherwise
  /// transform the widget.
  final Matrix4? transform;

  /// If providing a [transform], optionally specify how to align it.
  final AlignmentGeometry? transformAlignment;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(ColorProperty('color', color, defaultValue: null))
      ..add(DoubleProperty('width', width, defaultValue: false))
      ..add(DoubleProperty('height', height, defaultValue: false))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry>('margin', margin,
          defaultValue: false))
      ..add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding,
          defaultValue: false))
      ..add(DiagnosticsProperty<AlignmentGeometry>('alignment', alignment,
          defaultValue: false))
      ..add(DiagnosticsProperty<Decoration>('decoration', decoration,
          defaultValue: false))
      ..add(DiagnosticsProperty<Decoration>(
          'foregroundDecoration', foregroundDecoration, defaultValue: false))
      ..add(DiagnosticsProperty<Clip>('clipBehavior', clipBehavior,
          defaultValue: false))
      ..add(DiagnosticsProperty<BoxConstraints>('constraints', constraints,
          defaultValue: false))
      ..add(DiagnosticsProperty<Matrix4>('transform', transform,
          defaultValue: false))
      ..add(DiagnosticsProperty<AlignmentGeometry>(
          'transformAlignment', transformAlignment,
          defaultValue: false));
  }
}
