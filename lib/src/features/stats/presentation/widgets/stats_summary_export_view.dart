import 'package:book_sync/core/domain/entities/export_item_type.dart';
import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/src/features/stats/domain/models/stats_stat.dart';
import 'package:flutter/material.dart';
import 'stats_summary_grid.dart';

class StatsSummaryExportView extends StatelessWidget {
  final StatsState statsState;
  final int currentStreakDays;
  final List<ExportItemConfig>? visibleItems;

  const StatsSummaryExportView({
    super.key,
    required this.statsState,
    required this.currentStreakDays,
    this.visibleItems
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: _buildContent(context),
    );
  }

  Column _buildContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(context),
        const SizedBox(height: 16),
        StatsSummaryGrid(
          monthlyBooksAvg: statsState.monthlyBooksAvg,
          pagesPerHour: statsState.pagesPerHour,
          totalMinutesReadYear: statsState.totalMinutesReadYear,
          totalPagesReadYear: statsState.totalPagesReadYear,
          finishedBooksYear: statsState.finishedBooksYear,
          annualGoal: statsState.annualGoal,
          weeklyHoursGoal: statsState.weeklyHoursGoal,
          weeklyHoursRead: statsState.weeklyHoursRead,
          categoryChartData: statsState.categoryChartData,
          currentStreakDays: currentStreakDays,
          bestRecord: statsState.bestDayHours,
          visibleItems: visibleItems,
        )
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
          context.l10n.statsTitle(DateTime.now().year.toString()),
          style: context.theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}