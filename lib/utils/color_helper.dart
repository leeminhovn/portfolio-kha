import 'dart:math';
import 'dart:ui';

class ColorHelper {
  static final Random _random = Random();

  static Color randomColor() {
    return Color.fromRGBO(
      _random.nextInt(256), // Red
      _random.nextInt(256), // Green
      _random.nextInt(256), // Blue
      1.0,                 // Opacity
    );
  }

  static Color randomColorWithOpacity(double opacity) {
    return Color.fromRGBO(
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
      opacity,
    );
  }

  static Color randomBrightColor() {
    return Color.fromRGBO(
      _random.nextInt(128) + 128, // 128-255
      _random.nextInt(128) + 128, // 128-255
      _random.nextInt(128) + 128, // 128-255
      1.0,
    );
  }

  static Color randomPastelColor() {
    return Color.fromRGBO(
      _random.nextInt(60) + 195,  // 195-255
      _random.nextInt(60) + 195,  // 195-255
      _random.nextInt(60) + 195,  // 195-255
      1.0,
    );
  }
} 