import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';

class StatsSummaryGrid extends StatelessWidget {
  final double monthlyBooksAvg;
  final double pagesPerHour;
  final int totalMinutesReadYear;
  final int totalPagesReadYear;
  final int finishedBooksYear;
  final int annualGoal;

  const StatsSummaryGrid({
    super.key,
    required this.monthlyBooksAvg,
    required this.pagesPerHour,
    required this.totalMinutesReadYear,
    required this.totalPagesReadYear, 
    required this.finishedBooksYear, 
    required this.annualGoal,
  });

  @override
  Widget build(BuildContext context) {

    double goalProgress = finishedBooksYear / annualGoal;

    final hours = totalMinutesReadYear ~/ 60;
    final minutes = totalMinutesReadYear % 60;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.35,
      children: [
        _SummaryCard(
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
                    color: context.theme.colorScheme.onSurface
                  ),
                ),
              ),
            ],
          ),
        ),

        _SummaryCard(
          title: context.l10n.statsMonthlyBooksAvg,
          value: monthlyBooksAvg.toStringAsFixed(1),
          icon: Icons.auto_stories_outlined,
        ),

        _SummaryCard(
          title: context.l10n.statsReadingSpeed,
          value: context.l10n.statsPagesPerHour(pagesPerHour.toStringAsFixed(1)),
          icon: Icons.speed_outlined,
        ),

        _SummaryCard(
          title: context.l10n.statsTotalYearlySummary,
          value: context.l10n.statsTotalReadFormat(hours, minutes, totalPagesReadYear),
          icon: Icons.access_time_outlined,
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.theme.cardColor.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.cozy.inkColor?.withValues(alpha: 0.08) ?? Colors.grey.shade300,
        ),
      ),
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
      ),
    );
  }
}