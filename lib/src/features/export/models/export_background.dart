import 'package:book_sync/core/constants/app_assets.dart';
import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum BackgroundType { solid, gradient, image }

class ExportBackground {
  final String id;
  final String name;
  final BackgroundType type;
  final bool isPremium;
  final BoxDecoration decoration;

  const ExportBackground({
    required this.id,
    required this.name,
    required this.type,
    required this.isPremium,
    required this.decoration,
  });

  static List<ExportBackground> getPresets(BuildContext context) {
    final theme = context.theme;

    return [
      ExportBackground(
        id: 'paper_texture',
        name: 'Paper Texture',
        type: BackgroundType.image,
        isPremium: false,
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark
          ? AppColors.deepCharcoal
          : AppColors.beigePaper,
          image: DecorationImage(
            image: AssetImage(
              theme.brightness == Brightness.dark
              ? AppAssets.paperGrainDark
              : AppAssets.paperGrainLight,
            ),
            repeat: ImageRepeat.repeat,
            opacity: 0.5,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      // --- FONDOS SÓLIDOS (Gratis) ---
      ExportBackground(
        id: 'cozy_theme',
        name: 'Cozy Base',
        type: BackgroundType.solid,
        isPremium: false,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      ExportBackground(
        id: 'dark_classic',
        name: 'Dark Classic',
        type: BackgroundType.solid,
        isPremium: false,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      ExportBackground(
        id: 'cream_paper',
        name: 'Cream Paper',
        type: BackgroundType.solid,
        isPremium: false,
        decoration: BoxDecoration(
          color: const Color(0xFFFBF0D9),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      ExportBackground(
        id: 'sage_green',
        name: 'Sage Green',
        type: BackgroundType.solid,
        isPremium: false,
        decoration: BoxDecoration(
          color: const Color(0xFF8A9A86),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      ExportBackground(
        id: 'soft_lavender',
        name: 'Soft Lavender',
        type: BackgroundType.solid,
        isPremium: false,
        decoration: BoxDecoration(
          color: const Color(0xFFE6E6FA),
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // --- GRADIENTES (Premium) ---
      ExportBackground(
        id: 'sunset_glow',
        name: 'Sunset Glow',
        type: BackgroundType.gradient,
        isPremium: true,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF7E5F), Color(0xFFFEB47B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      ExportBackground(
        id: 'aurora',
        name: 'Aurora',
        type: BackgroundType.gradient,
        isPremium: true,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00C9FF), Color(0xFF92FE9D)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      ExportBackground(
        id: 'midnight_blue',
        name: 'Midnight Blue',
        type: BackgroundType.gradient,
        isPremium: true,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2C3E50), Color(0xFF000000)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      ExportBackground(
        id: 'cozy_peach',
        name: 'Cozy Peach',
        type: BackgroundType.gradient,
        isPremium: true,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFED4264), Color(0xFFFFEDBC)],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      ExportBackground(
        id: 'forest_mist',
        name: 'Forest Mist',
        type: BackgroundType.gradient,
        isPremium: true,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF134E5E), Color(0xFF71B280)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ];
  }
}