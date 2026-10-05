// lib/src/features/stats/presentation/widgets/monthly_books_bar_chart.dart

import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../domain/models/monthly_book_stat.dart';

class MonthlyBooksBarChart extends StatelessWidget {
  final List<MonthlyBookStat> statsData;

  const MonthlyBooksBarChart({
    super.key,
    required this.statsData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    
    // Calculamos el total de libros en todo el año
    final totalBooksYear = statsData.fold<int>(0, (sum, item) => sum + item.bookCount);
    final hasData = totalBooksYear > 0;

    return Container(
      height: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: 0.4), // Card Informativa pasiva
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.cozy.inkColor?.withValues(alpha: 0.08) ?? Colors.grey.shade300,
        ),
      ),
      child: hasData
          ? _buildBarChart(context, theme)
          : _buildEmptyState(context, theme),
    );
  }

  /// Vista de Estado Vacío (Sin datos en el año seleccionado)
  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bar_chart_rounded,
            size: 40,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.statsNoDataForYearTitle,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.statsNoDataForYearSubtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Gráfico de Barras con FLChart
  Widget _buildBarChart(BuildContext context, ThemeData theme) {
    final maxBooks = statsData
        .map((e) => e.bookCount)
        .reduce((a, b) => a > b ? a : b);

    final double maxY = (maxBooks < 4 ? 4 : maxBooks + 1).toDouble();

    return BarChart(
      BarChartData(
        maxY: maxY,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => context.cozy.bookmarkColor ?? theme.primaryColor,
            tooltipPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            tooltipBorder: BorderSide.none,
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final monthName = statsData[groupIndex].monthLabel;
              final count = rod.toY.toInt();
              final bookLabel = count == 1
                  ? context.l10n.statsBookCountSingular
                  : context.l10n.statsBookCountPlural;

              return BarTooltipItem(
                '$monthName: $count $bookLabel',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value % 1 != 0) return const SizedBox.shrink();
                return Text(
                  value.toInt().toString(),
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
                return Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                    statsData[index].monthLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 1,
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
                width: 14,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
          );
        }),
      ),
    );
  }
}