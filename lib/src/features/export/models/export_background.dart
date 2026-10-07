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
          color: const Color(0xFFF5E6D3),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      ExportBackground(
        id: 'midnight_blue',
        name: 'Midnight Blue',
        type: BackgroundType.solid,
        isPremium: false,
        decoration: BoxDecoration(
          color: const Color(0xFF1B2A4E),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      ExportBackground(
        id: 'rose_petal',
        name: 'Rose Petal',
        type: BackgroundType.solid,
        isPremium: false,
        decoration: BoxDecoration(
          color: const Color(0xFFF8C8DC),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      ExportBackground(
        id: 'forest_moss',
        name: 'Forest Moss',
        type: BackgroundType.solid,
        isPremium: false,
        decoration: BoxDecoration(
          color: const Color(0xFF4A7C59),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      ExportBackground(
        id: 'mustard_yellow',
        name: 'Mustard Yellow',
        type: BackgroundType.solid,
        isPremium: false,
        decoration: BoxDecoration(
          color: const Color(0xFFE1AD01),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      ExportBackground(
        id: 'lavender_mist',
        name: 'Lavender Mist',
        type: BackgroundType.solid,
        isPremium: false,
        decoration: BoxDecoration(
          color: const Color(0xFFB497BD),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      ExportBackground(
        id: 'coral_reef',
        name: 'Coral Reef',
        type: BackgroundType.solid,
        isPremium: false,
        decoration: BoxDecoration(
          color: const Color(0xFFFF6F61),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      ExportBackground(
        id: 'ocean_teal',
        name: 'Ocean Teal',
        type: BackgroundType.solid,
        isPremium: false,
        decoration: BoxDecoration(
          color: const Color(0xFF008080),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      ExportBackground(
        id: 'charcoal_gray',
        name: 'Charcoal Gray',
        type: BackgroundType.solid,
        isPremium: false,
        decoration: BoxDecoration(
          color: const Color(0xFF36454F),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      ExportBackground(
        id: 'peach_cream',
        name: 'Peach Cream',
        type: BackgroundType.solid,
        isPremium: false,
        decoration: BoxDecoration(
          color: const Color(0xFFFFDAB9),
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
        id: 'ocean_breeze',
        name: 'Ocean Breeze',
        type: BackgroundType.gradient,
        isPremium: true,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2193B0), Color(0xFF6DD5ED)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      ExportBackground(
        id: 'purple_love',
        name: 'Purple Love',
        type: BackgroundType.gradient,
        isPremium: true,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFCC2B5E), Color(0xFF753A88)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      ExportBackground(
        id: 'mango_pulp',
        name: 'Mango Pulp',
        type: BackgroundType.gradient,
        isPremium: true,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF09819), Color(0xFFEDDE5D)],
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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      ExportBackground(
        id: 'flamingo',
        name: 'Flamingo',
        type: BackgroundType.gradient,
        isPremium: true,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFEC008C), Color(0xFFFC6767)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      ExportBackground(
        id: 'deep_sea',
        name: 'Deep Sea',
        type: BackgroundType.gradient,
        isPremium: true,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2C3E50), Color(0xFF4CA1AF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      ExportBackground(
        id: 'cotton_candy',
        name: 'Cotton Candy',
        type: BackgroundType.gradient,
        isPremium: true,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFAFBD), Color(0xFFFFC3A0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      ExportBackground(
        id: 'emerald',
        name: 'Emerald',
        type: BackgroundType.gradient,
        isPremium: true,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      ExportBackground(
        id: 'royal_purple',
        name: 'Royal Purple',
        type: BackgroundType.gradient,
        isPremium: true,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF141E30), Color(0xFF243B55)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      ExportBackground(
        id: 'peach_sunrise',
        name: 'Peach Sunrise',
        type: BackgroundType.gradient,
        isPremium: true,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFE29F), Color(0xFFFFA99F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      ExportBackground(
        id: 'berry_smoothie',
        name: 'Berry Smoothie',
        type: BackgroundType.gradient,
        isPremium: true,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF833AB4), Color(0xFFFD1D1D), Color(0xFFFCB045)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      ExportBackground(
        id: 'mint_fresh',
        name: 'Mint Fresh',
        type: BackgroundType.gradient,
        isPremium: true,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF43C6AC), Color(0xFFF8FFAE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      ExportBackground(
        id: 'blood_moon',
        name: 'Blood Moon',
        type: BackgroundType.gradient,
        isPremium: true,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF870000), Color(0xFF190A05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      ExportBackground(
        id: 'sakura',
        name: 'Sakura',
        type: BackgroundType.gradient,
        isPremium: true,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFDEE9), Color(0xFFB5FFFC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ];
  }
}