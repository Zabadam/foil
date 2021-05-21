library foil_demo;

import 'package:flutter/material.dart';

import 'package:foil/foil.dart';

void main() => runApp(const DemonstrationFrame());

/// `MaterialApp` wrapper for [Demonstration].
class DemonstrationFrame extends StatelessWidget {
  /// `MaterialApp` wrapper for [Demonstration].
  const DemonstrationFrame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: 'Foil Demo',
        home: Demonstration(),
      );
}

/// A demonstration of wrapping a widget with `Foil`.
class Demonstration extends StatelessWidget {
  /// A demonstration of wrapping a widget with `Foil`.
  const Demonstration({Key? key}) : super(key: key);
  // ignore: unused_field
  static const _colors = [Colors.red, Colors.amber, Colors.yellow];
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: const Text('Foil Demo')),
      body: SizedBox(
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const FittedBox(
              child: Foil(
                gradient: Foils.rainbowReversed,
                // speed: Duration(milliseconds: 400),
                child: Text(
                  'FOIL',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 500),
                ),
              ),
            ),
            FittedBox(
              child: Stack(
                children: [
                  const Text(
                    '☆',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 350,
                      height: 1.0,
                    ),
                  ),
                  const Foil(
                    gradient: Foils.oilslick,
                    // child: Foil.colored(
                    // colors: _colors + _colors + _colors + _colors,
                    // speed: const Duration(milliseconds: 400),
                    child: Text(
                      '☆',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 350,
                        height: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
