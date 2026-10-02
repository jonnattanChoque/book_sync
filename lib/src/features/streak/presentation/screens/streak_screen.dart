// lib/src/features/streak/presentation/screens/streak_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:book_sync/core/constants/app_icons.dart';
import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/widgets/background_paper_texture.dart';
import 'package:book_sync/core/widgets/book_loader.dart';
import 'package:book_sync/src/features/reader_session/domain/models/book_reading_summary.dart';
import 'package:book_sync/src/features/streak/presentation/providers/streak_providers.dart';

class StreakScreen extends ConsumerWidget {
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakAsync = ref.watch(userStreakStreamProvider);
    final selectedDate = ref.watch(selectedCalendarDateProvider);
    final readingsAsync = ref.watch(selectedDateReadingsProvider);

    return ColoredBox(
      color: context.theme.scaffoldBackgroundColor,
      child: Stack(
        children: [
          const Positioned.fill(
            child: BackgroundPaperTexture(),
          ),

          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: _buildNav(context),
            body: streakAsync.when(
              loading: () => const Center(child: BookLoader()),
              error: (_, _) => const SizedBox.shrink(),
              data: (userStreak) {
                final currentStreak = userStreak?.currentStreak ?? 0;
                final bestStreak = userStreak?.bestStreak ?? 0;
                final readingDays = userStreak?.readingDays ?? [];
                final currentLanguage = Localizations.localeOf(context).languageCode;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // --- 3.3.1 y 3.3.2: Tarjetas Racha Actual y Mejor Racha ---
                      _buildMetrics(context, currentStreak, bestStreak),
                      const SizedBox(height: 24),
                      // --- 3.3.3: Calendario de Lecturas ---
                      _buildCalendar(context, currentLanguage, selectedDate, ref, readingDays),
                      const SizedBox(height: 24),
                      // --- Detalle de libros leídos en la fecha seleccionada ---
                      readingsAsync.when(
                        data: (summaries) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Fila de encabezado con badge de cantidad
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    context.l10n.booksReadOnDate(summaries.length),
                                    style: context.theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: context.theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  
                                ],
                              ),
                              const SizedBox(height: 12),

                              if (summaries.isEmpty)
                                Container(
                                  padding: const EdgeInsets.all(20.0),
                                  decoration: BoxDecoration(
                                    color: context.theme.cardColor.withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      context.l10n.noReadingOnDate,
                                      style: context.theme.textTheme.bodyMedium?.copyWith(
                                        color: context.cozy.inkColor?.withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ),
                                )
                              else
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: summaries.length,
                                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                                  itemBuilder: (context, index) {
                                    return _BookSummaryTile(summary: summaries[index]);
                                  },
                                ),
                            ],
                          );
                        },
                        loading: () => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: BookLoader()),
                        ),
                        error: (_, _) => const SizedBox.shrink(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildNav(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          AppIcons.back,
          color: context.theme.colorScheme.onSurface,
        ),
        onPressed: () {
          FocusScope.of(context).unfocus();
          Navigator.of(context).pop();
        },
      ),
      title: Text(
        context.l10n.streakTitle,
        style: context.theme.textTheme.titleLarge?.copyWith(
          color: context.theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Row _buildMetrics(BuildContext context, int currentStreak, int bestStreak) {
    return Row(
      children: [
        Expanded(
          child: _StreakMetricCard(
            title: context.l10n.currentStreakTitle,
            count: currentStreak,
            icon: Icons.local_fire_department_rounded,
            accentColor: Colors.orange,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StreakMetricCard(
            title: context.l10n.bestStreakTitle,
            count: bestStreak,
            icon: Icons.emoji_events_rounded,
            accentColor: context.cozy.inkColor ?? context.theme.colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  Card _buildCalendar(BuildContext context, String currentLanguage, DateTime selectedDate, WidgetRef ref, List<DateTime> readingDays) {
    return Card(
      elevation: 0,
      color: context.theme.cardColor.withValues(alpha: 0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: context.cozy.inkColor?.withValues(alpha: 0.1) ?? Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: TableCalendar(
          locale: currentLanguage,
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: selectedDate,
          currentDay: DateTime.now(),
          selectedDayPredicate: (day) => isSameDay(selectedDate, day),
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
              color: context.theme.colorScheme.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
          ),
          onDaySelected: (selected, focused) {
            ref.read(selectedCalendarDateProvider.notifier).state = DateTime(
              selected.year,
              selected.month,
              selected.day,
            );
          },
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              final hasRead = readingDays.any((d) => isSameDay(d, date));
              if (hasRead) {
                return Positioned(
                  bottom: 6,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }
              return null;
            },
          ),
        ),
      ),
    );
  }
}

class _StreakMetricCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color accentColor;

  const _StreakMetricCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: context.theme.cardColor.withValues(alpha: 0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: context.cozy.inkColor?.withValues(alpha: 0.1) ?? Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: accentColor),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.theme.textTheme.bodySmall?.copyWith(
                color: context.cozy.inkColor?.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              context.l10n.streakDaysCount(count),
              style: context.theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookSummaryTile extends StatelessWidget {
  final BookReadingSummary summary;

  const _BookSummaryTile({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: context.theme.cardColor.withValues(alpha: 0.8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: context.cozy.inkColor?.withValues(alpha: 0.1) ?? Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), 
        leading: Container(
          width: 40,
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: context.theme.colorScheme.primary.withValues(alpha: 0.1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: summary.book.coverPath != null && summary.book.coverPath!.isNotEmpty
                ? Image.network(
                    summary.book.coverPath!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Icon(Icons.book),
                  )
                : const Icon(Icons.book),
          ),
        ),
        title: Text(
          summary.book.title,
          style: context.theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${context.l10n.pagesReadCount(summary.totalPagesRead)} • ${summary.durationFormatted}',
          style: context.theme.textTheme.bodySmall?.copyWith(
            color: context.cozy.inkColor?.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }
}