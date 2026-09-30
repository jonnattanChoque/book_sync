import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/widgets/background_paper_texture.dart';
import 'package:book_sync/core/widgets/book_cover_image.dart';
import 'package:book_sync/core/widgets/book_loader.dart';
import 'package:book_sync/core/widgets/book_rating_modal.dart';
import 'package:book_sync/src/domain/book.dart';
import 'package:book_sync/src/features/streak/presentation/providers/streak_providers.dart';
import 'package:book_sync/src/features/streak/presentation/widgets/streak_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionSummaryPage extends ConsumerStatefulWidget {
  final Book book;
  final ReadingSession session;

  const SessionSummaryPage({
    super.key,
    required this.book,
    required this.session
  });

  @override
  ConsumerState<SessionSummaryPage> createState() => _SessionSummaryPageState();
}

class _SessionSummaryPageState extends ConsumerState<SessionSummaryPage> {
  late bool _hasRated;
  bool _modalDismissed = false;

  bool get _isBookFinished {
    final total = widget.book.totalPages;
    return total != null && total > 0 && widget.session.endPage >= total;
  }

  bool get _canPop {
    if (!_isBookFinished) return true;
    return _hasRated || _modalDismissed;
  }

  @override
  void initState() {
    super.initState();
    _hasRated = widget.book.rating != null && widget.book.rating! > 0;

    if (_isBookFinished && !_hasRated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scheduleRatingModal();
      });
    }
  }

  Future<void> _scheduleRatingModal() async {
    await Future.delayed(const Duration(milliseconds: 3500));
    if (!mounted) return;

    await _showRatingModal();
  }

  Future<void> _showRatingModal() async {
    final rated = await BookRatingModal.show(context, widget.book);

    if (mounted) {
      setState(() {
        _modalDismissed = true;
        if (rated == true) {
          _hasRated = true; 
        }
      });
    }
  }

  void _goHome(BuildContext context) {
    if (!_canPop) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.ratingRequiredMessage),
        ),
      );
      return;
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final streakAsync = ref.watch(userStreakStreamProvider);
    final int effectiveCurrentPage = widget.session.endPage > 0 ? widget.session.endPage : widget.book.currentPage;
    final int totalPages = widget.book.totalPages ?? 0;
    final double calculatedProgress = totalPages > 0 
      ? (effectiveCurrentPage / totalPages).clamp(0.0, 1.0) 
      : widget.book.progress;

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
              leading: _canPop
                ? IconButton(
                    icon: Icon(Icons.close, color: context.colorScheme.onSurface),
                    onPressed: () => _goHome(context),
                  )
                : const SizedBox.shrink(),
              title: Text(
                context.l10n.sessionSummaryTitle,
                style: context.theme.textTheme.titleLarge?.copyWith(
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
                    _buildBookCard(context, calculatedProgress),
          
                    // FECHA DE LA SESIÓN (Agregada debajo de la Card)
                    _buildDate(context),
          
                    // 2. Tarjeta con métricas destacadas
                    _buildMetrics(context, remainingPages),
                    const SizedBox(height: 16),
                    streakAsync.when(
                      data: (streak) {
                        final current = streak?.currentStreak ?? 1;
                        final previous = current > 1 ? current - 1 : 0;

                        return StreakSummaryCard(
                          previousStreak: previous,
                          currentStreak: current,
                        );
                      },
                      loading: () => BookLoader(),
                      error: (_, _) => const SizedBox.shrink(),
                    ),
                    if (_isBookFinished && !_hasRated)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: const Icon(Icons.star_outline_rounded, color: Colors.amber),
                            label: Text(context.l10n.rateThisBookAction),
                            onPressed: _showRatingModal
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ),
        ]
      ),
    );
  }

  Card _buildBookCard(BuildContext context, double calculatedProgress) {
    return Card(
      elevation: 0,
      color: context.theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(
          color: context.cozy.inkColor!.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            BookCoverImage(
              coverPath: widget.book.coverPath,
              inkColor: context.cozy.inkColor,
              fit: BoxFit.cover,
              iconSize: 20,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.book.title,
                    style: context.theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onSurface,
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
                      backgroundColor: context.cozy.inkColor!.withValues(alpha: 0.1),
                      valueColor: AlwaysStoppedAnimation<Color>(context.colorScheme.primary),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${(calculatedProgress * 100).toStringAsFixed(1)}%',
                    style: context.theme.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildDate(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 20.0, left: 4.0),
      child: Center(
        child: Text(
          widget.session.formattedDate,
          style: context.theme.textTheme.titleLarge,
        ),
      ),
    );
  }

  Container _buildMetrics(BuildContext context, int remainingPages) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: context.cozy.inkColor!.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          // Resumen de páginas y tiempo
          _HighlightedInfoRow(
            icon: Icons.auto_stories_outlined,
            fullText: context.l10n.readSummaryInfo(
              widget.session.pagesRead,
              widget.session.durationFormatted,
            ),
            highlightTargets: [
              '${widget.session.pagesRead}',
              widget.session.durationFormatted,
            ],
            theme: context.theme,
          ),
          Divider(height: 32, color: context.cozy.inkColor!.withValues(alpha: 0.1)),

          // Velocidad promedio
          _HighlightedInfoRow(
            icon: Icons.speed_rounded,
            fullText: context.l10n.readingSpeedInfo(
              widget.session.pagesPerHour.toStringAsFixed(2),
            ),
            highlightTargets: [
              widget.session.pagesPerHour.toStringAsFixed(2),
            ],
            theme: context.theme,
          ),
          Divider(height: 32, color: context.cozy.inkColor!.withValues(alpha: 0.1)),

          // Tiempo estimado restante
          _HighlightedInfoRow(
            icon: Icons.timer_outlined,
            fullText: context.l10n.timeRemainingInfo(
              widget.book.remainingTimeText != '-' ? widget.book.remainingTimeText : '4h 11m', // Fallback si es mock
            ),
            highlightTargets: [
              widget.book.remainingTimeText != '-' ? widget.book.remainingTimeText : '4h 11m',
            ],
            theme: context.theme,
          ),
          Divider(height: 32, color: context.cozy.inkColor!.withValues(alpha: 0.1)),

          // Páginas restantes
          _HighlightedInfoRow(
            icon: Icons.menu_book_rounded,
            fullText: context.l10n.pagesRemainingInfo(remainingPages),
            highlightTargets: [
              '$remainingPages',
            ],
            theme: context.theme,
          ),
        ],
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