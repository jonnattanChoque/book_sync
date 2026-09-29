import 'package:book_sync/core/constants/app_icons.dart';
import 'package:book_sync/core/widgets/book_cover_image.dart';
import 'package:book_sync/core/widgets/primary_outlined_button.dart';
import 'package:book_sync/src/domain/book.dart';
import 'package:flutter/material.dart';
import 'package:book_sync/core/theme/cozy_colors.dart';
import 'package:book_sync/core/widgets/hand_drawn_border_painter.dart';
import 'package:book_sync/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class ReadingCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onTimerPressed;
  final VoidCallback? onNotesPressed;

  const ReadingCard({
    super.key,
    required this.book,
    this.onTimerPressed,
    this.onNotesPressed,
  });

  @override
  Widget build(BuildContext context) {
    final cozy = Theme.of(context).extension<CozyColors>()!;
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return CustomPaint(
      painter: HandDrawnBorderPainter(color: cozy.inkColor!.withValues(alpha: 0.5)),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          context.push('/book_detail', extra: book);
        },
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              width: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCover(cozy, context),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.title,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                book.author,
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: cozy.textColor?.withValues(alpha: 0.7),
                                ),
                                maxLines: 4,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  Divider(
                    height: 16,
                    thickness: 1,
                    color: cozy.inkColor?.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 8),

                  // Fechas y Estimados de Tiempo
                  _buldDatesAndTimes(context, cozy),
                  const SizedBox(height: 8),

                  // Acciones: Cronómetro y Notas
                  _buildActionButtons(cozy, l10n),
                  const SizedBox(height: 8),

                  // Barra e Información de Progreso
                  _buildProgress(l10n, context, cozy),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: LinearProgressIndicator(
                        value: book.progress,
                        minHeight: 6,
                        backgroundColor: cozy.inkColor!.withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                      ),
                    ),
                  )
                ],
              )
            ),

            // Bookmark del Día de Lectura ubicado en la esquina superior derecha de toda la tarjeta
            Positioned(
              top: 0,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: cozy.bookmarkColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Text(
                  book.readingDayText,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildProgress(AppLocalizations l10n, BuildContext context, CozyColors cozy) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l10n.progressLabel((book.progress * 100).toStringAsFixed(1)),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: cozy.textColor?.withValues(alpha: 0.7),
          ),
        ),
        Text(
          book.totalPages != null
            ? 'Pág. ${book.currentPage} / ${book.totalPages}'
            : 'Pág. ${book.currentPage}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: cozy.textColor?.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Row _buildActionButtons(CozyColors cozy, AppLocalizations l10n) {
    final count = book.notesCount ?? 0;

    return Row(
      children: [
        Expanded(
          child: PrimaryOutlinedButton(
            onPressed: () => onTimerPressed?.call(),
            icon: Icons.timer_outlined,
            label: l10n.newSession,
          ),
        ),
        const SizedBox(width: 0),
        Expanded(
          child: PrimaryOutlinedButton(
            onPressed: () => onNotesPressed?.call(),
            icon: Icons.add_comment_outlined,
            label: count > 0
              ? "${l10n.addNote}($count)"
              : l10n.addNote,
          ),
        ),
      ],
    );
  }

  Column _buldDatesAndTimes(BuildContext context, CozyColors cozy) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Inicio: ${book.startDateText}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: cozy.inkColor?.withValues(alpha: 0.9),
          ),
        ),
        Text(
          'Restante: ${book.remainingTimeText}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: cozy.inkColor?.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildCover(CozyColors cozy, BuildContext context) {
    return SizedBox(
      height: 150,
      width: 100,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: book.coverPath != null && book.coverPath!.isNotEmpty
            ? _buildCoverImage(book.coverPath!, cozy)
            : Center(
                child: Icon(
                  AppIcons.bookPlaceholder,
                  color: cozy.inkColor!.withValues(alpha: 0.2),
                  size: 50,
                ),
              ),
      ),
    );
  }

  Widget _buildCoverImage(String coverPath, CozyColors cozy) {
    return BookCoverImage(
      coverPath: coverPath,
      inkColor: cozy.inkColor,
      fit: BoxFit.contain,
      iconSize: 40,
    );
  }
}