import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:logistic_by_strom/app/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static const double space1 = 8;
  static const double space2 = 12;
  static const double space3 = 16;
  static const double space4 = 20;
  static const double space5 = 24;
  static const double space6 = 32;
  static const double radiusMd = 18;
  static const double radiusLg = 28;
  static final TextTheme _textTheme = GoogleFonts.plusJakartaSansTextTheme(
    const TextTheme(
      displayLarge: TextStyle(
        fontSize: 40,
        height: 1.05,
        fontWeight: FontWeight.w800,
        color: AppColors.ink900,
        letterSpacing: -1.1,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        height: 1.15,
        fontWeight: FontWeight.w700,
        color: AppColors.ink900,
        letterSpacing: -0.6,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        height: 1.2,
        fontWeight: FontWeight.w700,
        color: AppColors.ink900,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        height: 1.3,
        fontWeight: FontWeight.w700,
        color: AppColors.ink900,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        height: 1.5,
        fontWeight: FontWeight.w500,
        color: AppColors.ink700,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        height: 1.45,
        fontWeight: FontWeight.w500,
        color: AppColors.ink700,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        height: 1.1,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
        letterSpacing: 0.2,
      ),
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.white,
    colorScheme: const ColorScheme.light(
      primary: AppColors.authPrimary,
      secondary: AppColors.coral500,
      tertiary: AppColors.gold500,
      surface: AppColors.white,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      onSurface: AppColors.ink900,
      outline: AppColors.cloud200,
    ),
    textTheme: _textTheme,
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.ink900,
      titleTextStyle: GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.ink900,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMd),
      ),
      margin: EdgeInsets.zero,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: AppColors.authPrimary,
        foregroundColor: AppColors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        disabledBackgroundColor: AppColors.cloud200,
        disabledForegroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.ink900,
        backgroundColor: AppColors.white,
        side: const BorderSide(color: AppColors.cloud200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      hintStyle: GoogleFonts.plusJakartaSans(
        color: AppColors.authMuted,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.authFieldBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.authFieldBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.authPrimary, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.danger500),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.danger500, width: 1.4),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      side: const BorderSide(color: AppColors.authPrimary, width: 1.4),
      fillColor: const WidgetStatePropertyAll(AppColors.authPrimary),
      checkColor: const WidgetStatePropertyAll(AppColors.white),
      visualDensity: VisualDensity.compact,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.ocean100,
      selectedColor: AppColors.ocean500,
      secondarySelectedColor: AppColors.ocean500,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      labelStyle: GoogleFonts.plusJakartaSans(
        color: AppColors.ink900,
        fontWeight: FontWeight.w700,
      ),
      secondaryLabelStyle: GoogleFonts.plusJakartaSans(
        color: AppColors.white,
        fontWeight: FontWeight.w700,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.white,
      elevation: 0,
      labelTextStyle: WidgetStatePropertyAll(
        GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    ),
    dividerColor: AppColors.cloud200,
  );
}
