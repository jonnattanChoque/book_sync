import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/theme/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../domain/models/category_stat.dart';

class CategoryPieChart extends StatefulWidget {
  final List<CategoryStat> statsData;

  const CategoryPieChart({
    super.key,
    required this.statsData,
  });

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int touchedIndex = -1;
  final categoryPalette = AppColors.categoryPalette;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final totalBooks = widget.statsData.fold<int>(0, (sum, item) => sum + item.bookCount);
    final hasData = totalBooks > 0;

    final selectedStat = (touchedIndex >= 0 && touchedIndex < widget.statsData.length)
        ? widget.statsData[touchedIndex]
        : null;

    return Container(
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
      ? Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selectedStat != null && selectedStat.bookTitles.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildCategoryTooltip(context, theme, selectedStat),
            ],
            SizedBox(
              height: 200,
              child: Row(
                children: [
                  // 1. Torta
                  Expanded(
                    child: _buildPieChart(context, theme),
                  ),
                  const SizedBox(width: 16),
                  // 2. Leyenda
                  Expanded(
                    child: _buildLegend(context, theme),
                  ),
                ],
              ),
            ),
          ],
        )
      : _buildEmptyState(context, theme),
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 40,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.statsNoCategoriesForYearTitle,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(BuildContext context, ThemeData theme) {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  pieTouchResponse == null ||
                  pieTouchResponse.touchedSection == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex =
                  pieTouchResponse.touchedSection!.touchedSectionIndex;
            });
          },
        ),
        borderData: FlBorderData(show: false),
        sectionsSpace: 3,
        centerSpaceRadius: 36,
        sections: List.generate(widget.statsData.length, (i) {
          final isTouched = i == touchedIndex;
          final item = widget.statsData[i];
          final double radius = isTouched ? 36.0 : 30.0;
          final color = categoryPalette[i % categoryPalette.length];

          return PieChartSectionData(
            color: color,
            value: item.bookCount.toDouble(),
            title: '${item.bookCount}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: isTouched ? 13.0 : 11.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLegend(BuildContext context, ThemeData theme) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(widget.statsData.length, (index) {
          final item = widget.statsData[index];
          final color = categoryPalette[index % categoryPalette.length];
          final isSelected = touchedIndex == index;

          return InkWell(
            onTap: () {
              setState(() {
                touchedIndex = touchedIndex == index ? -1 : index;
              });
            },
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.categoryName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: isSelected ? 1.0 : 0.7,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${item.bookCount})',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCategoryTooltip(
    BuildContext context,
    ThemeData theme,
    CategoryStat stat,
  ) {
    const int maxVisible = 3;
    final visibleTitles = stat.bookTitles.take(maxVisible).toList();
    final remainingCount = stat.bookTitles.length - maxVisible;

    final color = categoryPalette[touchedIndex % categoryPalette.length];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.statsBooksInCategory(stat.categoryName),
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          ...visibleTitles.map(
            (title) => Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                '• $title',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                ),
              ),
            ),
          ),
          if (remainingCount > 0)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                '  (+$remainingCount más)',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
        ],
      ),
    );
  }
}