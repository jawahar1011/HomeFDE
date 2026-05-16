import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF2D3A8C);
  static const Color primaryLight = Color(0xFF4F5FD5);
  static const Color primaryDark = Color(0xFF1A2360);
  static const Color primarySurface = Color(0xFFEEF0FB);

  // Secondary / Accent
  static const Color accent = Color(0xFFFF6B35);
  static const Color accentLight = Color(0xFFFF8F66);
  static const Color accentSurface = Color(0xFFFFF4EF);

  // Neutrals
  static const Color textPrimary = Color(0xFF1A1D2E);
  static const Color textSecondary = Color(0xFF5A6178);
  static const Color textHint = Color(0xFF9CA3B8);
  static const Color textOnPrimary = Colors.white;

  // Backgrounds
  static const Color background = Color(0xFFF7F8FC);
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF1F3F8);

  // Borders
  static const Color border = Color(0xFFE4E7F0);
  static const Color borderLight = Color(0xFFF0F1F5);

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFFBAD23);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Category card tints
  static const List<Color> categoryTints = [
    Color(0xFFEBF5FF),
    Color(0xFFFFF7ED),
    Color(0xFFECFDF5),
    Color(0xFFFDF2F8),
    Color(0xFFF5F3FF),
    Color(0xFFFEF9C3),
    Color(0xFFE0F2FE),
    Color(0xFFFCE7F3),
  ];

  static const List<Color> categoryAccents = [
    Color(0xFF3B82F6),
    Color(0xFFF97316),
    Color(0xFF10B981),
    Color(0xFFEC4899),
    Color(0xFF8B5CF6),
    Color(0xFFEAB308),
    Color(0xFF06B6D4),
    Color(0xFFF43F5E),
  ];
}
