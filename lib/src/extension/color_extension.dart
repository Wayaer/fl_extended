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

  Color _swatchShade(int swatchValue) {
    if (swatchValue == 500) return this;
    final double lightness = (1 - swatchValue / 1000).clamp(0.0, 1.0);
    return HSLColor.fromColor(this).withLightness(lightness).toColor();
  }

  /// 根据系统亮度返回适合当前背景的颜色
  ///
  /// 注意：这里读取的是系统平台亮度；如果 App 内手动切换 ThemeMode，
  /// 请优先使用 `Theme.of(context).colorScheme` 中的语义颜色。
  Color get withBrightness {
    final Brightness brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.light ? this : getMaterialColorValues[200]!;
  }
}
