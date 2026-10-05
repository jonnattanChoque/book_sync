import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../domain/models/monthly_reading_time_stat.dart';

class MonthlyReadingTimeBarChart extends StatelessWidget {
  final List<MonthlyReadingTimeStat> statsData;

  const MonthlyReadingTimeBarChart({
    super.key,
    required this.statsData,
  });

  /// Formatea minutos a formato legible (ej. "30h 20m" o "45m")
  String _formatReadingTime(int totalMinutes) {
    if (totalMinutes <= 0) return '0m';
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;

    final totalMinutesYear =
        statsData.fold<int>(0, (sum, item) => sum + item.totalMinutes);
    final hasData = totalMinutesYear > 0;

    return Container(
      height: 240,
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
            Icons.timer_outlined,
            size: 40,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
          ),
          const SizedBox(height: 12),
          Text(
            context.l10n.statsNoReadingTimeForYearTitle,
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
    final maxMinutes = statsData
      .map((e) => e.totalMinutes)
      .reduce((a, b) => a > b ? a : b);

  // 1. Determinar el maxY mínimo (al menos 60 min)
    final double maxY = maxMinutes < 60 ? 60.0 : (maxMinutes * 1.15);

    // 2. Determinar el intervalo del Eje Y dinámicamente
    final double yInterval = maxMinutes < 60
        ? 15.0 // Muestra marcas cada 15 minutos (15m, 30m, 45m, 1h)
        : (maxY / 4).clamp(30.0, double.infinity);

    return BarChart(
      BarChartData(
        maxY: maxY,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) =>
                context.cozy.bookmarkColor ?? theme.primaryColor,
            tooltipPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            tooltipBorder: BorderSide.none,
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final item = statsData[groupIndex];
              final timeFormatted = _formatReadingTime(item.totalMinutes);
              final pagesFormatted =
                  context.l10n.statsPagesCount(item.totalPages);

              return BarTooltipItem(
                '${item.monthLabel}: $timeFormatted • $pagesFormatted',
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
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: yInterval,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const SizedBox.shrink();

                // Si el tiempo máximo es menor a 1 hora, mostrar en minutos
                if (maxMinutes < 60) {
                  if (value == 60) return const Text('1h');
                  return Text(
                    '${value.toInt()}m',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  );
                }

                // Si supera 1 hora, mostrar sólo en horas enteras
                final hours = value / 60;
                if (hours % 1 != 0) return const SizedBox.shrink();

                return Text(
                  '${hours.toInt()}h',
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
                toY: data.totalMinutes.toDouble(),
                color: context.cozy.bookmarkColor ?? theme.primaryColor,
                width: 14,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
          );
        }),
      ),
    );
  }
}