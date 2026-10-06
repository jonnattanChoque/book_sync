import 'package:book_sync/core/domain/entities/export_item_type.dart';
import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/utils/date_formatter.dart';
import 'package:book_sync/src/features/stats/domain/models/category_stat.dart';
import 'package:book_sync/src/features/stats/domain/models/reading_stat.dart';
import 'package:book_sync/src/features/stats/presentation/widgets/summary_card.dart';
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
  final List<CategoryStat> categoryChartData;
  final int currentStreakDays;
  final ReadingRecordData? bestRecord;
  final List<ExportItemConfig>? visibleItems;

  const StatsSummaryGrid({
    super.key,
    required this.monthlyBooksAvg,
    required this.pagesPerHour,
    required this.totalMinutesReadYear,
    required this.totalPagesReadYear, 
    required this.finishedBooksYear, 
    required this.annualGoal,
    required this.weeklyHoursGoal,
    required this.categoryChartData,
    required this.currentStreakDays,
    required this.bestRecord,
    this.weeklyHoursRead = 0.0,
    this.visibleItems
  });

  @override
  Widget build(BuildContext context) {
    // Si viene `visibleItems` (modal de exportación), filtramos solo las marcadas como visibles
    if (visibleItems != null) {
      final itemsToRender = visibleItems!.where((e) => e.isVisible).toList();
      final isOdd = itemsToRender.length.isOdd;

      return LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final halfWidth = (totalWidth - 12) / 2; // 12px de espaciado intermedio

          List<Widget> rows = [];
          int i = 0;

          while (i < itemsToRender.length) {
            // Regla: si es el último elemento Y la cantidad visible es impar, toma todo el ancho
            if (i == itemsToRender.length - 1 && isOdd) {
              rows.add(
                SizedBox(
                  width: totalWidth,
                  child: _buildCardByType(context, itemsToRender[i].type),
                ),
              );
              i++;
            } else {
              // Par de 2 columnas
              final first = itemsToRender[i];
              final second = itemsToRender[i + 1];

              rows.add(
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: halfWidth,
                        child: _buildCardByType(context, first.type),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: halfWidth,
                        child: _buildCardByType(context, second.type),
                      ),
                    ],
                  ),
                ),
              );
              i += 2;
            }
          }

          return Column(
            children: rows
                .map((row) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: row,
                    ))
                .toList(),
          );
        },
      );
    }

    // Modo por defecto (cuando se usa en la pantalla normal de Stats sin el filtro)
    return Column(
      children: [
        _buildRow(
          _buildCardByType(context, ExportItemType.yearlyGoal),
          _buildCardByType(context, ExportItemType.weeklyHoursGoal),
        ),
        const SizedBox(height: 16),
        _buildRow(
          _buildCardByType(context, ExportItemType.monthlyBooksAvg),
          _buildCardByType(context, ExportItemType.readingSpeed),
        ),
        const SizedBox(height: 16),
        _buildRow(
          _buildCardByType(context, ExportItemType.topGenres),
          _buildCardByType(context, ExportItemType.streak),
        ),
        const SizedBox(height: 16),
        _buildRow(
          _buildCardByType(context, ExportItemType.record),
          _buildCardByType(context, ExportItemType.totalYearly),
        ),
      ],
    );
  }

  Widget _buildRow(Widget card1, Widget card2) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: card1),
          const SizedBox(width: 12),
          Expanded(child: card2),
        ],
      ),
    );
  }

  // Mapeador dinámico de tarjetas según el tipo enum seleccionado
  Widget _buildCardByType(BuildContext context, ExportItemType type) {
    switch (type) {
      case ExportItemType.yearlyGoal:
        final goalProgress = annualGoal > 0 ? (finishedBooksYear / annualGoal).clamp(0.0, 1.0) : 0.0;
        return SummaryCard(
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
        );

      case ExportItemType.weeklyHoursGoal:
        final weeklyGoalProgress = (weeklyHoursGoal > 0) ? (weeklyHoursRead / weeklyHoursGoal).clamp(0.0, 1.0) : 0.0;
        final weeklyReadText = (weeklyHoursRead.truncateToDouble() == weeklyHoursRead) ? weeklyHoursRead.toInt().toString() : weeklyHoursRead.toStringAsFixed(1);
        final weeklyGoalText = (weeklyHoursGoal.truncateToDouble() == weeklyHoursGoal) ? weeklyHoursGoal.toInt().toString() : weeklyHoursGoal.toStringAsFixed(1);
        return SummaryCard(
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
        );

      case ExportItemType.monthlyBooksAvg:
        return SummaryCard(
          title: context.l10n.statsMonthlyBooksAvg,
          value: monthlyBooksAvg.toStringAsFixed(1),
          icon: Icons.auto_stories_outlined,
        );

      case ExportItemType.readingSpeed:
        return SummaryCard(
          title: context.l10n.statsReadingSpeed,
          value: context.l10n.statsPagesPerHour(pagesPerHour.toStringAsFixed(1)),
          icon: Icons.speed_outlined,
        );

      case ExportItemType.topGenres:
        final top3Genres = categoryChartData.toList()..sort((a, b) => b.bookCount.compareTo(a.bookCount));
        final top3List = top3Genres.take(3).toList();
        return SummaryCard(
          title: context.l10n.statsTopGenresTitle,
          icon: Icons.category_outlined,
          content: top3Genres.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: top3List.map((genre) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: context.cozy.bookmarkColor ?? context.theme.primaryColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              genre.categoryName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: context.theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                )
              : Text(
                  context.l10n.statsNoData,
                  style: context.theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.theme.colorScheme.onSurface,
                  ),
                ),
        );

      case ExportItemType.streak:
        return SummaryCard(
          title: context.l10n.statsCurrentStreakTitle,
          icon: Icons.local_fire_department_outlined,
          content: Row(
            children: [
              Icon(
                Icons.local_fire_department_rounded,
                size: 32,
                color: context.cozy.bookmarkColor ?? context.theme.primaryColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  context.l10n.statsStreakDaysFormat(currentStreakDays),
                  style: context.theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        );

      case ExportItemType.record:
        return SummaryCard(
          title: context.l10n.statsReadingRecordTitle,
          icon: Icons.emoji_events_outlined,
          content: bestRecord != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.auto_stories_outlined,
                          size: 14,
                          color: context.cozy.bookmarkColor ?? context.theme.primaryColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          context.l10n.statsPagesReadCount(bestRecord?.totalPages ?? 0),
                          style: context.theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 14,
                          color: context.cozy.bookmarkColor ?? context.theme.primaryColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          DateFormatter.formatDuration(Duration(seconds: bestRecord?.totalSeconds ?? 0)),
                          style: context.theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: context.cozy.bookmarkColor ?? context.theme.primaryColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${bestRecord?.date.day}/${bestRecord?.date.month}/${bestRecord?.date.year}',
                          style: context.theme.textTheme.bodySmall?.copyWith(
                            color: context.theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Text(
                  context.l10n.statsNoData,
                  style: context.theme.textTheme.bodySmall?.copyWith(
                    color: context.theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
        );

      case ExportItemType.totalYearly:
        final hours = totalMinutesReadYear ~/ 60;
        final minutes = totalMinutesReadYear % 60;
        return SummaryCard(
          title: context.l10n.statsTotalYearlySummary,
          value: context.l10n.statsTotalReadFormat(hours, minutes, totalPagesReadYear),
          icon: Icons.access_time_outlined,
        );
    }
  }
}