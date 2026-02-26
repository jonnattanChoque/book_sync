import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const beigePaper = Color(0xFFF4F1EA);
  static const inkCharcoal = Color(0xFF2C2C2C);
  static const latteMain = Color(0xFFD4B996);
  static const prussianBlue = Color(0xFF1B3B5A);
  static const oliveGreen = Color(0xFF708238);
}

final cozyTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: AppColors.beigePaper,
  textTheme: GoogleFonts.specialEliteTextTheme().copyWith(
    displayMedium: const TextStyle(color: AppColors.prussianBlue),
    bodyLarge: const TextStyle(color: AppColors.inkCharcoal),
  ),
);