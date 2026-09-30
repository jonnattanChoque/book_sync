// lib/src/features/reading/presentation/widgets/finish_reading_modal.dart

// ignore_for_file: use_build_context_synchronously

import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/widgets/primary_outlined_button.dart';
import 'package:book_sync/src/domain/book.dart';
import 'package:book_sync/src/features/reading_slider/presentation/providers/books_provider.dart';
import 'package:book_sync/src/features/streak/presentation/providers/streak_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
    
    return showModalBottomSheet(
      context: context,
      backgroundColor: context.theme.cardColor.withValues(alpha: 0.85),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      barrierColor: context.cozy.inkColor!.withValues(alpha: 0.2),
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
      text: '',
    );
  }

  @override
  void dispose() {
    _endPageController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    if (minutes > 0) {
      return '$minutes ${context.l10n.minutesShort} $seconds ${context.l10n.secondsShort}';
    }
    return '$seconds ${context.l10n.secondsShort}';
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
        final registerStreak = ref.read(registerReadingDayProvider);
        await registerStreak();
        context.pushReplacement('/summary', extra: {'book': result.book, 'session': result.session});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            _buildTitle(),
            const SizedBox(height: 12),

            // Time summary
            _buildTimeInfo(),
            const SizedBox(height: 20),

            // End page input
            _buildTextFieldPage(),
            const SizedBox(height: 24),

            // Save button
            _buildButton()
          ],
        ),
      ),
    );
  }

  Row _buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.l10n.finishReadingTitle,
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

  Container _buildTimeInfo() {
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
            '${context.l10n.timeReadLabel}: ${_formatDuration(widget.elapsedDuration)}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Column _buildTextFieldPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.l10n.whatPageDidYouReach,
          style: context.theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: context.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          autofocus: true,
          controller: _endPageController,
          keyboardType: TextInputType.number,
          style: context.theme.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: context.l10n.currentPageHint(widget.book.currentPage, widget.book.totalPages ?? 0),
            hintStyle: context.theme.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            filled: true,
            fillColor: context.theme.cardColor,
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
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: context.colorScheme.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: context.colorScheme.error,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return context.l10n.validationEnterEndPage;
            }
            final page = int.tryParse(value.trim());
            if (page == null || page < 0) {
              return context.l10n.validationInvalidNumber;
            }
            if (page <= widget.book.currentPage) {
              return context.l10n.validationPageLowerThanCurrent(widget.book.currentPage);
            }
            final totalPages = widget.book.totalPages;

            if (totalPages != null && totalPages > 0 && page > totalPages) {
              return context.l10n.validationPageExceedsTotal(totalPages);
            }

            return null;
          },
        ),
      ],
    );
  }

  PrimaryOutlinedButton _buildButton() {
    return PrimaryOutlinedButton(
      onPressed: _onSubmit,
      label: context.l10n.saveSessionButton,
      icon: Icons.check_circle_outline,
    );
  }
}