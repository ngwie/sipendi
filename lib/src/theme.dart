import 'package:flutter/material.dart';

const _greenSheen = Color(0xFF75B79E);
const _paleSpringBud = Color(0xFFEEF9BF);
const _rackley = Color(0xFF6A8CAF);
const _sunsetOrange = Color(0xFFFF5A5F);

class ThemeColor {
  static const greenSheen = _greenSheen;
  static const paleSpringBud = _paleSpringBud;
  static const rackley = _rackley;
  static const sunsetOrange = _sunsetOrange;
}

class ThemeConfig {
  static final theme = ThemeData(
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: ThemeColor.greenSheen,
      onPrimary: ThemeColor.paleSpringBud,
      secondary: ThemeColor.rackley,
      onSecondary: ThemeColor.paleSpringBud,
      error: ThemeColor.sunsetOrange,
      onError: ThemeColor.paleSpringBud,
      background: Colors.white,
      onBackground: ThemeColor.greenSheen,
      surface: Colors.white,
      onSurface: ThemeColor.rackley,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: ThemeColor.greenSheen,
      ),
      headlineSmall: TextStyle(
        color: ThemeColor.greenSheen,
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: ThemeColor.paleSpringBud,
      ),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(
        color: ThemeColor.greenSheen,
      ),
    ),
  );
}
