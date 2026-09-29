// ignore_for_file: use_build_context_synchronously

import 'package:book_sync/core/constants/app_icons.dart';
import 'package:book_sync/core/theme/app_colors.dart';
import 'package:book_sync/core/utils/categories_helper.dart';
import 'package:book_sync/core/widgets/add_note_modal.dart';
import 'package:book_sync/core/widgets/background_paper_texture.dart';
import 'package:book_sync/core/widgets/book_loader.dart';
import 'package:book_sync/core/widgets/cozy_toast.dart';
import 'package:book_sync/core/widgets/primary_outlined_button.dart';
import 'package:book_sync/l10n/app_localizations.dart';
import 'package:book_sync/src/domain/note.dart';
import 'package:book_sync/src/features/reader_session/presentation/providers/notes_provider.dart';
import 'package:book_sync/src/features/reading_slider/presentation/providers/books_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_sync/core/theme/cozy_colors.dart';
import 'package:book_sync/core/widgets/hand_drawn_border_painter.dart';
import 'package:book_sync/src/domain/book.dart';
import 'package:go_router/go_router.dart';

class BookDetailScreen extends ConsumerStatefulWidget {
  final Book book;

  const BookDetailScreen({super.key, required this.book});

  @override
  ConsumerState<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends ConsumerState<BookDetailScreen> {
  bool _isNotesExpanded = false;
  bool _isHistoryExpanded = false;
  late bool _isFavorite = widget.book.isFavorite ?? false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notesNotifierProvider.notifier).loadNotes(widget.book.id);
    });
  }

  void _updateBookStatus(BookStatus newStatus, AppLocalizations l10n) async {
    setState(() {
      widget.book.status = newStatus;
    });
    await ref.read(bookRepositoryProvider).updateBookStatus(widget.book.id, newStatus);
    CozyToast.showSuccess(context, title: l10n.bookStatusUpdated);
  }

  String _getStatusLabel(BookStatus status, AppLocalizations l10n) {
    switch (status) {
      case BookStatus.reading:
        return l10n.statusReading;
      case BookStatus.toRead:
        return l10n.statusToRead;
      case BookStatus.dropped:
        return l10n.statusDropped;
      case BookStatus.finished:
        return l10n.statusFinished;
    }
  }

  void _showStatusActionSheet(BuildContext context, BookStatus currentStatus, AppLocalizations l10n) {
    final availableStatuses = _getAvailableStatuses(currentStatus);

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(l10n.readingStatusTitle),
        message: Text(l10n.readingStatusMessage),
        actions: availableStatuses.map((status) {
          return CupertinoActionSheetAction(
            isDefaultAction: status == BookStatus.finished || status == BookStatus.reading,
            child: Text(_getStatusLabel(status, l10n)),
            onPressed: () {
               Navigator.pop(context);
              _updateBookStatus(status, l10n);
            },
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context, CozyColors cozy, AppLocalizations l10n) {
    AddNoteModal.show(context, book: widget.book);
  }

  void _showDeleteConfirmation(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteBookDialogTitle),
        content: Text(l10n.deleteBookDialogMessage(widget.book.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref.read(bookRepositoryProvider).deleteBook(widget.book.id);

              if (!context.mounted) return;
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/');
              }
            },
            child: Text(l10n.deleteAction, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _updateBookFavorite(BuildContext context, AppLocalizations l10n) async {
    setState(() => _isFavorite = !_isFavorite);
    await ref.read(bookRepositoryProvider).updateBookFavorite(widget.book.id, _isFavorite);
    CozyToast.showSuccess(context, title: _isFavorite ? l10n.addedToFavorites : l10n.removedFromFavorites);
  }

  @override
  Widget build(BuildContext context) {
    final cozy = Theme.of(context).extension<CozyColors>()!;
    final book = widget.book;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = theme.colorScheme;
    final notesState = ref.watch(notesNotifierProvider);
    final notes = notesState.value ?? [];

    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: Stack(
        children: [
          const Positioned.fill(
            child: BackgroundPaperTexture(),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: _buildNavBar(l10n, theme, context, cozy),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBookHeader(context, cozy, colorScheme, book, l10n),
                  const SizedBox(height: 20),
                  _buildMetricsCard(context, cozy, book, l10n, theme),
                  const SizedBox(height: 16),
                  _buildEditorialDetailsCard(context, cozy, book, l10n, theme),
                  const SizedBox(height: 20),
                  if (book.description != null && book.description!.isNotEmpty) ...[
                    Text(
                      l10n.synopsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      book.description!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: cozy.inkColor?.withValues(alpha: 0.8),
                          ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  _buildActionButtons(context, cozy, l10n),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildAccordionHeader(
                          title: '${l10n.readingNotes} (${notes.length})',
                          isExpanded: _isNotesExpanded,
                          onToggle: () => setState(() => _isNotesExpanded = !_isNotesExpanded),
                        ),
                      ),
                    ],
                  ),
                  if (_isNotesExpanded) ...[
                    const SizedBox(height: 12),
                    notesState.when(
                      loading: () => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: BookLoader(),
                        ),
                      ),
                      error: (error, _) => Text(
                        'Error: $error',
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      ),
                      data: (notesList) {
                        if (notesList.isEmpty) {
                          return Text(l10n.noNotesRegistered);
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: notesList.length,
                          itemBuilder: (context, index) {
                            return _buildNoteCard(notesList[index], cozy, l10n);
                          },
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildAccordionHeader(
                          title: '${l10n.readingHistory} (${book.sessions.length})',
                          isExpanded: _isHistoryExpanded,
                          onToggle: () => setState(() => _isHistoryExpanded = !_isHistoryExpanded),
                        ),
                      )
                    ],
                  ),
                  if (_isHistoryExpanded) ...[
                    const SizedBox(height: 12),
                    book.sessions.isEmpty
                        ? Text(l10n.noSessionsRegistered)
                        : _buildTimelineHistory(book.sessions.toList(), cozy, l10n),
                  ],
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildNavBar(AppLocalizations l10n, ThemeData theme, BuildContext context, cozy) {
    return AppBar(
      centerTitle: true,
      title: Text(l10n.yourBookTitle, style: theme.textTheme.titleLarge),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(
            _isFavorite ? Icons.favorite_outlined : Icons.favorite_border_outlined, 
            color: cozy.inkColor
          ),
          onPressed: () => _updateBookFavorite(context, l10n),
        ),
        IconButton(
          icon: Icon(Icons.delete_outline_outlined, color: cozy.inkColor),
          onPressed: () => _showDeleteConfirmation(context, l10n),
        ),
      ],
    );
  }

  Row _buildBookHeader(BuildContext context, CozyColors cozy, ColorScheme colorScheme, Book book, AppLocalizations l10n) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          height: 150,
          child: CustomPaint(
            painter: HandDrawnBorderPainter(color: cozy.inkColor!.withValues(alpha: 0.4)),
            child: book.coverPath != null && book.coverPath!.isNotEmpty
              ? Image.network(
                  book.coverPath!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _buildPlaceholderCover(context),
                )
              : _buildPlaceholderCover(context),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(book.title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(
                book.author,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: cozy.textColor,
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () => _showStatusActionSheet(context, book.status, l10n),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colorScheme.onSurface.withValues(alpha: 0.8), width: 1.2),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _getStatusLabel(book.status, l10n),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: cozy.inkColor,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down, size: 18, color: cozy.inkColor),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<BookStatus> _getAvailableStatuses(BookStatus currentStatus) {
    switch (currentStatus) {
      case BookStatus.toRead:
        return [BookStatus.reading, BookStatus.dropped];
      case BookStatus.reading:
        return [BookStatus.finished, BookStatus.dropped];
      case BookStatus.finished:
      case BookStatus.dropped:
        return [BookStatus.reading, BookStatus.toRead];
    }
  }

  Row _buildActionButtons(BuildContext context, CozyColors cozy, AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: PrimaryOutlinedButton(
            onPressed: () => _showAddNoteDialog(context, cozy, l10n),
            icon: Icons.add_comment_outlined,
            label: l10n.addNote
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: PrimaryOutlinedButton(
            onPressed: () {
              context.push('/reading_session', extra: widget.book);
            },
            icon: Icons.timer_outlined,
            label: l10n.newSession,
          ),
        ),
      ],
    );
  }

  Widget _buildNoteCard(
  Note note,
  CozyColors cozy,
  AppLocalizations l10n,
) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  return Container(
    margin: const EdgeInsets.only(bottom: 8.0),
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
              '${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}',
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
}

  CustomPaint _buildEditorialDetailsCard(BuildContext context, CozyColors cozy, Book book, AppLocalizations l10n, ThemeData theme) {
    return CustomPaint(
      painter: HandDrawnBorderPainter(color: cozy.inkColor!.withValues(alpha: 0.3)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.menu_book_outlined, size: 18, color: cozy.bookmarkColor),
                const SizedBox(width: 8),
                Text(
                  l10n.editionInfo,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                Expanded(child: _buildDetailRow(l10n.publisher, book.publisher ?? '-', cozy, theme)),
                Expanded(child: _buildDetailRow('ISBN', book.isbn ?? '-', cozy, theme)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildDetailRow(l10n.language, book.language ?? '-', cozy, theme)),
                Expanded(child: _buildDetailRow(l10n.publicationDate, book.publishedDate ?? '-', cozy, theme)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Column _buildDetailRow(String label, String value, CozyColors cozy, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, 
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
            letterSpacing: 0.5,
          )
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  CustomPaint _buildMetricsCard(BuildContext context, CozyColors cozy, Book book, AppLocalizations l10n, ThemeData theme) {
    return CustomPaint(
      painter: HandDrawnBorderPainter(color: cozy.inkColor!.withValues(alpha: 0.3)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.menu_book_outlined, size: 18, color: cozy.bookmarkColor),
                const SizedBox(width: 8),
                Text(
                  l10n.progressInfo,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricItem(l10n.startDate, book.startDateText, cozy, theme),
                _buildMetricItem(l10n.day, book.readingDayText.isEmpty ? '-' : book.readingDayText, cozy, theme ),
                _buildMetricItem(l10n.remaining, book.remainingTimeText, cozy, theme),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${l10n.progress}: ${(book.progress * 100).toStringAsFixed(1)}%'),
                Text(
                  book.totalPages != null
                      ? '${book.currentPage} / ${book.totalPages} ${l10n.pagesAbbr}'
                      : '${book.currentPage} ${l10n.pagesAbbr}',
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: LinearProgressIndicator(
                value: widget.book.progress,
                minHeight: 6,
                backgroundColor: cozy.inkColor!.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              ),
            )
          ],
        ),
      ),
    );
  }

  Column _buildMetricItem(String label, String value, CozyColors cozy, ThemeData theme) {
    return Column(
      children: [
        Text(
          label, 
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
            letterSpacing: 0.5,
          )
        ),
        const SizedBox(height: 4),
        Text(
          value, 
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          )
        ),
      ],
    );
  }

  InkWell _buildAccordionHeader({
    required String title,
    required bool isExpanded,
    required VoidCallback onToggle,
  }) {
    return InkWell(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  ListView _buildTimelineHistory(List<ReadingSession> sessions, CozyColors cozy, AppLocalizations l10n) {
  final sorted = List<ReadingSession>.from(sessions)
    ..sort((a, b) => b.startTime.compareTo(a.startTime));

  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: sorted.length,
    itemBuilder: (context, index) {
      final session = sorted[index];
      final isLast = index == sorted.length - 1;
      
      // Cálculo de minutos a partir de durationSeconds
      final minutesRead = (session.durationSeconds / 60).round();

      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              child: Column(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: cozy.bookmarkColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: cozy.inkColor?.withValues(alpha: 0.2),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${session.startTime.day}/${session.startTime.month}/${session.startTime.year} - $minutesRead ${l10n.minutesAbbr}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: cozy.inkColor,
                      ),
                    ),
                    Text(
                      session.startPage > 0
                          ? l10n.pagesRange(session.startPage, session.endPage)
                          : l10n.upToPage(session.endPage),
                      style: TextStyle(
                        fontSize: 12,
                        color: cozy.inkColor?.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

  Widget _buildPlaceholderCover(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      color: colorScheme.surfaceContainerHighest,
      child: Icon(
        AppIcons.bookPlaceholder,
        size: 48,
        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
      ),
    );
  }
}