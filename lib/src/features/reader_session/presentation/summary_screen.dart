import 'package:book_sync/core/theme/cozy_colors.dart';
import 'package:book_sync/core/widgets/background_paper_texture.dart';
import 'package:book_sync/core/widgets/book_cover_image.dart';
import 'package:book_sync/l10n/app_localizations.dart';
import 'package:book_sync/src/domain/book.dart';
import 'package:flutter/material.dart';

class SessionSummaryPage extends StatelessWidget {
  final Book book;
  final ReadingSession session;

  const SessionSummaryPage({
    super.key,
    required this.book,
    required this.session,
  });

  void _goHome(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cozy = theme.extension<CozyColors>()!;

    // Usamos la página final de la sesión para reflejar el progreso actual
    final int effectiveCurrentPage = session.endPage > 0 ? session.endPage : book.currentPage;
    final int totalPages = book.totalPages ?? 0;
    final double calculatedProgress = totalPages > 0 
      ? (effectiveCurrentPage / totalPages).clamp(0.0, 1.0) 
      : book.progress;

    final int remainingPages = totalPages > effectiveCurrentPage 
      ? totalPages - effectiveCurrentPage 
      : 0;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _goHome(context);
      },
      child: Stack(
        children: [
          const Positioned.fill(
            child: BackgroundPaperTexture(),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
                onPressed: () => _goHome(context),
              ),
              title: Text(
                l10n.sessionSummaryTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 1. Tarjeta con imagen del libro, título y barra de progreso
                    Card(
                      elevation: 0,
                      color: theme.cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                        side: BorderSide(
                          color: cozy.inkColor!.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            BookCoverImage(
                              coverPath: book.coverPath,
                              inkColor: cozy.inkColor,
                              fit: BoxFit.cover,
                              iconSize: 60,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    book.title,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onSurface,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 12),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(4.0),
                                    child: LinearProgressIndicator(
                                      value: calculatedProgress,
                                      minHeight: 6,
                                      backgroundColor: cozy.inkColor!.withValues(alpha: 0.1),
                                      valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${(calculatedProgress * 100).toStringAsFixed(1)}%',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
          
                    // FECHA DE LA SESIÓN (Agregada debajo de la Card)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 20.0, left: 4.0),
                      child: Text(
                        session.formattedDate,
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
          
                    // 2. Tarjeta con métricas destacadas
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: cozy.inkColor!.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Resumen de páginas y tiempo
                          _HighlightedInfoRow(
                            icon: Icons.auto_stories_outlined,
                            fullText: l10n.readSummaryInfo(
                              session.pagesRead,
                              session.durationFormatted,
                            ),
                            highlightTargets: [
                              '${session.pagesRead}',
                              session.durationFormatted,
                            ],
                            theme: theme,
                          ),
                          Divider(height: 32, color: cozy.inkColor!.withValues(alpha: 0.1)),
          
                          // Velocidad promedio
                          _HighlightedInfoRow(
                            icon: Icons.speed_rounded,
                            fullText: l10n.readingSpeedInfo(
                              session.pagesPerHour.toStringAsFixed(2),
                            ),
                            highlightTargets: [
                              session.pagesPerHour.toStringAsFixed(2),
                            ],
                            theme: theme,
                          ),
                          Divider(height: 32, color: cozy.inkColor!.withValues(alpha: 0.1)),
          
                          // Tiempo estimado restante
                          _HighlightedInfoRow(
                            icon: Icons.timer_outlined,
                            fullText: l10n.timeRemainingInfo(
                              book.remainingTimeText != '-' ? book.remainingTimeText : '4h 11m', // Fallback si es mock
                            ),
                            highlightTargets: [
                              book.remainingTimeText != '-' ? book.remainingTimeText : '4h 11m',
                            ],
                            theme: theme,
                          ),
                          Divider(height: 32, color: cozy.inkColor!.withValues(alpha: 0.1)),
          
                          // Páginas restantes
                          _HighlightedInfoRow(
                            icon: Icons.menu_book_rounded,
                            fullText: l10n.pagesRemainingInfo(remainingPages),
                            highlightTargets: [
                              '$remainingPages',
                            ],
                            theme: theme,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }
}

/// Widget interno para fragmentar la cadena y aplicar resaltado
class _HighlightedInfoRow extends StatelessWidget {
  final IconData icon;
  final String fullText;
  final List<String> highlightTargets;
  final ThemeData theme;

  const _HighlightedInfoRow({
    required this.icon,
    required this.fullText,
    required this.highlightTargets,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {

    final defaultStyle = theme.textTheme.bodyMedium?.copyWith(
      fontSize: 14,
      color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
    );

    final highlightStyle = theme.textTheme.bodySmall?.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 18
    );

    List<TextSpan> spans = [];
    String tempText = fullText;

    // Algoritmo simple para reemplazar y resaltar los fragmentos clave
    while (tempText.isNotEmpty) {
      int earliestIndex = -1;
      String? foundTarget;

      for (var target in highlightTargets) {
        final index = tempText.indexOf(target);
        if (index != -1 && (earliestIndex == -1 || index < earliestIndex)) {
          earliestIndex = index;
          foundTarget = target;
        }
      }

      if (earliestIndex != -1 && foundTarget != null) {
        if (earliestIndex > 0) {
          spans.add(TextSpan(text: tempText.substring(0, earliestIndex)));
        }
        spans.add(TextSpan(text: foundTarget, style: highlightStyle));
        tempText = tempText.substring(earliestIndex + foundTarget.length);
      } else {
        spans.add(TextSpan(text: tempText));
        break;
      }
    }

    return Row(
      children: [
        Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 26,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: defaultStyle,
              children: spans,
            ),
          ),
        ),
      ],
    );
  }
}