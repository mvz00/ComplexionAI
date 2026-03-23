import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary — Sage Green
  static const skinPrimary = Color(0xFF6B8F71);
  static const skinPrimaryLight = Color(0xFFA8C5AD);
  static const skinPrimaryDark = Color(0xFF3D5A42);
  static const skinPrimaryBg = Color(0xFFE8F0E9);

  // Accent — Warm Peach
  static const skinAccent = Color(0xFFE8B4A2);
  static const skinAccentLight = Color(0xFFF5DDD3);
  static const skinAccentBg = Color(0xFFFDF5F1);

  // Neutrals
  static const skinBg = Color(0xFFFAF8F5);
  static const skinSurface = Color(0xFFFFFFFF);
  static const skinSurfaceAlt = Color(0xFFF3F1ED);
  static const skinText = Color(0xFF2D2D2D);
  static const skinTextSecondary = Color(0xFF7A7A7A);
  static const skinTextTertiary = Color(0xFFABABAB);
  static const skinBorder = Color(0x1A000000); // rgba(0,0,0,0.1)
  static const skinBorderStrong = Color(0x2E000000); // rgba(0,0,0,0.18)

  // Semantic
  static const info = Color(0xFF3B7DD8);
  static const infoBg = Color(0xFFE6F0FB);
  static const success = Color(0xFF4CAF50);
  static const successBg = Color(0xFFEDF7ED);
  static const warning = Color(0xFFF59E0B);
  static const warningBg = Color(0xFFFEF3C7);
  static const danger = Color(0xFFE24B4A);
  static const dangerBg = Color(0xFFFCEBEB);

  // Score Colors
  static const scoreExcellent = Color(0xFF4CAF50);
  static const scoreGood = Color(0xFF8BC34A);
  static const scoreAverage = Color(0xFFFFC107);
  static const scorePoor = Color(0xFFFF9800);
  static const scoreBad = Color(0xFFF44336);

  // Dark Mode
  static const darkBg = Color(0xFF141413);
  static const darkSurface = Color(0xFF1E1E1C);
  static const darkSurfaceAlt = Color(0xFF2A2A27);
  static const darkText = Color(0xFFE8E6E1);
  static const darkTextSecondary = Color(0xFF9A9890);
  static const darkTextTertiary = Color(0xFF6B6960);
  static const darkBorder = Color(0x14FFFFFF); // rgba(255,255,255,0.08)
  static const darkBorderStrong = Color(0x26FFFFFF); // rgba(255,255,255,0.15)
  static const darkPrimary = Color(0xFF8FB896);
  static const darkPrimaryBg = Color(0xFF1E2E20);
  static const darkAccent = Color(0xFFD4967F);
  static const darkAccentBg = Color(0xFF2E1F18);

  static Color scoreColor(double score) {
    if (score >= 80) return scoreExcellent;
    if (score >= 65) return scoreGood;
    if (score >= 50) return scoreAverage;
    if (score >= 35) return scorePoor;
    return scoreBad;
  }
}
