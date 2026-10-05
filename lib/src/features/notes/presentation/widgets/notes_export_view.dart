import 'dart:io';
import 'package:book_sync/core/constants/app_constants.dart';
import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/theme/app_colors.dart';
import 'package:book_sync/core/utils/categories_helper.dart';
import 'package:flutter/material.dart';

class NotesExportView extends StatelessWidget {
  final String noteContent;
  final String bookTitle;
  final String? bookAuthor;
  final String? coverImagePath;
  final String? pageNumber;
  final String category;

  const NotesExportView({
    super.key,
    required this.noteContent,
    required this.bookTitle,
    this.bookAuthor,
    this.coverImagePath,
    this.pageNumber,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      width: 320,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.transparent, // Permite ver el fondo seleccionado en ExportCanvasWrapper
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Branding (Logo + Nombre)
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: Image.asset(
                  'assets/images/app_logo.png',
                  width: 22,
                  height: 22,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                AppConstants.appName,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.oliveGreen.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              NoteCategoryHelper.getLabelById(category, context.l10n),
              style: context.theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.oliveGreen,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Icono decorativo de comillas / cita
          Icon(
            Icons.format_quote_rounded,
            size: 36,
            color: theme.primaryColor.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 8),

          // Contenido de la Nota
          Text(
            '"$noteContent"',
            style: theme.textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 24),

          // Pie de la tarjeta: Portada, Título, Autor y Página
          Row(
            children: [
              if (coverImagePath != null && coverImagePath!.isNotEmpty) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Image.file(
                    File(coverImagePath!),
                    width: 38,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 38,
                      height: 56,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.book_outlined, size: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bookTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (bookAuthor != null && bookAuthor!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        context.l10n.exportNoteBy(bookAuthor!),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.8),
                            ),
                      ),
                    ],
                    if (pageNumber != null && pageNumber!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Pág. $pageNumber',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: context.cozy.bookmarkColor?.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}