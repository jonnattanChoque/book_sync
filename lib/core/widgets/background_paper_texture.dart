import 'package:book_sync/core/constants/app_assets.dart';
import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BackgroundPaperTexture extends StatelessWidget {
  const BackgroundPaperTexture({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.deepCharcoal : AppColors.beigePaper,
        image: DecorationImage(
          image: AssetImage(
            isDark 
              ? AppAssets.paperGrainDark
              : AppAssets.paperGrainLight,
          ),
          repeat: ImageRepeat.repeat,
          opacity: 0.5,
        ),
      ),
    );
  }
}