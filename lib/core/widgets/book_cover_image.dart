// lib/src/common_widgets/book_cover_image.dart

import 'dart:io';
import 'package:flutter/material.dart';

class BookCoverImage extends StatelessWidget {
  final String? coverPath;
  final BoxFit fit;
  final double iconSize;
  final Color? inkColor;
  final Widget? customLoader;
  final Widget? customFallback;

  const BookCoverImage({
    super.key,
    required this.coverPath,
    this.fit = BoxFit.cover,
    this.iconSize = 30.0,
    this.inkColor,
    this.customLoader,
    this.customFallback,
  });

  @override
  Widget build(BuildContext context) {
    final fallback = customFallback ??
        Center(
          child: Icon(
            Icons.book, // o tu AppIcons.bookPlaceholder
            color: (inkColor ?? Colors.grey).withValues(alpha: 0.3),
            size: iconSize,
          ),
        );

    // 1. Validar si la ruta es nula o vacía
    if (coverPath == null || coverPath!.trim().isEmpty) {
      return fallback;
    }

    final isNetworkImage = coverPath!.startsWith('http://') || coverPath!.startsWith('https://');

    // 2. Imagen de red
    if (isNetworkImage) {
      return Image.network(
        coverPath!,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          if (customLoader != null) return customLoader!; 

          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => fallback,
      );
    }

    // 3. Imagen local
    final file = File(coverPath!);
    if (!file.existsSync()) {
      return fallback;
    }

    return Image.file(
      file,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => fallback,
    );
  }
}