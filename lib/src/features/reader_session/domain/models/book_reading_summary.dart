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
}