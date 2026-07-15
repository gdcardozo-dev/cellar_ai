import 'package:flutter/material.dart';

class CellarTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6D071A),
      ),
      scaffoldBackgroundColor: const Color(0xFFF8F6F2),
    );
  }
}