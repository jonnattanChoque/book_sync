import 'dart:async';
import 'package:book_sync/core/theme/app_colors.dart';
import 'package:book_sync/core/theme/cozy_colors.dart';
import 'package:book_sync/core/utils/categories_helper.dart';
import 'package:book_sync/core/widgets/add_note_modal.dart';
import 'package:book_sync/core/widgets/background_paper_texture.dart';
import 'package:book_sync/core/widgets/book_cover_image.dart';
import 'package:book_sync/core/widgets/hand_drawn_border_painter.dart';
import 'package:book_sync/core/widgets/primary_outlined_button.dart';
import 'package:book_sync/l10n/app_localizations.dart';
import 'package:book_sync/src/domain/book.dart';
import 'package:book_sync/src/domain/note.dart';
import 'package:book_sync/src/features/reader_session/presentation/providers/notes_provider.dart';
import 'package:book_sync/src/features/reader_session/presentation/widgets/finish_reading_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReadingSessionScreen extends ConsumerStatefulWidget {
  final Book book;

  const ReadingSessionScreen({
    super.key,
    required this.book,
  });

  @override
  ConsumerState<ReadingSessionScreen> createState() => _ReadingSessionScreenState();
}

class _ReadingSessionScreenState extends ConsumerState<ReadingSessionScreen> {
  bool _isPaused = true;
  bool _showNotes = false;
  Timer? _timer;
  int _secondsElapsed = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notesNotifierProvider.notifier).loadNotes(widget.book.id);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
      if (_isPaused) {
        _timer?.cancel();
      } else {
        _startTimer();
      }
    });
  }

  void _pauseTimer() {
    setState(() {
      _isPaused = true;
      _timer?.cancel();
    });
  }

  void _continueTimer() {
    setState(() {
      _isPaused = false;
      _startTimer();
    });
  }

  String _getTimerButtonLabel(AppLocalizations l10n) {
  if (_secondsElapsed == 0) {
    return l10n.timerStart;
  }
  return _isPaused ? l10n.timerResume : l10n.timerPause;
}

  String get _formattedTime {
    final hours = _secondsElapsed ~/ 3600;
    final minutes = (_secondsElapsed % 3600) ~/ 60;
    final seconds = _secondsElapsed % 60;

    final minutesStr = minutes.toString().padLeft(2, '0');
    final secondsStr = seconds.toString().padLeft(2, '0');

    if (hours > 0) {
      final hoursStr = hours.toString().padLeft(2, '0');
      return '$hoursStr:$minutesStr:$secondsStr';
    }

    return '$minutesStr:$secondsStr';
  }

  void _toggleNotes() {
    setState(() {
      _showNotes = !_showNotes;
    });
  }

  void _openAddNoteModal(BuildContext context) {
    void onClosePressed() => _continueTimer();
    AddNoteModal.show(context, book: widget.book, onClosePressed: onClosePressed);
  }

  void _showModalFinish() async {
    final activeTimerDuration = Duration(seconds: _secondsElapsed);
    await FinishReadingModal.show(
      context,
      book: widget.book,
      elapsedDuration: activeTimerDuration,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cozy = Theme.of(context).extension<CozyColors>()!;
    final l10n = AppLocalizations.of(context)!;
    final timerButtonBg = _isPaused ? AppColors.oliveGreen : cozy.bookmarkColor;

    final notesState = ref.watch(notesNotifierProvider);

    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: Stack(
        children: [
          const Positioned.fill(
            child: BackgroundPaperTexture(),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: _buildNav(colorScheme, context, l10n, theme),
            body: Column(
              children: [
                // --- 1. CRONÓMETRO FIJO ---
                _buildTimer(l10n, theme, colorScheme, timerButtonBg),

                const SizedBox(height: 12),

                // --- 2. CONTENIDO CON SCROLL (CARD DE LIBRO ANIMADA Y NOTAS) ---
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // La tarjeta con su cambio de color animado
                        Padding(
                          padding: EdgeInsetsGeometry.all(16),
                          child: _buildBookInfoCard(context, theme, colorScheme, cozy, l10n),
                        ),

                        const SizedBox(height: 16),

                        // Sección Desplegable de Notas
                        if (_showNotes) _buildNotesList(context, theme, colorScheme, cozy, l10n, notesState),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  AppBar _buildNav(ColorScheme colorScheme, BuildContext context, AppLocalizations l10n, ThemeData theme) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: colorScheme.onSurface,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        l10n.readingSessionTitle,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Padding _buildTimer(AppLocalizations l10n, ThemeData theme, ColorScheme colorScheme, Color? timerButtonBg) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        children: [
          Text(
            _formattedTime,
            style: theme.textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 3.0,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: timerButtonBg,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _togglePause,
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      _isPaused ? Icons.play_arrow : Icons.pause,
                      key: ValueKey<bool>(_isPaused),
                    ),
                  ),
                  label: Text(
                    _getTimerButtonLabel(l10n),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (_secondsElapsed > 0)
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    side: BorderSide(
                      color: colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    _togglePause();
                    _showModalFinish();
                  },
                  icon: Icon(
                    Icons.stop_circle_outlined,
                    color: colorScheme.onSurface,
                  ),
                  label: Text(
                    l10n.finishSession,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Tarjeta del libro con cambio de color animado al pausar/continuar
  CustomPaint _buildBookInfoCard(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    CozyColors cozy,
    AppLocalizations l10n,
  ) {
    final isDark = theme.brightness == Brightness.dark;
    final cardBackgroundColor = !_isPaused
    ? (isDark
      ? AppColors.prussianBlueDark.withValues(alpha: 0.4)
      : AppColors.latteMain.withValues(alpha: 0.35))
    : Colors.transparent;

    return CustomPaint(
      painter: HandDrawnBorderPainter(color: cozy.inkColor!.withValues(alpha: 0.5)),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: cardBackgroundColor,
          borderRadius: BorderRadius.circular(0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Portada
                SizedBox(
                  height: 110,
                  width: 75,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: widget.book.coverPath != null && widget.book.coverPath!.isNotEmpty
                    ? _buildCoverImage(widget.book.coverPath!, cozy)
                    : Center(
                        child: Icon(
                          Icons.book,
                          color: cozy.inkColor!.withValues(alpha: 0.2),
                          size: 40,
                        ),
                      ),
                  ),
                ),
                const SizedBox(width: 14),
                // Detalles del libro
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.book.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.book.author,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: cozy.textColor?.withValues(alpha: 0.7),
                        ),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Información y Barra de Progreso
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.progressLabel((widget.book.progress * 100).toStringAsFixed(1)),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: cozy.textColor?.withValues(alpha: 0.7),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.book.totalPages != null
                      ? 'Pág. ${widget.book.currentPage} / ${widget.book.totalPages}'
                      : 'Pág. ${widget.book.currentPage}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: cozy.textColor?.withValues(alpha: 0.7),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: LinearProgressIndicator(
                value: widget.book.progress,
                minHeight: 6,
                backgroundColor: cozy.inkColor!.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
              ),
            ),
            Divider(
              height: 24,
              thickness: 1,
              color: cozy.inkColor?.withValues(alpha: 0.2),
            ),

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: _toggleNotes,
                    icon: Icon(
                      _showNotes ? Icons.keyboard_arrow_up : Icons.notes,
                      color: cozy.bookmarkColor,
                    ),
                    label: Text(
                      _showNotes ? l10n.hideNotes : l10n.viewNotes,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: cozy.bookmarkColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: PrimaryOutlinedButton(
                    onPressed: () {
                      _pauseTimer();
                      _openAddNoteModal(context);
                    },
                    icon: Icons.add_comment_outlined,
                    label: l10n.addNote,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverImage(String coverPath, CozyColors cozy) {
    return BookCoverImage(
      coverPath: coverPath,
      inkColor: cozy.inkColor,
      fit: BoxFit.cover,
      iconSize: 30,
    );
  }

  Widget _buildNotesList(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    CozyColors cozy,
    AppLocalizations l10n,
    AsyncValue<List<Note>> notesState,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
          child: Text(
            'Notas del libro',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 8),
        notesState.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (error, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Error al cargar las notas. $error',
                style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.error),
              ),
            ),
          ),
          data: (notes) {
            if (notes.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'No hay notas guardadas para este libro',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: notes.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final note = notes[index];
                final date = note.createdAt;
                final formattedDate =
                    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.cardColor.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: cozy.inkColor!.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.oliveGreen.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  l10n.pageOption(note.page),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.oliveGreen,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                NoteCategoryHelper.getLabelById(note.category, l10n),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            formattedDate,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        note.content,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}