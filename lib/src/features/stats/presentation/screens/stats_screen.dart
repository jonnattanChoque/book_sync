// lib/src/features/stats/presentation/screens/stats_screen.dart

import 'package:book_sync/core/constants/app_constants.dart';
import 'package:book_sync/core/constants/app_icons.dart';
import 'package:book_sync/core/domain/entities/export_item_type.dart';
import 'package:book_sync/core/extensions/build_context_ext.dart';
import 'package:book_sync/core/providers/app_settings_provider.dart';
import 'package:book_sync/core/widgets/background_paper_texture.dart';
import 'package:book_sync/core/widgets/book_loader.dart';
import 'package:book_sync/src/features/export/presentation/export_preview_sheet.dart';
import 'package:book_sync/src/features/stats/domain/models/stats_stat.dart';
import 'package:book_sync/src/features/stats/presentation/widgets/category_pie_chart.dart';
import 'package:book_sync/src/features/stats/presentation/widgets/export_config_modal.dart';
import 'package:book_sync/src/features/stats/presentation/widgets/monthly_books_bar_chart.dart';
import 'package:book_sync/src/features/stats/presentation/widgets/monthly_reading_time_bar_chart.dart';
import 'package:book_sync/src/features/stats/presentation/widgets/star_rating_pie_chart.dart';
import 'package:book_sync/src/features/stats/presentation/widgets/stats_summary_export_view.dart';
import 'package:book_sync/src/features/stats/presentation/widgets/year_picker_button.dart';
import 'package:book_sync/src/features/streak/presentation/providers/streak_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/stats_provider.dart';
import '../widgets/stats_summary_grid.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsState = ref.watch(statsProvider);
    final userStreakAsync = ref.watch(userStreakStreamProvider);
    final settings = ref.watch(appSettingsProvider);
    final isPremium = settings.isPremium ?? false;

    final currentStreakDays = userStreakAsync.when(
      data: (streak) => streak?.currentStreak ?? 0,
      loading: () => 0,
      error: (_, _) => 0,
    );

    return ColoredBox(
      color: context.theme.scaffoldBackgroundColor,
      child: Stack(
        children: [
          // Textura de fondo persistente
          const Positioned.fill(
            child: BackgroundPaperTexture(),
          ),

          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: _buildNavBar(context, ref, currentStreakDays, isPremium),
            body: _buildStatsContent(context, statsState, ref),
          )
        ]
      )
    );
  }

  AppBar _buildNavBar(BuildContext context, WidgetRef ref, int currentStreakDays, bool isPremiumUser) {
    final statsState = ref.watch(statsProvider);

    void onExportPressed(BuildContext context) async {

      List<ExportItemConfig> itemsConfig = [
        ExportItemConfig(type: ExportItemType.yearlyGoal, title: context.l10n.statsYearlyGoalTitle),
        ExportItemConfig(type: ExportItemType.weeklyHoursGoal, title: context.l10n.statsWeeklyHoursGoalTitle),
        ExportItemConfig(type: ExportItemType.monthlyBooksAvg, title: context.l10n.statsMonthlyBooksAvg),
        ExportItemConfig(type: ExportItemType.readingSpeed, title: context.l10n.statsReadingSpeed),
        ExportItemConfig(type: ExportItemType.streak, title: context.l10n.statsTopGenresTitle),
        ExportItemConfig(type: ExportItemType.topGenres, title: context.l10n.statsCurrentStreakTitle),
        ExportItemConfig(type: ExportItemType.record, title: context.l10n.statsReadingRecordTitle),
        ExportItemConfig(type: ExportItemType.totalYearly, title: context.l10n.statsTotalYearlySummary),
      ];

      List<ExportItemConfig>? selectedItems;

      if (isPremiumUser) {
        selectedItems = await ExportConfigModal.show(
          context,
          initialItems: itemsConfig,
        );

        if (selectedItems == null) return;
      }
      
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return ExportPreviewSheet(
            exportContent: StatsSummaryExportView(
              statsState: statsState,
              currentStreakDays: currentStreakDays,
              visibleItems: selectedItems,
            ),
            shareText: context.l10n.exportDefaultShareText(AppConstants.appName),
          );
        },
      );
    }

    return AppBar(
      centerTitle: true,
      title: Text(context.l10n.statsBarChartTitle, style: context.theme.textTheme.titleLarge),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        // Botón de exportación
        IconButton(
          icon: const Icon(Icons.ios_share_outlined),
          tooltip: context.l10n.exportPreviewTitle,
          onPressed: () => onExportPressed(context),
        ),
      ],
      leading: Builder(
        builder: (context) {
          final modalRoute = ModalRoute.of(context);
          // Evaluamos si la ruta actual del screen (no del picker) puede hacer pop
          final canPop = modalRoute?.canPop ?? false;

          if (!canPop) return const SizedBox.shrink();

          return IconButton(
            icon: Icon(
              AppIcons.back,
              color: context.theme.colorScheme.onSurface,
            ),
            onPressed: () {
              // Si GoRouter maneja la pantalla principal:
              if (context.canPop()) {
                context.pop();
              } else {
                Navigator.of(context).maybePop();
              }
            },
          );
        },
      )
    );
  }

  Widget _buildStatsContent(BuildContext context, StatsState statsState, WidgetRef ref) {
    final userStreakAsync = ref.watch(userStreakStreamProvider);

    final currentStreakDays = userStreakAsync.when(
      data: (streak) => streak?.currentStreak ?? 0,
      loading: () => 0,
      error: (_, _) => 0,
    );

    return statsState.isLoading
      ? BookLoader()
      : RefreshIndicator(
        onRefresh: () => ref.read(statsProvider.notifier).loadStats(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    context.l10n.statsSelectYearTitle,
                    style: context.theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  YearCupertinoPickerButton(
                    selectedYear: statsState.selectedYear,
                    availableYears: statsState.availableYears.isNotEmpty
                        ? statsState.availableYears
                        : [DateTime.now().year],
                    onYearChanged: (newYear) {
                      ref.read(statsProvider.notifier).changeYear(newYear);
                    },
                  ),
                ],
              ),
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
              ),
              const SizedBox(height: 24),

              Text(
                context.l10n.statsMonthlyBooksSubtitle,
                style: context.theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              MonthlyBooksBarChart(
                statsData: statsState.monthlyBooksChartData,
              ),
              const SizedBox(height: 36),

              Text(
                context.l10n.statsReadingTimeChartTitle,
                style: context.theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              MonthlyReadingTimeBarChart(
                statsData: statsState.monthlyReadingTimeChartData,
              ),
              const SizedBox(height: 36),

              Text(
                context.l10n.statsRatingsChartTitle,
                style: context.theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              StarRatingPieChart(
                statsData: statsState.starRatingChartData,
              ),
              const SizedBox(height: 36),

              Text(
                context.l10n.statsCategoriesChartTitle,
                style: context.theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              CategoryPieChart(
                statsData: statsState.categoryChartData,
              ),
              const SizedBox(height: 36),
              // Aquí iremos agregando las siguientes secciones:
              // - 3.3.4 Gráfico de barras (libros/páginas y tiempo)
              // - 3.3.5 Gráficos de torta (género y calificación)
            ],
          ),
        ),
      );
  }
}