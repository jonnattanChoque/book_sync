// lib/src/features/reading/presentation/widgets/finish_reading_modal.dart

import 'package:book_sync/core/theme/cozy_colors.dart';
import 'package:book_sync/core/widgets/primary_outlined_button.dart';
import 'package:book_sync/l10n/app_localizations.dart';
import 'package:book_sync/src/domain/book.dart';
import 'package:book_sync/src/features/reader_session/presentation/summary_screen.dart';
import 'package:book_sync/src/features/reading_slider/presentation/providers/books_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FinishReadingModal extends ConsumerStatefulWidget {
  final Book book;
  final Duration elapsedDuration;

  const FinishReadingModal({
    super.key,
    required this.book,
    required this.elapsedDuration,
  });

  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    required Book book,
    required Duration elapsedDuration,
  }) {
    final cozy = Theme.of(context).extension<CozyColors>()!;
    
    return showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor.withValues(alpha: 0.85),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      barrierColor: cozy.inkColor!.withValues(alpha: 0.2),
      showDragHandle: true,
      isDismissible: true,
      isScrollControlled: true,
      sheetAnimationStyle: AnimationStyle(curve: Curves.bounceOut),
      builder: (context) => FinishReadingModal(book: book, elapsedDuration: elapsedDuration),
    );
  }

  @override
  ConsumerState<FinishReadingModal> createState() => _FinishReadingModalState();
}

class _FinishReadingModalState extends ConsumerState<FinishReadingModal> {
  late TextEditingController _endPageController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _endPageController = TextEditingController(
      text: widget.book.currentPage > 0 ? widget.book.currentPage.toString() : '',
    );
  }

  @override
  void dispose() {
    _endPageController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration, AppLocalizations l10n) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    if (minutes > 0) {
      return '$minutes ${l10n.minutesShort} $seconds ${l10n.secondsShort}';
    }
    return '$seconds ${l10n.secondsShort}';
  }

  void _onSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final endPage = int.parse(_endPageController.text.trim());
      final repository = ref.read(bookRepositoryProvider);

      final result = await repository.saveReadingSession(
        bookId: widget.book.id,
        startPage: widget.book.currentPage,
        endPage: endPage,
        duration: widget.elapsedDuration,
      );

      if (result != null && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => SessionSummaryPage(
              book: result.book,
              session: result.session,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cozy = theme.extension<CozyColors>()!;
    final l10n = AppLocalizations.of(context)!;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: bottomInset + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildTitle(l10n, context),
            const SizedBox(height: 12),

            // Time summary
            _buildTimeInfo(l10n),
            const SizedBox(height: 20),

            // End page input
            _buildTextFieldPage(l10n, theme, colorScheme, cozy),
            const SizedBox(height: 24),

            // Save button
            _buildButton(l10n, context)
          ],
        ),
      ),
    );
  }

  Row _buildTitle(AppLocalizations l10n, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          l10n.finishReadingTitle,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Container _buildTimeInfo(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer_outlined, color: Colors.blueAccent),
          const SizedBox(width: 10),
          Text(
            '${l10n.timeReadLabel}: ${_formatDuration(widget.elapsedDuration, l10n)}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Column _buildTextFieldPage(AppLocalizations l10n, ThemeData theme, ColorScheme colorScheme, CozyColors cozy) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Encabezado/Label superior idéntico al modal de notas
        Text(
          l10n.whatPageDidYouReach,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),

        // Input con el estilo visual unificado
        TextFormField(
          controller: _endPageController,
          keyboardType: TextInputType.number,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: l10n.currentPageHint(widget.book.currentPage),
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            filled: true,
            fillColor: theme.cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: cozy.inkColor!.withValues(alpha: 0.5),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: cozy.inkColor!.withValues(alpha: 0.8),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: colorScheme.error,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return l10n.validationEnterEndPage;
            }
            final page = int.tryParse(value.trim());
            if (page == null || page < 0) {
              return l10n.validationInvalidNumber;
            }
            if (page <= widget.book.currentPage) {
              return l10n.validationPageLowerThanCurrent(widget.book.currentPage);
            }
            final totalPages = widget.book.totalPages;

            if (totalPages != null && totalPages > 0 && page > totalPages) {
              return l10n.validationPageExceedsTotal(totalPages);
            }

            return null;
          },
        ),
      ],
    );
  }

  PrimaryOutlinedButton _buildButton(AppLocalizations l10n, BuildContext context) {
    return PrimaryOutlinedButton(
      onPressed: _onSubmit,
      label: l10n.saveSessionButton,
      icon: Icons.check_circle_outline,
    );
  }
}