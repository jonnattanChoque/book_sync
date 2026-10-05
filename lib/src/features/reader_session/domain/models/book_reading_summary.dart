import 'package:book_sync/src/domain/book.dart';

class BookReadingSummary {
  final Book book;
  final int totalPagesRead;
  final int totalDurationSeconds;

  BookReadingSummary({
    required this.book,
    required this.totalPagesRead,
    required this.totalDurationSeconds,
  });

  /// Duración formateada (ej. "35m")
  String get durationFormatted {
    final minutes = (totalDurationSeconds / 60).round();
    return '${minutes}m';
  }

  String get formattedDurationTwo => formatSeconds(totalDurationSeconds);

  /// Método estático reutilizable sin necesitar un objeto `Book`
  static String formatSeconds(int totalSeconds) {
    final minutes = (totalSeconds / 60).round();
    if (minutes < 60) {
      return '${minutes}m';
    }
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return remainingMinutes > 0 ? '${hours}h ${remainingMinutes}m' : '${hours}h';
  }
}