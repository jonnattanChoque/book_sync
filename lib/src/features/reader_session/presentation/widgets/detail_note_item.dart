import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/theme/app_colors.dart';
import 'package:book_sync/core/utils/categories_helper.dart';
import 'package:book_sync/src/domain/note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailNoteItem extends ConsumerWidget {
  final Note note;

  const DetailNoteItem({super.key, 
    required this.note,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.theme.cardColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: context.cozy.inkColor!.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.oliveGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      context.l10n.pageOption(note.page),
                      style: context.theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.oliveGreen,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    NoteCategoryHelper.getLabelById(note.category, context.l10n),
                    style: context.theme.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                '${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}',
                style: context.theme.textTheme.labelSmall?.copyWith(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            note.content,
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}