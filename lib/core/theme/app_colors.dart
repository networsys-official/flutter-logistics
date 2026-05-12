import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // --- Neutrals (Text, Backgrounds & Borders) ---
  /// Deep dark color for primary headlines and main text.
  static const Color neutral900 = Color(0xFF1B2530);

  /// Medium gray for secondary text and subtitles.
  static const Color neutral700 = Color(0xFF51606D);

  /// Light gray for disabled text or less important captions.
  static const Color neutral500 = Color(0xFF98A1A9);

  /// Very light gray for divider lines and subtle borders.
  static const Color neutral200 = Color(0xFFD6DCE1);

  /// Very light background tint for scaffold background.
  static const Color neutral100 = Color(0xFFF8FAF8);

  /// Pure white for main backgrounds and elevated surfaces.
  static const Color white = Color(0xFFFFFFFF);

  // --- Branding Colors ---
  /// Primary brand color.
  static const Color primary = Color(0xFF3D8900);

  /// Darker shade of primary.
  static const Color primaryDark = Color(0xFF2E6900);

  /// Main secondary brand color.
  static const Color secondary = Color(0xFF2A7688);

  /// Darker shade of secondary.
  static const Color secondaryDark = Color(0xFF1F5C6A);

  /// Light tint of secondary for containers.
  static const Color secondaryContainer = Color(0xFFD6EEF4);

  /// Accent highlight color.
  static const Color accent = Color(0xFFE48A62);

  // --- Semantic & Status Colors ---
  /// Semantic success green.
  static const Color success = Color(0xFF328A00);

  /// Semantic warning orange.
  static const Color warning = Color(0xFFE2932D);

  /// Semantic error red.
  static const Color error = Color(0xFFD65858);

  /// Informational status color.
  static const Color info = Color(0xFFD6A53A);

  // --- Component Specific ---
  /// Border color for input fields.
  static const Color inputBorder = Color(0xFFC8CDD2);

  /// Hint text color for input fields.
  static const Color inputHint = Color(0xFFADB3B8);

  // --- Background Variants (Light Tints) ---
  static const Color successContainer = Color(0xFFE8F5E9);
  static const Color infoContainer = Color(0xFFD6EEF4);
  static const Color warningContainer = Color(0xFFFFF0D9);
  static const Color errorContainer = Color(0xFFFBECEC);
  static const Color accentContainer = Color(0xFFFFF3C7);
  static const Color highlightContainer = Color(0xFFEFF8E6);
  static const Color goldContainer = Color(0xFFFFF8E1);
}
