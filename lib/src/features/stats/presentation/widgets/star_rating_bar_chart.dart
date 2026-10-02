import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../domain/models/star_rating_stat.dart';

class StarRatingBarChart extends StatelessWidget {
  final List<StarRatingStat> statsData;

  const StarRatingBarChart({
    super.key,
    required this.statsData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final totalRatedBooks =
        statsData.fold<int>(0, (sum, item) => sum + item.bookCount);
    final hasData = totalRatedBooks > 0;

    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.cozy.inkColor?.withValues(alpha: 0.08) ??
              Colors.grey.shade300,
        ),
      ),
      child: hasData
          ? _buildBarChart(context, theme)
          : _buildEmptyState(context, theme),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star_outline_rounded,
            size: 40,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.statsNoRatingsForYearTitle,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(BuildContext context, ThemeData theme) {
    final maxBooks = statsData
        .map((e) => e.bookCount)
        .reduce((a, b) => a > b ? a : b);

    final double maxY = maxBooks < 5 ? 5.0 : (maxBooks * 1.2);
    final double yInterval = maxBooks < 5 ? 1.0 : (maxY / 4).ceilToDouble();

    return BarChart(
      BarChartData(
        maxY: maxY,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) =>
                context.cozy.bookmarkColor ?? theme.primaryColor,
            tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            tooltipBorder: BorderSide.none,
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final item = statsData[groupIndex];

              if (item.bookTitles.isEmpty) {
                return BarTooltipItem(
                  '${item.rating}★\n${context.l10n.statsNoRatingsForYearTitle}',
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                );
              }

              const int maxVisible = 3;
              final visibleTitles = item.bookTitles.take(maxVisible).join('\n• ');
              final remainingCount = item.bookTitles.length - maxVisible;

              final String tooltipText = remainingCount > 0
                  ? '• $visibleTitles\n  (+$remainingCount más)'
                  : '• $visibleTitles';

              return BarTooltipItem(
                '${item.rating}★:\n$tooltipText',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  height: 1.3,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: yInterval,
              getTitlesWidget: (value, meta) {
                if (value % 1 != 0 || value < 0) return const SizedBox.shrink();
                return Text(
                  '${value.toInt()}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= statsData.length) {
                  return const SizedBox.shrink();
                }
                final rating = statsData[index].rating;
                return Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$rating',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.star_rounded,
                        size: 13,
                        color: Colors.amber.shade700,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: yInterval,
          getDrawingHorizontalLine: (value) => FlLine(
            color: theme.dividerColor.withValues(alpha: 0.1),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(statsData.length, (index) {
          final data = statsData[index];
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: data.bookCount.toDouble(),
                color: context.cozy.bookmarkColor ?? theme.primaryColor,
                width: 22,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(6)),
              ),
            ],
          );
        }),
      ),
    );
  }
}