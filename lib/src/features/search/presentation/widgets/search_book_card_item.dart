import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:book_sync/src/features/reading_slider/presentation/providers/books_provider.dart';
import 'package:book_sync/src/features/search/domain/book_search_dto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SearchBookCardItem extends ConsumerWidget {
  final BookSearchDto book;

  const SearchBookCardItem({super.key, 
    required this.book,
  });

  Future<void> _checkDuplicateIsbn(BuildContext context, WidgetRef ref, BookSearchDto book) async {
    final isbn = book.isbn;
    final checkDuplicateIsbn = ref.read(checkDuplicateIsbnProvider);
    final existingBook = await checkDuplicateIsbn(isbn);

    if (!context.mounted) return; // <-- Usar context.mounted en lugar de mounted directo

    if (existingBook != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(context.l10n.duplicateBookTitle),
            content: Text(context.l10n.duplicateBookMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.pushReplacement('/book_detail', extra: existingBook);
                },
                child: Text(context.l10n.accept),
              ),
            ],
          );
        },
      );
      return;
    }

    context.push('/search_detail', extra: book);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: context.theme.cardColor.withValues(alpha: 0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: book.coverUrl != null && book.coverUrl!.isNotEmpty
            ? Image.network(
                book.coverUrl!,
                width: 48,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildPlaceholderCover(),
              )
            : _buildPlaceholderCover(),
        ),
        title: Text(
          book.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: context.theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            book.authors.isNotEmpty ? book.authors.join(', ') : '---',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: context.theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
        onTap: () {
          _checkDuplicateIsbn(context, ref, book);
        },
      ),
    );
  }

  Widget _buildPlaceholderCover() {
    return Container(
      width: 48,
      height: 70,
      color: AppColors.inkCharcoal.withValues(alpha: 0.1),
      child: Icon(
        Icons.book,
        color: AppColors.inkCharcoal.withValues(alpha: 0.4),
      ),
    );
  }
}