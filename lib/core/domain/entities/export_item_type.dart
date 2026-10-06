enum ExportItemType {
  yearlyGoal,
  weeklyHoursGoal,
  monthlyBooksAvg,
  readingSpeed,
  streak,
  topGenres,
  record,
  totalYearly
}

class ExportItemConfig {
  final ExportItemType type;
  final String title;
  bool isVisible;

  ExportItemConfig({
    required this.type,
    required this.title,
    this.isVisible = true,
  });
}