// ignore_for_file: use_build_context_synchronously

import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/widgets/primary_outlined_button.dart';
import 'package:book_sync/src/domain/book.dart';
import 'package:book_sync/src/features/reading_slider/presentation/providers/books_provider.dart';
import 'package:book_sync/src/features/streak/presentation/providers/streak_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/cupertino.dart';

class FinishReadingModal extends ConsumerStatefulWidget {
  final Book book;
  final Duration? elapsedDuration;

  const FinishReadingModal({
    super.key,
    required this.book,
    this.elapsedDuration,
  });

  static Future<Map<String, dynamic>?> show(
    BuildContext context, {
    required Book book,
    Duration? elapsedDuration,
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

  late DateTime _selectedDate;

  int _selectedHours = 0;
  int _selectedMinutes = 15;
  int _selectedSeconds = 0;

  @override
  void initState() {
    super.initState();
    _endPageController = TextEditingController(
      text: '',
    );
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _endPageController.dispose();
    super.dispose();
  }

  Duration get _effectiveDuration {
    if (widget.elapsedDuration != null) {
      return widget.elapsedDuration!;
    }
    return Duration(
      hours: _selectedHours,
      minutes: _selectedMinutes,
      seconds: _selectedSeconds,
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    if (minutes > 0) {
      return '$minutes ${context.l10n.minutesShort} $seconds ${context.l10n.secondsShort}';
    }
    return '$seconds ${context.l10n.secondsShort}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(), // No permitir fechas futuras
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _onSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final now = DateTime.now();
      final endPage = int.parse(_endPageController.text.trim());
      final repository = ref.read(bookRepositoryProvider);
      final sessionTime = widget.elapsedDuration == null
        ? DateTime(
            _selectedDate.year,
            _selectedDate.month,
            _selectedDate.day,
            now.hour,
            now.minute,
            now.second,
          )
        : now;

      final result = await repository.saveReadingSession(
        bookId: widget.book.id,
        startPage: widget.book.currentPage,
        endPage: endPage,
        duration: _effectiveDuration,
        startTime: sessionTime,
      );

      if (result != null && mounted) {
        final registerStreak = ref.read(registerReadingDayProvider);
        await registerStreak();

        ref.invalidate(userStreakStreamProvider);
        ref.invalidate(selectedDateReadingsProvider);
        context.pushReplacement('/summary', extra: {'book': result.book, 'session': result.session});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isManual = widget.elapsedDuration == null;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
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
          
                  if (isManual) ...[
                    Text(
                      context.l10n.selectDateLabel,
                      style: context.theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildDateSelector(),
                    const SizedBox(height: 20),
                  ],
          
                  if (!isManual) ...[
                    _buildTimeInfo(),
                  ] else ...[
                    Text(
                      context.l10n.readingTimeLabel,
                      style: context.theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildTimePicker(),
                  ],
                  const SizedBox(height: 20),
          
                  // End page input
                  _buildTextFieldPage(isManual),
                  const SizedBox(height: 24),
          
                  // Save button
                  _buildButton()
                ],
              ),
            ),
          ),
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

  Widget _buildDateSelector() {
    final isToday = DateUtils.isSameDay(_selectedDate, DateTime.now());
    final dateString = isToday
    ? context.l10n.todayLabel
    : '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';

    return InkWell(
      onTap: _pickDate,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: context.cozy.inkColor!.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  size: 18,
                  color: context.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  dateString,
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
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
            '${context.l10n.timeReadLabel}: ${_formatDuration(widget.elapsedDuration!)}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker() {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.cozy.inkColor!.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPickerColumn(
            maxValue: 23,
            initialValue: _selectedHours,
            label: 'h',
            onChanged: (val) => setState(() => _selectedHours = val),
          ),
          Text(':', style: context.theme.textTheme.titleLarge),
          _buildPickerColumn(
            maxValue: 59,
            initialValue: _selectedMinutes,
            label: context.l10n.minutesShort,
            onChanged: (val) => setState(() => _selectedMinutes = val),
          ),
          Text(':', style: context.theme.textTheme.titleLarge),
          _buildPickerColumn(
            maxValue: 59,
            initialValue: _selectedSeconds,
            label: context.l10n.secondsShort,
            onChanged: (val) => setState(() => _selectedSeconds = val),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerColumn({
    required int maxValue,
    required int initialValue,
    required String label,
    required ValueChanged<int> onChanged
  }) {
    return SizedBox(
      width: 70,
      child: CupertinoPicker(
        itemExtent: 36,
        scrollController: FixedExtentScrollController(initialItem: initialValue),
        onSelectedItemChanged: onChanged,
        children: List.generate(maxValue + 1, (index) {
          return Center(
            child: Text(
              '${index.toString().padLeft(2, '0')} $label',
              style: context.theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }),
      ),
    );
  }

  Column _buildTextFieldPage(bool isManual) {
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
          autofocus: !isManual,
          controller: _endPageController,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _onSubmit(),
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