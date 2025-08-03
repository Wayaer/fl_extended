import 'package:flutter/material.dart';

class AppThemeData {
  AppThemeData._();

  static ThemeData get light => ThemeData(brightness: Brightness.light, useMaterial3: true);

  static ThemeData get dark => ThemeData(brightness: Brightness.dark, useMaterial3: true);
}
