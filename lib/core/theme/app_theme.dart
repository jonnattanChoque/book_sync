// lib/core/theme/app_theme.dart
import 'package:book_sync/core/theme/cozy_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:book_sync/core/theme/app_colors.dart';

// --- LIGHT THEME ---
final lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.beigePaper,
  textTheme: GoogleFonts.specialEliteTextTheme().apply(
    bodyColor: AppColors.inkCharcoal,
    displayColor: AppColors.prussianBlue,
  ),
  extensions: [
    CozyColors(
      bookmarkColor: AppColors.prussianBlue,
      inkColor: AppColors.inkCharcoal,
      textColor: AppColors.deepCharcoal
    ),
  ],
);

// --- DARK THEME ---
final darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.deepCharcoal,
  textTheme: GoogleFonts.specialEliteTextTheme().apply(
    bodyColor: AppColors.sandHueso,
    displayColor: AppColors.sandHueso,
  ),
  extensions: [
    CozyColors(
      bookmarkColor: AppColors.prussianBlueDark,
      inkColor: AppColors.sandHueso,
      textColor: AppColors.beigePaper
    ),
  ],
);