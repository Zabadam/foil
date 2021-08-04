/// Provides `SensorListener` encapsulation for accelerometer data
/// as well as corresponding `SensorCallback` for acting on that data.
library foil;

import 'dart:async';

import 'package:sensors_plus/sensors_plus.dart';

import '../common.dart';

/// {@template sensor_callback}
/// A callback used to provide a parent with actionable, normalized
/// accelerometer sensor data as `double`s between `-1..1`.
///
/// [SensorListener.onStep] is invoked every [SensorListener.step].
/// {@endtemplate}
typedef SensorCallback = void Function(double normalizedX, double normalizedY);

/// {@macro sensor_listener}
class SensorListener extends StatefulWidget {
  /// {@macro sensor_listener}
  const SensorListener._({
    Key? key,
    required this.disabled,
    required this.step,
    required this.scalar,
    required this.child,
    required this.onStep,
  }) : super(key: key);

  /// {@template sensor_listener}
  /// A widget that listens to accelerometer sensor data
  /// and returns that data as an actionable `-1..1` value,
  /// one each for the X axis and Y axis, as a [SensorCallback].
  /// {@endtemplate}
  factory SensorListener({
    Key? key,
    required bool disabled,
    required Duration step,
    required Scalar scalar,
    required Widget child,
    required SensorCallback onStep,
  })
      // { if (!_cache.containsKey(child)) {
      //     _cache[child] = SensorListener._(
      //       key: key,
      //       disabled: disabled,
      //       step: step,
      //       scalar: scalar,
      //       onStep: onStep,
      //       child: child,
      //     );
      //   }
      //   return _cache[child]!; }
      =>
      SensorListener._(
        key: key,
        disabled: disabled,
        step: step,
        scalar: scalar,
        onStep: onStep,
        child: child,
      );

  // static final Map<Widget, SensorListener> _cache = {};

  /// If `disabled` is `true`, then this `SensorListener`
  /// will stop making [onStep] invocations.
  final bool disabled;

  /// `Duration` between [onStep] `SensorCallback` updates.
  final Duration step;

  /// {@macro scalar}
  final Scalar scalar;

  /// The `child` of this listener, returned from `build`.
  final Widget child;

  /// {@macro sensor_callback}
  final SensorCallback onStep;

  @override
  _SensorListenerState createState() => _SensorListenerState();
}

class _SensorListenerState extends State<SensorListener> {
  double x = 0, y = 0;
  AccelerometerEvent accelEvent = AccelerometerEvent(0, 0, 0);
  late StreamSubscription<AccelerometerEvent> accelSubscription;
  late Timer stepTimer;

  @override
  void initState() {
    super.initState();
    initSensor();
  }

  void initSensor() async {
    stepTimer = Timer.periodic(widget.step, (_) => step());
    accelSubscription = accelerometerEvents
        .listen((event) => setState(() => accelEvent = event));
  }

  /// Normalize `x` and `y` values to `-1..1`.
  /// `AccelerometerEvent.x,y` values range from `-10..10`.
  double normalize(double sample) => 2 * (sample + 10) / 20 - 1;

  void step() {
    x = -normalize(accelEvent.x) * widget.scalar.horizontal;
    y = -normalize(accelEvent.y) * widget.scalar.vertical;
    if (widget.disabled) {
      accelSubscription.pause();
    } else {
      accelSubscription.resume();
    }
    widget.onStep(x, y);
  }

  /// Return the child as this stateful SensorListener.
  @override
  Widget build(BuildContext context) => widget.child;

  /// Cancel timer and sensor stream subscription.
  @override
  void dispose() {
    stepTimer.cancel();
    accelSubscription.cancel();
    super.dispose();
  }
}
