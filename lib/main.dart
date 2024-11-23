import 'package:flutter/material.dart';
import 'package:portfolio_kha/base_app.dart';
import 'package:portfolio_kha/screens/splase_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio-KHA',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreenApp(),
    );
  }
}
