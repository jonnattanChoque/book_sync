import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/theme/app_colors.dart';
import 'package:book_sync/core/utils/categories_helper.dart';
import 'package:book_sync/src/domain/book.dart';
import 'package:book_sync/src/domain/note.dart';
import 'package:book_sync/src/features/export/presentation/export_preview_sheet.dart';
import 'package:book_sync/src/features/notes/presentation/widgets/notes_export_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailNoteItem extends ConsumerWidget {
  final Book book;
  final Note note;

  const DetailNoteItem({
    super.key, 
    required this.book,
    required this.note,
  });

  void _openNoteExportSheet(BuildContext context, Note note, Book book) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ExportPreviewSheet(
          exportContent: NotesExportView(
            noteContent: note.content,
            bookTitle: book.title,
            bookAuthor: book.author,
            coverImagePath: book.coverPath,
            pageNumber: note.page.toString(),
            category: note.category,
          ),
          shareText: '"${note.content}" - ${book.title}'
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.theme.cardColor.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: context.cozy.inkColor?.withValues(alpha: 0.08) ?? Colors.grey.shade300,
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
              Row(
                children: [
                  Text(
                    '${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}',
                    style: context.theme.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.ios_share_outlined, size: 18),
                    tooltip: context.l10n.exportNoteTooltip,
                    visualDensity: VisualDensity.compact,
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(4),
                    onPressed: () => _openNoteExportSheet(context, note, book),
                  ),
                ],
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