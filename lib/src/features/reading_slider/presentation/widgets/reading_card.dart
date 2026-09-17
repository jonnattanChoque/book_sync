import 'dart:io';
import 'package:book_sync/core/widgets/hand_drawn_border_painter.dart';
import 'package:book_sync/l10n/app_localizations.dart';
import 'package:book_sync/src/domain/book.dart';
import 'package:flutter/material.dart';
import 'package:book_sync/core/theme/cozy_colors.dart';

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

    // 1. Calcular fecha de inicio de lectura (la sesión más antigua)
    String startDateText = '-';
    if (book.sessions.isNotEmpty) {
      final sortedSessions = book.sessions.toList()
        ..sort((a, b) => a.date.compareTo(b.date));
      final firstDate = sortedSessions.first.date;
      startDateText = '${firstDate.day}/${firstDate.month}/${firstDate.year}';
    }

    // 2. Calcular tiempo restante estimado de lectura
    // Buscamos velocidad promedio (páginas por minuto) basada en las sesiones
    int totalMinutesRead = 0;
    int totalPagesReadInSessions = 0;
    for (var session in book.sessions) {
      totalMinutesRead += session.minutesRead;
      if (session.startPage != null) {
        totalPagesReadInSessions += (session.endPage - session.startPage!);
      }
    }

    String remainingTimeText = '-';
    if (totalMinutesRead > 0 && totalPagesReadInSessions > 0 && book.totalPages != null) {
      double pagesPerMinute = totalPagesReadInSessions / totalMinutesRead;
      int remainingPages = book.totalPages! - book.currentPage;
      if (remainingPages > 0 && pagesPerMinute > 0) {
        double remainingMinutes = remainingPages / pagesPerMinute;
        if (remainingMinutes < 60) {
          remainingTimeText = '~${remainingMinutes.toInt()} min';
        } else {
          double remainingHours = remainingMinutes / 60;
          remainingTimeText = '~${remainingHours.toStringAsFixed(1)} hrs';
        }
      } else {
        remainingTimeText = '0 min';
      }
    }

    // 3. Verificar si hay notas en las sesiones
    final sessionsWithNotes = book.sessions.where((s) => s.note != null && s.note!.trim().isNotEmpty).toList();
    final hasNotes = sessionsWithNotes.isNotEmpty;

    return CustomPaint(
      painter: HandDrawnBorderPainter(color: cozy.inkColor!.withValues(alpha: 0.5)),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 280,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Portada y Badge de Notas superpuesto
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: cozy.inkColor!.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: book.coverPath != null && book.coverPath!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: _buildCoverImage(book.coverPath!, cozy),
                      )
                    : Center(
                        child: Icon(Icons.book, color: cozy.inkColor!.withValues(alpha: 0.2), size: 50),
                      ),
                  ),
                  // Badge de Notas
                  if (hasNotes)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: onNotesPressed,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: cozy.bookmarkColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.note, size: 14, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                '${sessionsWithNotes.length}',
                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // Título y Autor
            Text(book.title, style: Theme.of(context).textTheme.titleMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(book.author, style: Theme.of(context).textTheme.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 8),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Inicio: $startDateText',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cozy.inkColor?.withValues(alpha: 0.9)),
                ),
                Text(
                  'Restante: $remainingTimeText',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cozy.inkColor?.withValues(alpha: 0.9)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: onTimerPressed,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: cozy.bookmarkColor!.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.alarm),
                          SizedBox(width: 8),
                        Text(
                            "iniciar",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: cozy.textColor,
                            ),
                          ),
                        ],
                      )
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: onNotesPressed,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: cozy.bookmarkColor!.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.note_add_outlined),
                          SizedBox(width: 8),
                          Text(
                            "Notas",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: cozy.textColor,
                            ),
                          ),
                        ],
                      )
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 8),
            Text(
              l10n.progressLabel((book.progress * 100).toInt()),
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: book.progress,
              backgroundColor: cozy.inkColor!.withValues(alpha: 0.1),
              color: cozy.bookmarkColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverImage(String coverPath, CozyColors cozy) {
    final isNetworkImage = coverPath.startsWith('http://') || coverPath.startsWith('https://');

    if (isNetworkImage) {
      return Image.network(
        coverPath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Center(
          child: Icon(Icons.broken_image, color: cozy.inkColor!.withValues(alpha: 0.3), size: 40),
        ),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      );
    }

    return Image.file(
      File(coverPath),
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Center(
        child: Icon(Icons.broken_image, color: cozy.inkColor!.withValues(alpha: 0.3), size: 40),
      ),
    );
  }
}