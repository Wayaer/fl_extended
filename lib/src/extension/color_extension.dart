import 'package:flutter/material.dart';

extension ExtensionColor on Color {
  bool get isTransparent => a == 0;

  Map<int, Color> get getMaterialColorValues => {
    50: _swatchShade(50),
    100: _swatchShade(100),
    200: _swatchShade(200),
    300: _swatchShade(300),
    400: _swatchShade(400),
    500: _swatchShade(500),
    600: _swatchShade(600),
    700: _swatchShade(700),
    800: _swatchShade(800),
    900: _swatchShade(900),
  };

  Color _swatchShade(int swatchValue) =>
      HSLColor.fromColor(
        this,
      ).withLightness(1 - (swatchValue / 1000)).toColor();

  Color get withBrightness {
    final Brightness brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    if (brightness == Brightness.light) {
      return this;
    } else {
      return getMaterialColorValues[800]!;
    }
  }
}
