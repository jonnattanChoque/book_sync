// ignore_for_file: use_build_context_synchronously

import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/widgets/primary_outlined_button.dart';
import 'package:book_sync/src/domain/book.dart';
import 'package:book_sync/src/features/reading_slider/presentation/providers/books_provider.dart';
import 'package:book_sync/src/features/streak/presentation/providers/streak_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarReadingModal extends ConsumerStatefulWidget {
  final DateTime selectedDate;

  const CalendarReadingModal({
    super.key,
    required this.selectedDate,
  });

  static Future<void> show(
    BuildContext context, {
    required DateTime selectedDate,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: context.theme.cardColor.withValues(alpha: 0.95),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      barrierColor: context.cozy.inkColor!.withValues(alpha: 0.3),
      showDragHandle: true,
      isDismissible: true,
      isScrollControlled: true,
      sheetAnimationStyle: AnimationStyle(curve: Curves.easeOutBack),
      builder: (context) => CalendarReadingModal(selectedDate: selectedDate),
    );
  }

  @override
  ConsumerState<CalendarReadingModal> createState() => _CalendarReadingModalState();
}

class _CalendarReadingModalState extends ConsumerState<CalendarReadingModal> {
  late TextEditingController _endPageController;
  final _formKey = GlobalKey<FormState>();

  int _selectedHours = 0;
  int _selectedMinutes = 15;
  int _selectedSeconds = 0;

  Book? _selectedBook;

  @override
  void initState() {
    super.initState();
    _endPageController = TextEditingController();
  }

  @override
  void dispose() {
    _endPageController.dispose();
    super.dispose();
  }

  Duration get _totalDuration => Duration(
    hours: _selectedHours,
    minutes: _selectedMinutes,
    seconds: _selectedSeconds,
  );

  void _onSubmit() async {
    if (_selectedBook == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.selectBookWarning)),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      final endPage = int.parse(_endPageController.text.trim());
      final repository = ref.read(bookRepositoryProvider);

      final result = await repository.saveReadingSession(
        bookId: _selectedBook!.id,
        startPage: _selectedBook!.currentPage,
        endPage: endPage,
        duration: _totalDuration,
        startTime: widget.selectedDate,
      );

      if (result != null && mounted) {
        final registerStreak = ref.read(registerReadingDayProvider);
        await registerStreak(widget.selectedDate);

        ref.invalidate(userStreakStreamProvider); 
        ref.invalidate(selectedDateReadingsProvider);
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final readingBooksAsync = ref.watch(currentlyReadingProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 10,
          bottom: bottomInset + 20,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(),
                const SizedBox(height: 16),

                // 1. Selector de Libro
                Text(
                  context.l10n.selectBookLabel,
                  style: context.theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildBookSelector(readingBooksAsync),
                const SizedBox(height: 20),

                // 2. Selector de Tiempo
                Text(
                  context.l10n.readingTimeLabel,
                  style: context.theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildTimePicker(),
                const SizedBox(height: 20),

                // 3. Campo de Entrada para la Página
                if (_selectedBook != null) ...[
                  _buildTextFieldPage(),
                  const SizedBox(height: 24),
                ],

                // 4. Botón Guardar
                _buildButton(),
              ],
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
          context.l10n.registerReadingTitle,
          style: context.theme.textTheme.titleLarge?.copyWith(
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

  Widget _buildBookSelector(AsyncValue<List<Book>> readingBooksAsync) {
    return readingBooksAsync.when(
      data: (books) {
        if (books.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.theme.cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(context.l10n.noBooksCurrentlyReading),
            ),
          );
        }

        if (_selectedBook == null && books.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _selectedBook = books.first;
              });
            }
          });
        }

        return SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final book = books[index];
              final isSelected = _selectedBook?.id == book.id;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedBook = book;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 220,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected
                    ? context.colorScheme.primaryContainer.withValues(alpha: 0.4)
                    : context.theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                      ? context.colorScheme.primary
                      : context.cozy.inkColor!.withValues(alpha: 0.1),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 45,
                        height: 65,
                        decoration: BoxDecoration(
                          color: context.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: book.coverPath != null && book.coverPath!.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(book.coverPath!, fit: BoxFit.cover),
                          )
                        : const Icon(Icons.book, size: 24),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              book.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: context.theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              context.l10n.currentPageHint(book.currentPage, book.totalPages ?? 0),
                              style: context.theme.textTheme.bodySmall?.copyWith(
                                color: context.colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const SizedBox.shrink(),
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
    required ValueChanged<int> onChanged,
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

  Column _buildTextFieldPage() {
    final book = _selectedBook!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          controller: _endPageController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _onSubmit(),
          style: context.theme.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: context.l10n.currentPageHint(book.currentPage, book.totalPages ?? 0),
            filled: true,
            fillColor: context.theme.cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: context.cozy.inkColor!.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: context.colorScheme.primary,
                width: 2,
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
            if (page <= book.currentPage) {
              return context.l10n.validationPageLowerThanCurrent(book.currentPage);
            }
            final totalPages = book.totalPages;
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