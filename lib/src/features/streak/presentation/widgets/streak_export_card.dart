import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:book_sync/core/extensions/build_context_ext.dart';

class StreakExportCard extends StatelessWidget {
  final int currentStreak;
  final int bestStreak;
  final DateTime selectedDate;
  final List<DateTime> readingDays;
  final String currentLanguage;

  const StreakExportCard({
    super.key,
    required this.currentStreak,
    required this.bestStreak,
    required this.selectedDate,
    required this.readingDays,
    required this.currentLanguage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      width: 340,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: _buildContent(context, theme),
    );
  }

  Column _buildContent(BuildContext context, ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTitle(context),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _ExportMetricCard(
                title: context.l10n.currentStreakTitle,
                count: currentStreak,
                icon: Icons.local_fire_department_rounded,
                accentColor: Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ExportMetricCard(
                title: context.l10n.bestStreakTitle,
                count: bestStreak,
                icon: Icons.emoji_events_rounded,
                accentColor: context.cozy.inkColor ?? theme.colorScheme.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 2. Calendario
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: context.cozy.inkColor?.withValues(alpha: 0.1) ??
                  Colors.grey.withValues(alpha: 0.2),
            ),
          ),
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
                final rawFormatted = DateFormat('MMMM yyyy', locale ?? 'es').format(date);
                if (rawFormatted.isNotEmpty) {
                  return rawFormatted[0].toUpperCase() + rawFormatted.substring(1);
                }
                return rawFormatted;
              },
              titleTextStyle: theme.textTheme.titleSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
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
                color: theme.colorScheme.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                final hasRead = readingDays.any((d) => isSameDay(d, date));
                if (hasRead) {
                  return Positioned(
                    bottom: 4,
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
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
        const SizedBox(height: 16),
      ],
    );
  }

  Row _buildTitle(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6.0),
          child: Image.asset(
            'assets/images/app_logo.png',
            width: 24,
            height: 24,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${context.l10n.streakTitle.toUpperCase()} ${DateTime.now().year}',
          style: context.theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _ExportMetricCard extends StatelessWidget {
  final String title;
  final int count;
  final IconData icon;
  final Color accentColor;

  const _ExportMetricCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: accentColor, size: 24),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$count',
                  maxLines: 2,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: context.cozy.inkColor?.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
