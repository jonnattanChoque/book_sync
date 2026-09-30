import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/widgets/primary_outlined_button.dart';
import 'package:book_sync/src/features/reader_session/presentation/providers/unrated_books_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_sync/src/domain/book.dart';

class BookRatingModal extends ConsumerStatefulWidget {
  final Book book;

  const BookRatingModal({super.key, required this.book});

  /// Retorna `true` si el usuario guardó la calificación o `false` / `null` si cerró el modal sin calificar.
  static Future<bool?> show(BuildContext context, Book book) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: context.theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      barrierColor: context.cozy.inkColor!.withValues(alpha: 0.2),
      showDragHandle: true,
      isDismissible: true,
      isScrollControlled: true,
      sheetAnimationStyle: AnimationStyle(curve: Curves.bounceOut),
      builder: (context) => BookRatingModal(book: book),
    );
  }

  @override
  ConsumerState<BookRatingModal> createState() => _BookRatingModalState();
}

class _BookRatingModalState extends ConsumerState<BookRatingModal> {
  double _rating = 0.0;
  final TextEditingController _conclusionsController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _conclusionsController.dispose();
    super.dispose();
  }

  Future<void> _submitRating() async {
    if (_rating == 0) return;

    setState(() => _isSubmitting = true);

    await ref
      .read(unratedBooksNotifierProvider.notifier)
      .submitRatingAndConclusions(
        bookId: widget.book.id,
        rating: _rating,
        conclusions: _conclusionsController.text.trim(),
      );
    widget.book.rating = _rating;
    widget.book.conclusions = _conclusionsController.text.trim();

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 16, 24, 24 + bottomInset),
      decoration: BoxDecoration(
        color: context.theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.emoji_events_rounded,
              size: 48,
              color: Colors.amber,
            ),
            const SizedBox(height: 12),

            Text(
              context.l10n.congratulationsFinishedTitle,
              style: context.theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),

            Text(
              widget.book.title,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // Control de Calificación por Estrellas
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star_rounded,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() => _rating = rating);
              },
            ),
            const SizedBox(height: 20),

            // Campo para Conclusiones
            TextFormField(
              controller: _conclusionsController,
              maxLines: 3,
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: context.l10n.conclusionsHint,
                hintStyle: context.theme.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                filled: true,
                fillColor: context.theme.cardColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: context.cozy.inkColor!.withValues(alpha: 0.5),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: context.cozy.inkColor!.withValues(alpha: 0.8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: double.infinity,
                    child: PrimaryOutlinedButton(
                      label: context.l10n.skipRatingButton, 
                      onPressed: () => Navigator.of(context).pop(false)
                    )
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: double.infinity,
                    child: PrimaryOutlinedButton(
                      label: context.l10n.saveAndFinishButton, 
                      onPressed: () {
                        (_rating > 0 && !_isSubmitting)
                        ? _submitRating()
                        : null;
                      }
                    )
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}