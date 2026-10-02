// lib/src/features/stats/domain/models/monthly_book_stat.dart

class MonthlyBookStat {
  final String monthLabel;
  final int bookCount;

  const MonthlyBookStat({
    required this.monthLabel,
    required this.bookCount,
  });
}