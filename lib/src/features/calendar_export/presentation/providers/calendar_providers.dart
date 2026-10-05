import 'package:book_sync/src/features/calendar_export/domain/month_reading_stat.dart';
import 'package:book_sync/src/features/reader_session/domain/models/book_reading_summary.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_sync/src/features/streak/presentation/providers/streak_providers.dart';

/// Almacena la fecha seleccionada en la vista del calendario (Por defecto HOY)
final selectedCalendarDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

/// Almacena el mes en enfoque que se está viendo actualmente en el calendario
final focusedCalendarMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, 1);
});

/// Obtiene en tiempo real la lista de lecturas para la fecha actualmente seleccionada
final selectedDateReadingsProvider = FutureProvider<List<BookReadingSummary>>((ref) async {
  final selectedDate = ref.watch(selectedCalendarDateProvider);
  final repository = ref.watch(streakRepositoryProvider);
  
  return repository.getReadingsForDate(selectedDate);
});

final monthReadingStatsProvider = FutureProvider<MonthReadingStats>((ref) async {
  final focusedMonth = ref.watch(focusedCalendarMonthProvider);
  final repository = ref.watch(streakRepositoryProvider);

  // Definimos el rango del mes enfocado
  final startOfMonth = DateTime(focusedMonth.year, focusedMonth.month, 1, 0, 0, 0);
  // Último segundo del último día del mes
  final endOfMonth = DateTime(focusedMonth.year, focusedMonth.month + 1, 0, 23, 59, 59);

  // Consultar todas las sesiones en este rango de fechas directamente en Isar
  final monthSessions = await repository.getSessionsInDateRange(startOfMonth, endOfMonth);

  if (monthSessions.isEmpty) {
    return const MonthReadingStats(
      totalPages: 0,
      totalBooksRead: 0,
      activeDaysCount: 0,
    );
  }

  // 1. Total de páginas leídas
  final totalPages = monthSessions.fold<int>(0, (sum, s) => sum + s.pagesRead);

  // 2. Libros únicos leídos en el mes
  final uniqueBookIds = monthSessions.map((s) => s.bookId).toSet();

  // 3. Días activos de lectura únicos (agrupados por año-mes-día)
  final activeDays = monthSessions
      .map((s) => DateTime(s.startTime.year, s.startTime.month, s.startTime.day))
      .toSet();

  return MonthReadingStats(
    totalPages: totalPages,
    totalBooksRead: uniqueBookIds.length,
    activeDaysCount: activeDays.length,
  );
});