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
        fontSize: 22,
        color: ThemeColor.rackley,
      ),
      headlineLarge: TextStyle(
        fontWeight: FontWeight.w600,
        color: ThemeColor.rackley,
      ),
      headlineSmall: TextStyle(
        color: ThemeColor.greenSheen,
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(
        color: ThemeColor.greenSheen,
      ),
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: ThemeColor.rackley,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: ThemeColor.greenSheen,
    ),
  );
}
