import 'package:flutter/material.dart';

/// Centraliza todas as cores utilizadas pelo Cellar AI.
/// Nenhuma tela deve utilizar Color(...) diretamente.
abstract final class CellarColors {
  // Brand
  static const Color primary = Color(0xFF6D071A);
  static const Color accent = Color(0xFFC9A227);

  // Backgrounds
  static const Color background = Color(0xFFF8F6F2);
  static const Color surface = Colors.white;

  // Text
  static const Color textPrimary = Color(0xFF2B2B2B);
  static const Color textSecondary = Color(0xFF6B6B6B);

  // Status
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF9A825);
  static const Color error = Color(0xFFC62828);

  // Borders
  static const Color border = Color(0xFFE5E0D8);

  // Dividers
  static const Color divider = Color(0xFFEAE6DE);
}