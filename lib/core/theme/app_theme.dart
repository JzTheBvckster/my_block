import 'package:flutter/material.dart';

import 'color_schemes.dart';

class AppTheme {
  static ThemeData light() {
    final seed = SolarizedSummerColors.summerSea;
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme.copyWith(
        surface: SolarizedSummerColors.lightBackground,
        primary: SolarizedSummerColors.summerSea,
        secondary: SolarizedSummerColors.summerSky,
        error: const Color(0xFFDC322F),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: SolarizedSummerColors.base00),
        titleLarge: TextStyle(
          color: SolarizedSummerColors.base01,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  static ThemeData dark() {
    final seed = SolarizedSummerColors.summerSea;
    final scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme.copyWith(
        surface: SolarizedSummerColors.darkBackground,
        primary: SolarizedSummerColors.summerSea,
        secondary: SolarizedSummerColors.summerSun,
        error: const Color(0xFFDC322F),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(color: SolarizedSummerColors.base1),
        titleLarge: TextStyle(
          color: SolarizedSummerColors.base0,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
