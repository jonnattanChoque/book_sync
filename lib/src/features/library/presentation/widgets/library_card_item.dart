import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/src/domain/book.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LibraryCardItem extends ConsumerWidget {
  final Book book;
  final bool isFinished;

  const LibraryCardItem({
    super.key, 
    required this.book, 
    required this.isFinished,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 0,
      color: context.theme.cardColor.withValues(alpha: 0.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: context.cozy.bookmarkColor!.withValues(alpha: 0.3), // Borde más activo
        ),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell( // Reemplazamos GestureDetector por InkWell para el feedback táctil
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          context.push('/book_detail', extra: book);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: ListTile(
            title: Text(
              book.title, 
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(book.author),
                if (isFinished) ...[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (starIndex) {
                      final starValue = starIndex + 1.0;
                      return Icon(
                        (book.rating ?? 0) >= starValue
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: Colors.amber,
                        size: 16,
                      );
                    }),
                  ),
                ],
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${(book.progress * 100).toStringAsFixed(1)}%",
                  style: context.theme.textTheme.labelMedium,
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.chevron_right_rounded, // Indicador explícito de que es clickeable
                  size: 20,
                  color: context.cozy.bookmarkColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}