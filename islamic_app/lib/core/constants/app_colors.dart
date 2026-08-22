import 'package:flutter/material.dart';

/// نظام الألوان الخاص بالتطبيق - هوية إسلامية هادئة
class AppColors {
  AppColors._();

  // ---------- Primary (Islamic Green) ----------
  static const Color primary = Color(0xFF1E6E5C);
  static const Color primaryLight = Color(0xFF4C9C87);
  static const Color primaryDark = Color(0xFF0F4638);

  // ---------- Secondary (Light Blue) ----------
  static const Color secondary = Color(0xFF5DA9C7);
  static const Color secondaryLight = Color(0xFFA9D4E6);

  // ---------- Accent (Gold) - used sparingly ----------
  static const Color gold = Color(0xFFC9A24B);
  static const Color goldLight = Color(0xFFE4CE94);

  // ---------- Light Theme ----------
  static const Color lightBackground = Color(0xFFF7FAF9);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF0F5F3);
  static const Color lightTextPrimary = Color(0xFF1B2A27);
  static const Color lightTextSecondary = Color(0xFF5C6D68);
  static const Color lightDivider = Color(0xFFE1E8E6);

  // ---------- Dark Theme ----------
  static const Color darkBackground = Color(0xFF0E1512);
  static const Color darkSurface = Color(0xFF162019);
  static const Color darkCard = Color(0xFF1C2822);
  static const Color darkTextPrimary = Color(0xFFEAF2EF);
  static const Color darkTextSecondary = Color(0xFF9FB3AC);
  static const Color darkDivider = Color(0xFF2A3A33);

  // ---------- Status ----------
  static const Color success = Color(0xFF3EA06B);
  static const Color error = Color(0xFFD1554A);
  static const Color warning = Color(0xFFE0A93B);

  // ---------- Misc ----------
  static const Color shimmerBaseLight = Color(0xFFE6ECEA);
  static const Color shimmerHighlightLight = Color(0xFFF5F8F7);
  static const Color shimmerBaseDark = Color(0xFF1F2B25);
  static const Color shimmerHighlightDark = Color(0xFF2B3A32);
}
