import 'dart:async';
import 'dart:math' show pi;

import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:portfolio_kha/base_app.dart';

class SplashScreenApp extends StatefulWidget {
  const SplashScreenApp({super.key});

  @override
  SplashScreenAppState createState() => SplashScreenAppState();
}

class SplashScreenAppState extends State<SplashScreenApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlameSplashScreen(
          controller: FlameSplashController(fadeInDuration: const Duration(milliseconds: 100)),
          showBefore: (BuildContext context) {
            return _Loading();
          },
       
          theme: FlameSplashTheme.dark,
          onFinish: (context) {

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const App(),
            ),
          );
          }),
    );
  }
}

class _Loading extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => __LoadingState();
}

class __LoadingState extends State<_Loading> {
  int _dotCount = 1;
  Timer? _timer;
  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _dotCount = (_dotCount % 4) + 1;
      });
    });
  }

  @override
  void dispose() {
    _timer!.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "Loading ${"." * _dotCount}",
      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.normal),
    );
  }
}


class _TextAfterEffect extends StatefulWidget {
  final String text;
  const _TextAfterEffect(this.text);
  @override
  State<StatefulWidget> createState() => __TextAfterEffectState();
}

class __TextAfterEffectState extends State<_TextAfterEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Color> _colors = [
    const Color(0xFFFFA500), // Orange
    const Color(0xFFFF5500), // Dark Orange
    const Color(0xFFFF0000), // Red
    const Color(0xFFFF8C00), // Dark Orange
    const Color(0xFFFFA500), // Orange (repeated to make transition smooth)
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: _colors,
              transform: GradientRotation(_controller.value * 2 * pi),
              tileMode: TileMode.mirror,
            ).createShader(bounds);
          },
          child: Text(
            widget.text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              color: Colors.white,
              
            ),
          ),
        );
      },
    );
  }
}
