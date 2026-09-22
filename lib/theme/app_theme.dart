import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
export 'app_colors.dart';

/// Design system font helpers for consistent typography.
class AppFonts {
  // Sora Bold 700 → major headings, large numbers, primary titles
  static TextStyle soraHeading({
    double fontSize = 26,
    Color color = AppColors.textDark,
    double? letterSpacing,
  }) =>
      GoogleFonts.sora(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: letterSpacing,
      );

  // Sora SemiBold 600 → card titles and important labels
  static TextStyle soraSemiBold({
    double fontSize = 16,
    Color color = AppColors.textDark,
  }) =>
      GoogleFonts.sora(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: color,
      );

  // Sora 900 → large hero numbers
  static TextStyle soraBlack({
    double fontSize = 40,
    Color color = AppColors.textDark,
    String? fontFamily,
  }) =>
      GoogleFonts.sora(
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
        color: color,
      );

  // Manrope Medium 500 → body text and descriptions
  static TextStyle manropeBody({
    double fontSize = 13,
    Color color = AppColors.textSecondary,
  }) =>
      GoogleFonts.manrope(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: color,
      );

  // Manrope Bold 700 → important buttons/actions
  static TextStyle manropeBold({
    double fontSize = 15,
    Color color = AppColors.textDark,
  }) =>
      GoogleFonts.manrope(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        color: color,
      );

  // Space Grotesk SemiBold 600 → small labels, status labels, technical/measurement labels
  static TextStyle spaceGroteskLabel({
    double fontSize = 11,
    Color color = AppColors.textSecondary,
    double? letterSpacing,
  }) =>
      GoogleFonts.spaceGrotesk(
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: letterSpacing ?? 0.6,
      );
}

class AppTheme {
  static ThemeData get lightTheme {
    // Use Manrope as the global base — most body text
    final baseTextTheme = GoogleFonts.manropeTextTheme(ThemeData.light().textTheme);

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: baseTextTheme.copyWith(
        // Display / hero (large numbers, major headings) → Sora Bold 700
        displayLarge: GoogleFonts.sora(fontWeight: FontWeight.w700, fontSize: 57, color: AppColors.textDark),
        displayMedium: GoogleFonts.sora(fontWeight: FontWeight.w700, fontSize: 45, color: AppColors.textDark),
        displaySmall: GoogleFonts.sora(fontWeight: FontWeight.w700, fontSize: 36, color: AppColors.textDark),
        headlineLarge: GoogleFonts.sora(fontWeight: FontWeight.w700, fontSize: 32, color: AppColors.textDark),
        headlineMedium: GoogleFonts.sora(fontWeight: FontWeight.w700, fontSize: 28, color: AppColors.textDark),
        headlineSmall: GoogleFonts.sora(fontWeight: FontWeight.w700, fontSize: 24, color: AppColors.textDark),
        // Titles → Sora SemiBold 600
        titleLarge: GoogleFonts.sora(fontWeight: FontWeight.w600, fontSize: 22, color: AppColors.textDark),
        titleMedium: GoogleFonts.sora(fontWeight: FontWeight.w600, fontSize: 16, color: AppColors.textDark),
        titleSmall: GoogleFonts.sora(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textDark),
        // Body → Manrope Medium 500
        bodyLarge: GoogleFonts.manrope(fontWeight: FontWeight.w500, fontSize: 16, color: AppColors.textDark),
        bodyMedium: GoogleFonts.manrope(fontWeight: FontWeight.w500, fontSize: 14, color: AppColors.textSecondary),
        bodySmall: GoogleFonts.manrope(fontWeight: FontWeight.w500, fontSize: 12, color: AppColors.textSecondary),
        // Labels → Space Grotesk SemiBold 600
        labelLarge: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textSecondary),
        labelMedium: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600, fontSize: 12, color: AppColors.textSecondary),
        labelSmall: GoogleFonts.spaceGrotesk(fontWeight: FontWeight.w600, fontSize: 11, color: AppColors.textSecondary),
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryForest,
        surface: AppColors.background,
        onSurface: AppColors.textDark,
      ),
    );
  }
}
