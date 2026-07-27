import 'package:flutter/material.dart';

import '../tokens/colors.dart';

abstract final class CellarLightTheme {
  static ThemeData theme = ThemeData(
    useMaterial3: true,

    brightness: Brightness.light,

    scaffoldBackgroundColor: CellarColors.background,

    colorScheme: ColorScheme.fromSeed(
      seedColor: CellarColors.primary,
      brightness: Brightness.light,
    ),

    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: CellarColors.background,
      foregroundColor: CellarColors.textPrimary,
    ),

    cardTheme: const CardThemeData(
      elevation: 0,
      color: CellarColors.surface,
      margin: EdgeInsets.zero,
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: CellarColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
  );
}