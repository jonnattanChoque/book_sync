import 'package:book_sync/core/theme/app_colors.dart';
import 'package:book_sync/core/theme/cozy_colors.dart';
import 'package:book_sync/core/widgets/book_cover_image.dart';
import 'package:book_sync/core/widgets/book_loader.dart';
import 'package:book_sync/l10n/app_localizations.dart';
import 'package:book_sync/src/domain/book.dart';
import 'package:book_sync/src/features/reading_slider/presentation/providers/books_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeLibraryCard extends ConsumerWidget {
  const HomeLibraryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allBooksAsync = ref.watch(allBooksProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: allBooksAsync.when(
        data: (books) {
          final previewBooks = books.take(5).toList();
          final cozy = Theme.of(context).extension<CozyColors>()!;

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                context.push('/library');
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: cozy.bookmarkColor!.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.libraryTitle,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: cozy.bookmarkColor!.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.libraryCount(books.length),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: cozy.bookmarkColor!.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (previewBooks.isEmpty)
                      Text(
                        AppLocalizations.of(context)!.noBooksRegistered,
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      )
                    else
                      SizedBox(
                        height: 60,
                        child: Stack(
                          children: previewBooks.asMap().entries.map((entry) {
                            int index = entry.key;
                            return Positioned(
                              left: index * 45.0,
                              child: _buildBookAvatar(entry.value),
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => Container(
          height: 110,
          padding: const EdgeInsets.all(20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.prussianBlue.withValues(alpha: 0.2)),
          ),
          child: const SizedBox(
            height: 24,
            width: 24,
            child: BookLoader(),
          ),
        ),
        error: (err, stack) => Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
          ),
          child: const Text(
            "Error al cargar la biblioteca",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  Widget _buildBookAvatar(Book book) {
    final coverPath = book.coverPath;

    return CircleAvatar(
      radius: 30,
      backgroundColor: Colors.grey.shade300,
      child: ClipOval(
        child: SizedBox(
          width: 60,
          height: 60,
          child: _buildCoverImage(coverPath),
        ),
      ),
    );
  }

  Widget _buildCoverImage(String? coverPath) {
    return BookCoverImage(
      coverPath: coverPath,
      fit: BoxFit.cover,
      customLoader: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: BookLoader(),
        ),
      ),
      customFallback: _buildFallbackIcon(),
    );
  }

  Widget _buildFallbackIcon() {
    return Container(
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: Icon(
        Icons.book_rounded,
        size: 28,
        color: Colors.grey.shade600,
      ),
    );
  }
}