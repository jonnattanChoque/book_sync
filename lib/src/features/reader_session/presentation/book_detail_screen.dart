// ignore_for_file: use_build_context_synchronously

import 'package:book_sync/core/constants/app_icons.dart';
import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/theme/app_colors.dart';
import 'package:book_sync/core/utils/categories_helper.dart';
import 'package:book_sync/core/widgets/add_note_modal.dart';
import 'package:book_sync/core/widgets/background_paper_texture.dart';
import 'package:book_sync/core/widgets/book_loader.dart';
import 'package:book_sync/core/widgets/book_rating_modal.dart';
import 'package:book_sync/core/widgets/cozy_toast.dart';
import 'package:book_sync/core/widgets/primary_outlined_button.dart';
import 'package:book_sync/src/domain/note.dart';
import 'package:book_sync/src/features/reader_session/presentation/providers/notes_provider.dart';
import 'package:book_sync/src/features/reading_slider/presentation/providers/books_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  bool _isConclusionsExpanded = false;
  late bool _isFavorite = widget.book.isFavorite ?? false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notesNotifierProvider.notifier).loadNotes(widget.book.id);
    });
  }

  void _updateBookStatus(BookStatus newStatus) async {
    setState(() {
      widget.book.status = newStatus;
    });
    await ref.read(bookRepositoryProvider).updateBookStatus(widget.book.id, newStatus);
    CozyToast.showSuccess(context, title: context.l10n.bookStatusUpdated);
  }

  String _getStatusLabel(BookStatus status) {
    switch (status) {
      case BookStatus.reading:
        return context.l10n.statusReading;
      case BookStatus.toRead:
        return context.l10n.statusToRead;
      case BookStatus.dropped:
        return context.l10n.statusDropped;
      case BookStatus.finished:
        return context.l10n.statusFinished;
    }
  }

  void _showStatusActionSheet(BookStatus currentStatus) {
    final availableStatuses = _getAvailableStatuses(currentStatus);

    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(context.l10n.readingStatusTitle),
        message: Text(context.l10n.readingStatusMessage),
        actions: availableStatuses.map((status) {
          return CupertinoActionSheetAction(
            isDefaultAction: status == BookStatus.finished || status == BookStatus.reading,
            child: Text(_getStatusLabel(status)),
            onPressed: () {
              Navigator.pop(context);
              _updateBookStatus(status);
            },
          );
        }).toList(),
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
      ),
    );
  }

  void _showAddNoteDialog() {
    AddNoteModal.show(context, book: widget.book);
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.deleteBookDialogTitle),
        content: Text(context.l10n.deleteBookDialogMessage(widget.book.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.l10n.cancel),
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
            child: Text(context.l10n.deleteAction, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _updateBookFavorite(BuildContext context) async {
    setState(() => _isFavorite = !_isFavorite);
    await ref.read(bookRepositoryProvider).updateBookFavorite(widget.book.id, _isFavorite);
    CozyToast.showSuccess(context, title: _isFavorite ? context.l10n.addedToFavorites : context.l10n.removedFromFavorites);
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    final notesState = ref.watch(notesNotifierProvider);
    final notes = notesState.value ?? [];

    return ColoredBox(
      color: context.theme.scaffoldBackgroundColor,
      child: Stack(
        children: [
          const Positioned.fill(
            child: BackgroundPaperTexture(),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: _buildNavBar(),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBookHeader(book),
                  const SizedBox(height: 20),
                  _buildMetricsCard(book),
                  const SizedBox(height: 16),
                  _buildEditorialDetailsCard(book),
                  const SizedBox(height: 20),
                  if (book.description != null && book.description!.isNotEmpty) ...[
                    Text(
                      context.l10n.synopsis,
                      style: context.theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      book.description!,
                      style: context.theme.textTheme.bodyMedium?.copyWith(
                        color: context.cozy.inkColor?.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                  _buildActionButtons(),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: _buildAccordionHeader(
                          title: '${context.l10n.readingNotes} (${notes.length})',
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
                        style: TextStyle(color: context.theme.colorScheme.error),
                      ),
                      data: (notesList) {
                        if (notesList.isEmpty) {
                          return Text(context.l10n.noNotesRegistered);
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: notesList.length,
                          itemBuilder: (context, index) {
                            return _buildNoteCard(notesList[index]);
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
                          title: '${context.l10n.readingHistory} (${book.sessions.length})',
                          isExpanded: _isHistoryExpanded,
                          onToggle: () => setState(() => _isHistoryExpanded = !_isHistoryExpanded),
                        ),
                      )
                    ],
                  ),
                  if (_isHistoryExpanded) ...[
                    const SizedBox(height: 12),
                    book.sessions.isEmpty
                      ? Text(context.l10n.noSessionsRegistered)
                      : _buildTimelineHistory(book.sessions.toList()),
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

  AppBar _buildNavBar() {
    return AppBar(
      centerTitle: true,
      title: Text(context.l10n.yourBookTitle, style: context.theme.textTheme.titleLarge),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          icon: Icon(
            _isFavorite ? Icons.favorite_outlined : Icons.favorite_border_outlined, 
            color: context.cozy.inkColor
          ),
          onPressed: () => _updateBookFavorite(context),
        ),
        IconButton(
          icon: Icon(Icons.delete_outline_outlined, color: context.cozy.inkColor),
          onPressed: () => _showDeleteConfirmation(),
        ),
      ],
    );
  }

  Row _buildBookHeader(Book book) {
    final bool isFinished = book.status == BookStatus.finished && book.progress >= 1.0;
    final bool hasRating = book.rating != null && book.rating! > 0;
    final bool hasConclusions = book.conclusions != null && book.conclusions!.trim().isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          height: 150,
          child: CustomPaint(
            painter: HandDrawnBorderPainter(color: context.cozy.inkColor!.withValues(alpha: 0.4)),
            child: book.coverPath != null && book.coverPath!.isNotEmpty
            ? Image.network(
                book.coverPath!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildPlaceholderCover(),
              )
            : _buildPlaceholderCover(),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(book.title, style: context.theme.textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(
                book.author,
                style: context.theme.textTheme.titleMedium?.copyWith(
                  color: context.cozy.textColor,
                ),
              ),
              const SizedBox(height: 12),
              if (!isFinished)
                InkWell(
                  onTap: () => _showStatusActionSheet(book.status),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: context.colorScheme.onSurface.withValues(alpha: 0.8), width: 1.2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _getStatusLabel(book.status),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: context.cozy.inkColor,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.keyboard_arrow_down, size: 18, color: context.cozy.inkColor),
                      ],
                    ),
                  ),
                )
              else ...[
                if (hasRating || hasConclusions) ...[
                  if (hasRating)
                    Row(
                      children: List.generate(5, (index) {
                        final starValue = index + 1.0;
                        return Icon(
                          (book.rating ?? 0) >= starValue
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          color: Colors.amber,
                          size: 20,
                        );
                      }),
                    ),
                  if (hasRating && hasConclusions) const SizedBox(height: 6),
                  if (hasConclusions)
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isConclusionsExpanded = !_isConclusionsExpanded;
                        });
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            book.conclusions!,
                            maxLines: _isConclusionsExpanded ? null : 1,
                            overflow: _isConclusionsExpanded
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                            style: context.theme.textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: context.cozy.inkColor?.withValues(alpha: 0.8),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _isConclusionsExpanded ? context.l10n.showLess : context.l10n.showMore,
                            style: context.theme.textTheme.labelSmall?.copyWith(
                              color: context.theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ] else
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.star_outline_rounded, color: Colors.amber, size: 18),
                      label: Text(context.l10n.rateThisBookAction),
                      onPressed: () async {
                        final updated = await BookRatingModal.show(context, book);
                        if (updated == true && mounted) {
                          setState(() {
                            widget.book.rating = book.rating;
                            widget.book.conclusions = book.conclusions;
                          });
                        }
                      },
                    ),
                  ),
              ],
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

  Row _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: PrimaryOutlinedButton(
            onPressed: () => _showAddNoteDialog(),
            icon: Icons.add_comment_outlined,
            label: context.l10n.addNote
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: PrimaryOutlinedButton(
            onPressed: () {
              context.push('/reading_session', extra: widget.book);
            },
            icon: Icons.timer_outlined,
            label: context.l10n.newSession,
          ),
        ),
      ],
    );
  }

  Widget _buildNoteCard(Note note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.theme.cardColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: context.cozy.inkColor!.withValues(alpha: 0.2),
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
                      context.l10n.pageOption(note.page),
                      style: context.theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.oliveGreen,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    NoteCategoryHelper.getLabelById(note.category, context.l10n),
                    style: context.theme.textTheme.labelSmall?.copyWith(
                      color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                '${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year}',
                style: context.theme.textTheme.labelSmall?.copyWith(
                  color: context.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            note.content,
            style: context.theme.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  CustomPaint _buildEditorialDetailsCard(Book book) {
    return CustomPaint(
      painter: HandDrawnBorderPainter(color: context.cozy.inkColor!.withValues(alpha: 0.3)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.menu_book_outlined, size: 18, color: context.cozy.bookmarkColor),
                const SizedBox(width: 8),
                Text(
                  context.l10n.editionInfo,
                  style: context.theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              children: [
                Expanded(child: _buildDetailRow(context.l10n.publisher, book.publisher ?? '-')),
                Expanded(child: _buildDetailRow(context.l10n.isbn, book.isbn ?? '-')),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildDetailRow(context.l10n.language, book.language ?? '-')),
                Expanded(child: _buildDetailRow(context.l10n.publicationDate, book.publishedDate ?? '-')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Column _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label, 
          style: context.theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.theme.colorScheme.primary,
            letterSpacing: 0.5,
          )
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: context.theme.textTheme.bodyMedium?.copyWith(
            color: context.theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  CustomPaint _buildMetricsCard(Book book) {
    return CustomPaint(
      painter: HandDrawnBorderPainter(color: context.cozy.inkColor!.withValues(alpha: 0.3)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.menu_book_outlined, size: 18, color: context.cozy.bookmarkColor),
                const SizedBox(width: 8),
                Text(
                  context.l10n.progressInfo,
                  style: context.theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricItem(context.l10n.startDate, book.startDateText),
                _buildMetricItem(context.l10n.day, book.readingDayText.isEmpty ? '-' : book.readingDayText),
                _buildMetricItem(context.l10n.remaining, book.remainingTimeText),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${context.l10n.progress}: ${(book.progress * 100).toStringAsFixed(1)}%'),
                Text(
                  book.totalPages != null
                      ? '${book.currentPage} / ${book.totalPages} ${context.l10n.pagesAbbr}'
                      : '${book.currentPage} ${context.l10n.pagesAbbr}',
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: LinearProgressIndicator(
                value: widget.book.progress,
                minHeight: 6,
                backgroundColor: context.cozy.inkColor!.withValues(alpha: 0.1),
                valueColor: AlwaysStoppedAnimation<Color>(context.theme.colorScheme.primary),
              ),
            )
          ],
        ),
      ),
    );
  }

  Column _buildMetricItem(String label, String value) {
    return Column(
      children: [
        Text(
          label, 
          style: context.theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.theme.colorScheme.primary,
            letterSpacing: 0.5,
          )
        ),
        const SizedBox(height: 4),
        Text(
          value, 
          style: context.theme.textTheme.bodyMedium?.copyWith(
            color: context.theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
            Text(title, style: context.theme.textTheme.titleMedium),
            Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  ListView _buildTimelineHistory(List<ReadingSession> sessions) {
    final sorted = List<ReadingSession>.from(sessions)
      ..sort((a, b) => b.startTime.compareTo(a.startTime));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sorted.length,
      itemBuilder: (context, index) {
        final session = sorted[index];
        final isLast = index == sorted.length - 1;
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
                        color: context.cozy.bookmarkColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: context.cozy.inkColor?.withValues(alpha: 0.2),
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
                        '${session.startTime.day}/${session.startTime.month}/${session.startTime.year} - $minutesRead ${context.l10n.minutesAbbr}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: context.cozy.inkColor,
                        ),
                      ),
                      Text(
                        session.startPage > 0
                        ? context.l10n.pagesRange(session.startPage, session.endPage)
                        : context.l10n.upToPage(session.endPage),
                        style: TextStyle(
                          fontSize: 12,
                          color: context.cozy.inkColor?.withValues(alpha: 0.7),
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

  Widget _buildPlaceholderCover() {
    return Container(
      color: context.colorScheme.surfaceContainerHighest,
      child: Icon(
        AppIcons.bookPlaceholder,
        size: 48,
        color: context.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
      ),
    );
  }
}