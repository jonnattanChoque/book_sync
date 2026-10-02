// lib/src/features/home/presentation/widgets/home_library_card.dart

import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/widgets/book_cover_image.dart';
import 'package:book_sync/core/widgets/book_loader.dart';
import 'package:book_sync/src/domain/book.dart';
import 'package:book_sync/src/features/home/presentation/widgets/home_base_card.dart';
import 'package:book_sync/src/features/reading_slider/presentation/providers/books_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeLibraryCard extends ConsumerWidget {
  const HomeLibraryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allBooksAsync = ref.watch(allBooksProvider);

    return allBooksAsync.when(
      data: (books) {
        final previewBooks = books.take(5).toList();

        return HomeBaseCard(
          onTap: () => context.push('/library'),
          child: _buildHomeCardContent(context, books, previewBooks),
        );
      },
      loading: () => const HomeBaseCard(
        child: SizedBox(
          height: 60,
          child: Center(child: BookLoader()),
        ),
      ),
      error: (_, _) => HomeBaseCard(
        child: Text(
          context.l10n.errorLoadLibrary,
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Column _buildHomeCardContent(BuildContext context, List<Book> books, List<Book> previewBooks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.libraryTitle,
              style: const TextStyle(
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
                color: context.cozy.bookmarkColor!.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                books.length == 1
                    ? context.l10n.libraryOneCount(1)
                    : context.l10n.libraryCount(books.length),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: context.cozy.bookmarkColor!.withValues(alpha: 0.6),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (previewBooks.isEmpty)
          Text(
            context.l10n.noBooksRegistered,
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