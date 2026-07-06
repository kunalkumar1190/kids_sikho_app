import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Bright Kid-Friendly Colors
  static const Color primaryColor = Color(0xFFFF6B6B); // Soft Red/Pink
  static const Color secondaryColor = Color(0xFF4ECDC4); // Teal/Cyan
  static const Color accentColor = Color(0xFFFFD93D); // Bright Yellow
  static const Color backgroundLight = Color(0xFFF7F9FC);
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);

  // Success, Warning, Error
  static const Color success = Color(0xFF2ECC71); // Green
  static const Color warning = Color(0xFFF1C40F); // Yellow
  static const Color error = Color(0xFFE74C3C); // Red

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        secondary: secondaryColor,
        tertiary: accentColor,
        background: backgroundLight,
        surface: cardColor,
        error: error,
      ),
      scaffoldBackgroundColor: backgroundLight,
      textTheme: GoogleFonts.nunitoTextTheme().copyWith(
        displayLarge: GoogleFonts.nunito(
          color: textPrimary,
          fontWeight: FontWeight.w800,
          fontSize: 32,
        ),
        displayMedium: GoogleFonts.nunito(
          color: textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 28,
        ),
        headlineLarge: GoogleFonts.nunito(
          color: textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 24,
        ),
        bodyLarge: GoogleFonts.nunito(
          color: textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 18,
        ),
        bodyMedium: GoogleFonts.nunito(
          color: textSecondary,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
