/// Provides `SensorListener` encapsulation for accelerometer data
/// as well as corresponding `SensorCallback` for acting on that data
library foil;

import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:sensors_plus/sensors_plus.dart';

/// {@template sensor_callback}
/// A callback used to provide a parent with computed
/// `foilAngle` as a `double`.
///
/// [SensorListener.onStep] is invoked every [SensorListener.step].
/// {@endtemplate}
typedef SensorCallback = void Function(double normalizedX, double normalizedY);

/// {@macro sensor_listener}
class SensorListener extends StatefulWidget {
  /// {@template sensor_listener}
  /// A widget that listens to accelerometer sensor data
  /// and returns that data as an actionable `0..1` value,
  /// one each for the X axis and Y axis, as a [SensorCallback].
  /// {@endtemplate}
  const SensorListener({
    Key? key,
    required this.disabled,
    required this.step,
    required this.scalar,
    required this.child,
    required this.onStep,
  }) : super(key: key);

  /// If `disabled` is `true`, then this `SensorListener`
  /// will stop making [onStep] invocations.
  final bool disabled;

  /// `Duration` between [onStep] `SensorCallback` updates.
  final Duration step;

  /// Multiply the resultant factor for `[x, y]` by this `[double, double]`. \
  /// Values between `0..1` will make this `SensorListener` less reactive,
  /// while values greater than `1.0` increases reactivity.
  ///
  /// A scalar entry of `0.0` will negate that axis's influence.
  final List<double> scalar;

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

  /// Normalize `x` and `y` values to `0..1`.
  /// `AccelerometerEvent.x,y` values range from `-10..10`.
  double normalize(double sample) => (sample + 10) / 20;

  void step() {
    x = normalize(accelEvent.x) * widget.scalar[0];
    y = normalize(accelEvent.y) * widget.scalar[1];
    if (!widget.disabled) widget.onStep(x, y);
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
