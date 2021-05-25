/// Wrap a widget with `Foil`, providing a rainbow shimmer
/// that twinkles as the accelerometer moves.
///
/// ## [pub.dev Listing](https://pub.dev/packages/foil) | [API Doc](https://pub.dev/documentation/foil/latest) | [GitHub](https://github.com/Zabadam/foil/tree/main/lib)
/// #### API References: [`Foil`](https://pub.dev/documentation/foil/latest/foil/Foil-class.html) | [`Foils`](https://pub.dev/documentation/foil/latest/foil/Foils-class.html) | [`Roll`](https://pub.dev/documentation/foil/latest/foil/Roll-class.html) | [`Crinkle`](https://pub.dev/documentation/foil/latest/foil/Crinkle-class.html) | [`Foil.sheet`](https://pub.dev/documentation/foil/latest/foil/Foil/Foil.sheet.html) | [`Steps`](https://pub.dev/documentation/foil/latest/foil/LinearSteps-class.html) | [`GradientUtils`](https://pub.dev/documentation/foil/latest/foil/LinearGradientUtils.html)
///
/// ### Extra Goodies
/// 0. Three new variety of `Gradient` that do not gradate, but hard-transition:
///    - `LinearSteps`
///    - `RadialSteps`
///    - `SweepSteps` 😏
///
/// 1. `Foils` abstract class
///    - Variety of static const `Gradient`s
///    - `Foils.rainbow` is the default for new `Foil`
///
/// 2. `GradientUtils` extensions for each `Gradient`
///    - `Gradient copyWith()` methods
///
/// 3. `GradientTween` specializing `Tween<Gradient>` to use `Gradient.lerp()`.
library foil;

export 'src/models/crinkle.dart';
export 'src/models/foils.dart';
export 'src/models/scalar.dart';
export 'src/models/sheet.dart';
export 'src/models/steps.dart';
export 'src/models/transformation.dart';
export 'src/models/tween.dart'; // Flutter should have them anyway :)
// export 'src/sensors.dart'; // could export the `SensorListener`
export 'src/utils.dart';
export 'src/widgets/foil.dart';
export 'src/widgets/roll.dart'; // work in progress
