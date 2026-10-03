import 'package:book_sync/src/features/stats/domain/models/category_stat.dart';
import 'package:book_sync/src/features/stats/domain/models/monthly_book_stat.dart';
import 'package:book_sync/src/features/stats/domain/models/monthly_reading_time_stat.dart';
import 'package:book_sync/src/features/stats/domain/models/reading_stat.dart';
import 'package:book_sync/src/features/stats/domain/models/star_rating_stat.dart';

const int kDefaultAnnualBookGoal = 12;
const double kDefaultWeeklyHoursGoal = 5.0;

class StatsState {
  final int selectedYear;
  final List<int> availableYears;
  final double monthlyBooksAvg;
  final double pagesPerHour;
  final int totalMinutesReadYear;
  final int totalPagesReadYear;
  final List<MonthlyBookStat> monthlyBooksChartData;
  final List<MonthlyReadingTimeStat> monthlyReadingTimeChartData;
  final List<StarRatingStat> starRatingChartData;
  final List<CategoryStat> categoryChartData;
  final int finishedBooksYear;
  final int annualGoal;
  final double weeklyHoursRead;
  final double weeklyHoursGoal;
  final double goalProgressPercentage;
  final ReadingRecordData? bestDayHours;
  final bool isLoading;

  StatsState({
    int? selectedYear,
    this.availableYears = const [],
    this.monthlyBooksAvg = 0.0,
    this.pagesPerHour = 0.0,
    this.totalMinutesReadYear = 0,
    this.totalPagesReadYear = 0,
    this.monthlyBooksChartData = const [],
    this.monthlyReadingTimeChartData = const [],
    this.starRatingChartData = const [],
    this.categoryChartData = const [],
    this.finishedBooksYear = 0,
    this.weeklyHoursRead = 0.0,
    this.annualGoal = kDefaultAnnualBookGoal,
    this.weeklyHoursGoal = kDefaultWeeklyHoursGoal,
    this.goalProgressPercentage = 0.0,
    this.bestDayHours,
    this.isLoading = true,
  }) : selectedYear = selectedYear ?? DateTime.now().year;

  StatsState copyWith({
    int? selectedYear,
    List<int>? availableYears,
    double? monthlyBooksAvg,
    double? pagesPerHour,
    int? totalMinutesReadYear,
    int? totalPagesReadYear,
    List<MonthlyBookStat>? monthlyBooksChartData,
    List<MonthlyReadingTimeStat>? monthlyReadingTimeChartData,
    List<StarRatingStat>? starRatingChartData,
    List<CategoryStat>? categoryChartData,
    int? finishedBooksYear,
    int? annualGoal,
    double? weeklyHoursRead,
    double? weeklyHoursGoal,
    double? goalProgressPercentage,
    ReadingRecordData? bestDayHours,
    bool? isLoading,
  }) {
    return StatsState(
      selectedYear: selectedYear ?? this.selectedYear,
      availableYears: availableYears ?? this.availableYears,
      monthlyBooksAvg: monthlyBooksAvg ?? this.monthlyBooksAvg,
      pagesPerHour: pagesPerHour ?? this.pagesPerHour,
      totalMinutesReadYear: totalMinutesReadYear ?? this.totalMinutesReadYear,
      totalPagesReadYear: totalPagesReadYear ?? this.totalPagesReadYear,
      monthlyBooksChartData: monthlyBooksChartData ?? this.monthlyBooksChartData,
      monthlyReadingTimeChartData: monthlyReadingTimeChartData ?? this.monthlyReadingTimeChartData,
      starRatingChartData: starRatingChartData ?? this.starRatingChartData,
      categoryChartData: categoryChartData ?? this.categoryChartData,
      finishedBooksYear: finishedBooksYear ?? this.finishedBooksYear,
      annualGoal: annualGoal ?? this.annualGoal,
      weeklyHoursRead: weeklyHoursRead ?? this.weeklyHoursRead,
      weeklyHoursGoal: weeklyHoursGoal ?? this.weeklyHoursGoal,
      goalProgressPercentage: goalProgressPercentage ?? this.goalProgressPercentage,
      bestDayHours: bestDayHours ?? this.bestDayHours,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}