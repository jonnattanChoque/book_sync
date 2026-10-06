import 'package:book_sync/core/constants/app_constants.dart';
import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/widgets/background_paper_texture.dart';
import 'package:book_sync/l10n/app_localizations.dart';
import 'package:book_sync/src/features/calendar_export/presentation/providers/calendar_providers.dart';
import 'package:book_sync/src/features/calendar_export/presentation/widgets/calendar_reading_modal.dart';
import 'package:book_sync/src/features/calendar_export/presentation/widgets/month_calendar_export_card.dart';
import 'package:book_sync/src/features/export/presentation/export_preview_sheet.dart';
import 'package:book_sync/src/features/library/presentation/widgets/library_card_item.dart';
import 'package:book_sync/src/features/reader_session/domain/models/book_reading_summary.dart';
import 'package:book_sync/src/features/streak/presentation/providers/streak_providers.dart' hide selectedCalendarDateProvider, selectedDateReadingsProvider;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class ReadingCalendarScreen extends ConsumerWidget {
  const ReadingCalendarScreen({super.key});

  void _openExportSheet(BuildContext context, DateTime month, WidgetRef ref) async {
    final monthStats = await ref.read(monthReadingStatsProvider.future);

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ExportPreviewSheet(
        exportContent: MonthCalendarExportCard(
          month: month,
          totalPages: monthStats.totalPages,
          totalBooksRead: monthStats.totalBooksRead,
          activeDaysCount: monthStats.activeDaysCount,
        ),
        shareText: context.l10n.exportCalendarShareText(AppConstants.appName),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final selectedDate = ref.watch(selectedCalendarDateProvider);
    final focusedMonth = ref.watch(focusedCalendarMonthProvider);
    final readingsAsync = ref.watch(selectedDateReadingsProvider);
    final userStreakAsync = ref.watch(userStreakStreamProvider);
    final currentLanguage = Localizations.localeOf(context).languageCode;

    final readingDays = userStreakAsync.when(
      data: (streak) => streak?.readingDays,
      loading: () => <DateTime>[],
      error: (_, _) => <DateTime>[],
    );

    return ColoredBox(
      color: context.theme.scaffoldBackgroundColor,
      child: Stack(
        children: [
          // Textura de fondo persistente
          const Positioned.fill(
            child: BackgroundPaperTexture(),
          ),

          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: _buildNav(l10n, context, focusedMonth, ref),
            body: Column(
              children: [
                SizedBox(height: 16),
                _buildCalendar(currentLanguage, focusedMonth, selectedDate, context, ref, readingDays),
                const Divider(),
                _buildDetail(readingsAsync, selectedDate),
              ],
            )
          )
        ]
      )
    );
  }

  AppBar _buildNav(AppLocalizations l10n, BuildContext context, DateTime focusedMonth, WidgetRef ref) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: Text(l10n.calendarTitle, style: context.theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      )),
      actions: [
        IconButton(
          tooltip: l10n.exportMonthButton,
          icon: const Icon(Icons.ios_share_rounded),
          onPressed: () => _openExportSheet(context, focusedMonth, ref),
        ),
      ],
    );
  }

  TableCalendar<Object?> _buildCalendar(String currentLanguage, DateTime focusedMonth, DateTime selectedDate, BuildContext context, WidgetRef ref, List<DateTime>? readingDays) {
    return TableCalendar(
      locale: currentLanguage,
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: focusedMonth,
      selectedDayPredicate: (day) => isSameDay(selectedDate, day),
      calendarFormat: CalendarFormat.month,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextFormatter: (date, locale) {
          // 'MMMM yyyy' genera por ejemplo: "octubre 2026"
          final rawFormatted = DateFormat('MMMM yyyy', locale ?? 'es').format(date);
          
          // Capitalizar la primera letra para que quede "Octubre 2026"
          if (rawFormatted.isNotEmpty) {
            return rawFormatted[0].toUpperCase() + rawFormatted.substring(1);
          }
          return rawFormatted;
        },
        titleTextStyle: context.theme.textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.bold,
          color: context.theme.colorScheme.onSurface,
        ),
      ),
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.25),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.orange,
            width: 2,
          ),
        ),
        todayDecoration: BoxDecoration(
          color: context.theme.colorScheme.primary.withValues(alpha: 0.8),
          shape: BoxShape.circle,
        ),
      ),
      onDaySelected: (newSelectedDate, newFocusedDate) {
        ref.read(selectedCalendarDateProvider.notifier).state = newSelectedDate;
        ref.read(focusedCalendarMonthProvider.notifier).state = newFocusedDate;
      },
      onPageChanged: (newFocusedDate) {
        ref.read(focusedCalendarMonthProvider.notifier).state = newFocusedDate;
      },
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          final hasReading = readingDays?.any((d) => isSameDay(d, date));
          if (hasReading == null) return null;

          return Positioned(
            bottom: 4,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: context.theme.colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          );
        },
      ),
    );
  }

  Expanded _buildDetail(AsyncValue<List<BookReadingSummary>> readingsAsync, DateTime selectedDate) {
    return Expanded(
      child: readingsAsync.when(
        data: (summaries) => _DateDetailsView(
          selectedDate: selectedDate,
          summaries: summaries,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(err.toString())),
      ),
    );
  }
}

class _DateDetailsView extends StatelessWidget {
  final DateTime selectedDate;
  final List<BookReadingSummary> summaries;

  const _DateDetailsView({
    required this.selectedDate,
    required this.summaries,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (summaries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 48,
              color: context.theme.disabledColor,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.noReadingsOnDate,
              style: context.theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                CalendarReadingModal.show(context, selectedDate: selectedDate,);
              },
              icon: const Icon(Icons.add),
              label: Text(l10n.addManualReading),
            ),
          ],
        ),
      );
    }

    final totalPages = summaries.fold<int>(0, (sum, item) => sum + item.totalPagesRead);
    final totalSeconds = summaries.fold<int>(0, (sum, item) => sum + item.totalDurationSeconds);

    final totalDurationFormatted = BookReadingSummary(
      book: summaries.first.book,
      totalPagesRead: 0,
      totalDurationSeconds: totalSeconds,
    ).formattedDurationTwo;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.readingsForDateHeader,
                style: context.theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                l10n.dayTotalSummary('$totalPages', totalDurationFormatted),
                style: context.theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            itemCount: summaries.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = summaries[index];
              return LibraryCardItem(book: item.book, isFinished: false);
            },
          ),
        ),
      ],
    );
  }
}