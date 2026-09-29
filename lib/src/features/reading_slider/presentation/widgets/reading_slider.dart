import 'package:book_sync/core/widgets/add_note_modal.dart';
import 'package:book_sync/core/widgets/book_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar/isar.dart';

import 'package:book_sync/core/theme/cozy_colors.dart';
import 'package:book_sync/l10n/app_localizations.dart';
import 'package:book_sync/src/features/reading_slider/presentation/widgets/create_book_bottomsheet.dart';
import 'package:book_sync/src/features/reading_slider/presentation/widgets/reading_empty_card.dart';
import 'package:book_sync/src/features/reading_slider/presentation/providers/books_provider.dart'; 
import 'reading_card.dart';

class ReadingSlider extends ConsumerStatefulWidget {
  const ReadingSlider({super.key});

  @override
  ConsumerState<ReadingSlider> createState() => _ReadingSliderState();
}

class _ReadingSliderState extends ConsumerState<ReadingSlider> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.75, initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<Id?>(selectedBookIdProvider, (previous, nextBookId) {
      if (nextBookId != null) {
        final books = ref.read(currentlyReadingProvider).value ?? [];
        final targetIndex = books.indexWhere((book) => book.id == nextBookId);

        if (targetIndex != -1 && _pageController.hasClients) {
          _pageController.animateToPage(
            targetIndex,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        }

        ref.read(selectedBookIdProvider.notifier).state = null;
      }
    });

    final cozy = Theme.of(context).extension<CozyColors>()!;
    final readingBooksAsync = ref.watch(currentlyReadingProvider);

    return SizedBox(
      height: 400,
      child: readingBooksAsync.when(
        data: (books) {
          if (books.isEmpty) {
            return Center(
              child: _showReadingEmptyCard(context, cozy, AppLocalizations.of(context)!.noBooksTitle),
            );
          }
          final totalItems = books.length + 1;

          return PageView.builder(
            controller: _pageController,
            physics: const BouncingScrollPhysics(),
            itemCount: totalItems,
            itemBuilder: (context, index) {
              if (index == books.length) {
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 1.0;
                    if (_pageController.position.haveDimensions) {
                      value = _pageController.page! - index;
                      value = (1 - (value.abs() * 0.2)).clamp(0.8, 1.0);
                    }
                    return Center(
                      child: Transform.scale(
                        scale: value,
                        child: Opacity(
                          opacity: value,
                          child: _showReadingEmptyCard(context, cozy, AppLocalizations.of(context)!.createBookTitle),
                        ),
                      ),
                    );
                  },
                );
              }

              final book = books[index];
              
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                    value = (1 - (value.abs() * 0.2)).clamp(0.8, 1.0);
                  }
                  return Center(
                    child: Transform.scale(
                      scale: value,
                      child: Opacity(
                        opacity: value,
                        child: ReadingCard(
                          book: book,
                          onTimerPressed: () {
                            context.push('/reading_session', extra: book);
                          },
                          onNotesPressed: () {
                            AddNoteModal.show(context, book: book);
                          },
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: BookLoader()),
        error: (error, stackTrace) => Center(
          child: Text('Error al cargar libros: $error'),
        ),
      ),
    );
  }

  Widget _showReadingEmptyCard(BuildContext context, CozyColors cozy, String title) {
    return ReadingEmptyCard(
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Theme.of(context).cardColor.withValues(alpha: 0.85),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          barrierColor: cozy.inkColor!.withValues(alpha: 0.2),
          showDragHandle: true,
          isDismissible: true,
          sheetAnimationStyle: AnimationStyle(curve: Curves.bounceOut),
          context: context,
          builder: (context) => const CreateBookBottomsheet(),
        );
      }, 
      title: title,
    );
  }
}