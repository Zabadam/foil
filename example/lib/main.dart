library foil_demo;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:foil/foil.dart';
import 'package:spectrum/spectrum.dart';

import 'trading_card.dart';

void main() => runApp(const DemonstrationFrame());

/// `MaterialApp` wrapper for [Demonstration].
class DemonstrationFrame extends StatelessWidget {
  /// `MaterialApp` wrapper for [Demonstration].
  const DemonstrationFrame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Foil Demo',
        color: Colors.white,
        theme: ThemeData(primarySwatch: Colors.grey),
        home: const Directionality(
          textDirection: TextDirection.ltr,
          // textDirection: TextDirection.rtl,
          child: Demonstration(),
        ),
      );
}

/// A demonstration of wrapping widgets with `Foil`.
class Demonstration extends StatefulWidget {
  /// A demonstration of wrapping widgets with `Foil`.
  const Demonstration({Key? key}) : super(key: key);

  @override
  _DemonstrationState createState() => _DemonstrationState();
}

class _DemonstrationState extends State<Demonstration> {
  static const _colors = [Colors.amber, Colors.red, Colors.yellow];
  final cards = [
    'https://den-cards.pokellector.com/229/Gyarados-GX.CNV.112.19801.png',
    'https://den-cards.pokellector.com/209/Gyarados-GX.SM.212.29567.png',
    'https://den-cards.pokellector.com/261/Gyarados.SM9.30.26527.png'
  ];
  bool unwrapped = false;

  @override
  void initState() {
    super.initState();
    cards.shuffle();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    const squareStyle = TextStyle(
      color: Colors.black,
      fontSize: 390,
      fontWeight: FontWeight.w900,
      height: 1.0,
      letterSpacing: -30.0,
    );

    /// A square emoji icon that will be wrapped in `Foil`.
    Widget buildSquare(String label) => Stack(
          alignment: Alignment.bottomCenter,
          children: [
            const Text('■', style: squareStyle),
            FittedBox(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.0,
                ),
              ),
            ),
          ],
        );

    /// Returns a `Foil` that wraps a [buildSquare].
    Foil buildSample({
      required String label,
      required Gradient gradient,
      Scalar? scalar,
      Duration? speed,
      Duration? duration,
    }) =>
        Foil(
          isUnwrapped: unwrapped,
          gradient: gradient,
          scalar: scalar ?? Scalar.identity,
          speed: speed ?? const Duration(milliseconds: 150),
          duration: duration ?? const Duration(milliseconds: 500),
          child: buildSquare('\n$label'),
        );

    return GestureDetector(
      onTap: () => setState(() => unwrapped = !unwrapped),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Foil Demo'),
          // Standard rainbow but with 0.15 opacity,
          // laid atop a grey container for a nice foily look.
          flexibleSpace: Roll(
            crinkle: Crinkle(
              // This is the default anyway; purely demonstrative:
              // Changing these values will required a hot-reload.
              transform: (x, y) => TranslateGradient(percentX: x, percentY: y),
              period: const Duration(minutes: 1),
            ),
            child: Foil(
              opacity: 0.15,
              speed: const Duration(milliseconds: 300),
              child: Container(color: Colors.grey),
            ),
          ),
        ),
        drawer: const Roll(
          // Changing the Crinkle will required a hot-reload.
          crinkle: Crinkle.crawling,
          child: Foil(
            blendMode: BlendMode.srcIn,
            opacity: 0.45,
            child: Drawer(elevation: 100),
          ),
        ),
        body: SizedBox(
          width: width,
          height: height,
          child: ListView(
            children: [
              /// 🔤 "FOIL"
              /// Gets extra vertical [Scalar] to make the [LinearGradient]
              /// twinkle more obviously in that axis.
              FittedBox(
                child: Foil(
                  isUnwrapped: unwrapped,
                  scalar: const Scalar(vertical: 4),
                  child: const Text(
                    'FOIL',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),

              /// ❓ Question mark character using [Foil.colored]
              FittedBox(
                // Very primitive control of gradient, but simple to deploy
                // with custom colors:
                child: Foil.colored(
                  isUnwrapped: unwrapped,
                  colors: _colors + _colors + _colors + _colors,
                  scalar: const Scalar(horizontal: 0.25, vertical: 0.5),
                  child: const Text(
                    '꘏',
                    textAlign: TextAlign.center,
                    style: TextStyle(height: 0.5),
                  ),
                ),
              ),

              /// ⭐ Star character using [Foils.oilslick],
              /// a negated vertical axis, and a custom [BlendMode]
              FittedBox(
                child: Foil(
                  isUnwrapped: unwrapped,
                  gradient: Foils.oilslick,
                  blendMode: BlendMode.srcATop, // default
                  // blendMode: BlendMode.srcIn, // no child, only Foil
                  // Negates vertical sensor data:
                  // scalar: const Scalar(vertical: 0),
                  child: const Text(
                    '☆',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w900, height: 1.0),
                  ),
                ),
              ),

              /// [Foils] Palette
              /// ----------------

              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  buildSample(
                      label: 'linearRainbow', gradient: Foils.linearRainbow),
                  buildSample(
                    label: 'linearReversed',
                    gradient: Foils.linearReversed,
                  ),
                  buildSample(
                      label: 'linearLooping', gradient: Foils.linearLooping),
                  buildSample(
                    label: 'linearLooping\nReversed',
                    gradient: Foils.linearLoopingReversed,
                  ),
                  buildSample(
                    label: 'sitAndSpin',
                    gradient: Foils.sitAndSpin,
                  ),
                  buildSample(
                    label: 'gymClass\nParachute',
                    gradient: Foils.gymClassParachute,
                  ),
                  buildSample(
                    label: 'stepBow\nSweep',
                    gradient: Foils.stepBowSweep,
                  ),
                  buildSample(
                    label: 'stepBow\nRadial',
                    gradient: Foils.stepBowRadial,
                  ),
                  buildSample(
                    label: 'stepBow\nLinear',
                    gradient: Foils.stepBowLinear,
                  ),
                  buildSample(label: 'oilslick', gradient: Foils.oilslick),
                  buildSample(
                    label: '📋 copy of\nlinearRainbow',
                    // Foil comes with GradientUtils!
                    gradient: Foils.linearRainbow.copyWith(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomLeft,
                      colors: List.from(Foils.linearRainbow.colors)
                        ..insert(0, Colors.black)
                        ..add(Colors.black),
                    ),
                  ),
                  buildSample(
                    label: '📋 copy of\nsitAndSpin',
                    // Foil comes with GradientUtils!
                    gradient: Foils.sitAndSpin.copyWith(
                      center: const Alignment(0, -2),
                      tileMode: TileMode.clamp,
                    ),
                  ),

                  /// Demonstrating parameters side-by-side for screenshots.
                  buildSample(
                    label: 'Duration\n(ms: 1500)',
                    // gradient: Foils.stepBowSweep,
                    gradient: Foils.stepBowRadial,
                    // scalar: const Scalar.xy(0.5, 2.0),
                    scalar: const Scalar.xy(0.5, 0.5),
                    // speed: const Duration(milliseconds: 500),
                    duration: const Duration(milliseconds: 1500),
                  ),
                  buildSample(
                    label: 'Duration\n(ms: 1000)',
                    // gradient: Foils.stepBowSweep,
                    gradient: Foils.stepBowRadial,
                    // scalar: const Scalar.xy(2.0, 0.5),
                    scalar: const Scalar.xy(0.5, 0.5),
                    // speed: const Duration(milliseconds: 200),
                    duration: const Duration(milliseconds: 1000),
                  ),
                  buildSample(
                    label: 'Duration\n(ms: 500)',
                    // gradient: Foils.stepBowSweep,
                    gradient: Foils.stepBowRadial,
                    // scalar: const Scalar.xy(0.5, 2.0),
                    scalar: const Scalar.xy(0.5, 0.5),
                    // speed: const Duration(milliseconds: 500),
                    duration: const Duration(milliseconds: 500),
                  ),
                  buildSample(
                    label: 'Duration\n(ms: 200)',
                    // gradient: Foils.stepBowSweep,
                    gradient: Foils.stepBowRadial,
                    // scalar: const Scalar.xy(2.0, 0.5),
                    scalar: const Scalar.xy(0.5, 0.5),
                    // speed: const Duration(milliseconds: 200),
                    duration: const Duration(milliseconds: 200),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              /// 🐲 Gyarados [TradingCard]s
              /// https://github.com/Zabadam/foil/blob/main/example/lib/trading_card.dart
              /// Employs [package:xl](https://pub.dev/packages/xl)
              /// --------------------------------------------------

              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // This one is wrapped in *two* Foils.
                  Foil(
                    isUnwrapped: unwrapped,
                    opacity: 0.2,
                    child: Foil(
                      isUnwrapped: unwrapped,
                      opacity: 0.3,
                      // Foil comes with GradientUtils!
                      gradient: Foils.sitAndSpin.copyWith(
                        center: const Alignment(-1, -2.5),
                      ),
                      child: TradingCard(
                        card: cards.first,
                        width: 400,
                        height: 600,
                      ),
                    ),
                  ),
                  Roll(
                    gradient: Foils.oilslick,
                    // Changing this `crinkle` will required a hot reload.
                    crinkle: Crinkle.twinkling,
                    // reverse: false,
                    child: FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Foil(
                            isUnwrapped: unwrapped,
                            opacity: 0.35,
                            child: TradingCard(
                              card: cards[1],
                              padding:
                                  const EdgeInsets.fromLTRB(100, 0, 80, 25),
                            ),
                          ),
                          Foil(
                            isUnwrapped: unwrapped,
                            opacity: 0.35,
                            // This gradient overrides that of the `Roll` above
                            gradient: Foils.linearLoopingReversed,
                            child: TradingCard(
                              card: cards[2],
                              padding:
                                  const EdgeInsets.fromLTRB(80, 0, 100, 25),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              /// Sheets of Foil
              /// ---------------

              const SizedBox(height: 10),
              Center(
                child: Foil.sheet(
                  isUnwrapped: unwrapped,
                  gradient:
                      Foils.rainbow.copyWith(center: const Alignment(0, 0.6)),
                  // blendMode: BlendMode.multiply,
                  scalar: const Scalar.xy(0.25, 0.4),
                  sheet: const Sheet(
                    height: 300,
                    color: Colors.white,
                  ),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Foil(
                      isUnwrapped: unwrapped,
                      gradient: Foils.rainbow.copyWith(
                          radius: 1.5, center: const Alignment(0, 1.0)),
                      child: const Text.rich(
                        TextSpan(
                          text: 'Foils.rainbow\n',
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.w900,
                          ),
                          children: [
                            TextSpan(
                              text: 'a decal gradient',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
