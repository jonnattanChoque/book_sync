import 'package:book_sync/core/constants/app_icons.dart';
import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/widgets/book_cover_image.dart';
import 'package:book_sync/core/widgets/primary_outlined_button.dart';
import 'package:book_sync/src/domain/book.dart';
import 'package:flutter/material.dart';
import 'package:book_sync/core/theme/cozy_colors.dart';
import 'package:book_sync/core/widgets/hand_drawn_border_painter.dart';
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

    return CustomPaint(
      painter: HandDrawnBorderPainter(color: context.cozy.inkColor!.withValues(alpha: 0.5)),
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
                      _buildCover(context),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.title,
                                style: context.theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                book.author,
                                style: context.theme.textTheme.bodyMedium?.copyWith(
                                  color: context.cozy.textColor?.withValues(alpha: 0.7),
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
                    color: context.cozy.inkColor?.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 8),

                  // Fechas y Estimados de Tiempo
                  _buldDatesAndTimes(context),
                  const SizedBox(height: 8),

                  // Acciones: Cronómetro y Notas
                  _buildActionButtons(context),
                  const SizedBox(height: 8),

                  // Barra e Información de Progreso
                  _buildProgress(context),
                  const SizedBox(height: 8),
                  _buildProgressLine(context)
                ],
              )
            ),
            _buildDaysRead(context),
          ],
        ),
      ),
    );
  }

  Positioned _buildDaysRead(BuildContext context) {
    final days = book.elapsedDays;
    final dayText = days > 0 ? context.l10n.readingDayText(days) : '';

    return Positioned(
      top: 0,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: context.cozy.bookmarkColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: Text(
          dayText,
          style: context.theme.textTheme.labelSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Row _buildProgress(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.l10n.progressLabel((book.progress * 100).toStringAsFixed(1)),
          style: context.theme.textTheme.titleSmall?.copyWith(
            color: context.cozy.textColor?.withValues(alpha: 0.7),
          ),
        ),
        Text(
          book.totalPages != null
            ? context.l10n.pageProgress(book.currentPage, book.totalPages ?? 0)
            : context.l10n.currentPageFormat(book.currentPage),
          style: context.theme.textTheme.titleSmall?.copyWith(
            color: context.cozy.textColor?.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  ClipRRect _buildProgressLine(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4.0),
        child: LinearProgressIndicator(
          value: book.progress,
          minHeight: 6,
          backgroundColor: context.cozy.inkColor!.withValues(alpha: 0.1),
          valueColor: AlwaysStoppedAnimation<Color>(context.colorScheme.primary),
        ),
      ),
    );
  }

  Row _buildActionButtons(BuildContext context) {
    final count = book.notesCount ?? 0;

    return Row(
      children: [
        Expanded(
          child: PrimaryOutlinedButton(
            onPressed: () => onTimerPressed?.call(),
            icon: Icons.timer_outlined,
            label: context.l10n.newSession,
          ),
        ),
        const SizedBox(width: 0),
        Expanded(
          child: PrimaryOutlinedButton(
            onPressed: () => onNotesPressed?.call(),
            icon: Icons.add_comment_outlined,
            label: count > 0
              ? "${context.l10n.addNote}($count)"
              : context.l10n.addNote,
          ),
        ),
      ],
    );
  }

  Column _buldDatesAndTimes(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.startDateWith(book.startDateText),
          style: context.theme.textTheme.bodyLarge?.copyWith(
            color: context.cozy.inkColor?.withValues(alpha: 0.9),
          ),
        ),
        Text(
          context.l10n.remainingTime(book.remainingTimeText),
          style: context.theme.textTheme.bodyLarge?.copyWith(
            color: context.cozy.inkColor?.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildCover(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 100,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: book.coverPath != null && book.coverPath!.isNotEmpty
        ? _buildCoverImage(book.coverPath!, context.cozy)
        : Center(
            child: Icon(
              AppIcons.bookPlaceholder,
              color: context.cozy.inkColor!.withValues(alpha: 0.2),
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