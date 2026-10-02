import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/widgets/custom_info_card.dart';
import 'package:flutter/material.dart';

class StatsSummaryGrid extends StatelessWidget {
  final double monthlyBooksAvg;
  final double pagesPerHour;
  final int totalMinutesReadYear;
  final int totalPagesReadYear;
  final int finishedBooksYear;
  final int annualGoal;
  final double weeklyHoursGoal;
  final double weeklyHoursRead;

  const StatsSummaryGrid({
    super.key,
    required this.monthlyBooksAvg,
    required this.pagesPerHour,
    required this.totalMinutesReadYear,
    required this.totalPagesReadYear, 
    required this.finishedBooksYear, 
    required this.annualGoal,
    required this.weeklyHoursGoal,
    this.weeklyHoursRead = 0.0,
  });

  @override
  Widget build(BuildContext context) {

    final double goalProgress = annualGoal > 0 
      ? (finishedBooksYear / annualGoal).clamp(0.0, 1.0) 
      : 0.0;

    final weeklyGoalProgress = (weeklyHoursGoal > 0)
      ? (weeklyHoursRead / weeklyHoursGoal).clamp(0.0, 1.0)
      : 0.0;

    // Formateo para las horas semanales
    final weeklyReadText = (weeklyHoursRead.truncateToDouble() == weeklyHoursRead)
      ? weeklyHoursRead.toInt().toString()
      : weeklyHoursRead.toStringAsFixed(1);

  // Formateo para la meta de horas
    final weeklyGoalText = (weeklyHoursGoal.truncateToDouble() == weeklyHoursGoal)
      ? weeklyHoursGoal.toInt().toString()
      : weeklyHoursGoal.toStringAsFixed(1);

    final hours = totalMinutesReadYear ~/ 60;
    final minutes = totalMinutesReadYear % 60;

    return Column(
      children: [
        // Fila 1: Meta Anual y Meta Semanal
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                title: context.l10n.statsYearlyGoalTitle,
                icon: Icons.calendar_month_outlined,
                content: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 44,
                          height: 44,
                          child: CircularProgressIndicator(
                            value: goalProgress,
                            strokeWidth: 5,
                            backgroundColor: context.cozy.inkColor?.withValues(alpha: 0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              context.cozy.bookmarkColor ?? context.theme.primaryColor,
                            ),
                          ),
                        ),
                        Text(
                          '${(goalProgress * 100).toInt()}%',
                          style: context.theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        context.l10n.statsYearlyGoalSub(finishedBooksYear, annualGoal),
                        style: context.theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                title: context.l10n.statsWeeklyHoursGoalTitle,
                icon: Icons.access_time_outlined,
                content: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 44,
                          height: 44,
                          child: CircularProgressIndicator(
                            value: weeklyGoalProgress,
                            strokeWidth: 5,
                            backgroundColor: context.cozy.inkColor?.withValues(alpha: 0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              context.cozy.bookmarkColor ?? context.theme.primaryColor,
                            ),
                          ),
                        ),
                        Text(
                          '${(weeklyGoalProgress * 100).toInt()}%',
                          style: context.theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        context.l10n.statsWeeklyHoursGoalSub(weeklyReadText, weeklyGoalText),
                        style: context.theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Fila 2: Promedio mensual y Velocidad de lectura
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                title: context.l10n.statsMonthlyBooksAvg,
                value: monthlyBooksAvg.toStringAsFixed(1),
                icon: Icons.auto_stories_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                title: context.l10n.statsReadingSpeed,
                value: context.l10n.statsPagesPerHour(pagesPerHour.toStringAsFixed(1)),
                icon: Icons.speed_outlined,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Fila 3: Tarjeta de ancho completo
        SizedBox(
          width: double.infinity,
          child: _SummaryCard(
            title: context.l10n.statsTotalYearlySummary,
            value: context.l10n.statsTotalReadFormat(hours, minutes, totalPagesReadYear),
            icon: Icons.access_time_outlined,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String? value;
  final IconData? icon;
  final Widget? content;

  const _SummaryCard({
    required this.title,
    this.value,
    this.icon,
    this.content,
  });

  @override
  Widget build(BuildContext context) {
    return CustomInfoCardContainer(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.theme.textTheme.titleMedium,
                ),
              ),
              if (icon != null)
                Icon(
                  icon,
                  size: 16,
                  color: context.cozy.bookmarkColor?.withValues(alpha: 0.6),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (content != null)
            content!
          else if (value != null)
            Text(
              value!,
              style: context.theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.theme.colorScheme.onSurface,
              ),
            ),
        ],
      ) 
    );
  }
}