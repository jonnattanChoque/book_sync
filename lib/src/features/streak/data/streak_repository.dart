// lib/src/features/streak/data/streak_repository.dart
import 'package:book_sync/src/domain/book.dart';
import 'package:book_sync/src/features/reader_session/domain/models/book_reading_summary.dart';
import 'package:isar/isar.dart';
import 'package:book_sync/src/domain/user_streak.dart';

class StreakRepository {
  final Isar isar;

  StreakRepository(this.isar);

  /// Obtiene o inicializa el objeto único de racha del usuario
  Future<UserStreak> getStreak() async {
    final streak = await isar.userStreaks.get(1);
    if (streak == null) {
      final newStreak = UserStreak();
      await isar.writeTxn(() async {
        await isar.userStreaks.put(newStreak);
      });
      return newStreak;
    }
    return streak;
  }

  /// Escucha en tiempo real la racha del usuario
  Stream<UserStreak?> watchStreak() {
    return isar.userStreaks.watchObject(1, fireImmediately: true);
  }

  /// Registra la lectura del día y actualiza racha actual y mejor racha
  Future<void> registerReadingDay([DateTime? customDate]) async {
    await isar.writeTxn(() async {
      final streak = await isar.userStreaks.get(1) ?? UserStreak();
      
      // Si viene una fecha personalizada (ej: 2 de octubre), la usamos; si no, usará hoy.
      final targetDate = customDate != null
          ? DateTime(customDate.year, customDate.month, customDate.day)
          : () {
              final now = DateTime.now();
              return DateTime(now.year, now.month, now.day);
            }();

      if (streak.lastReadingDate == null) {
        // Primera lectura registrada
        streak.currentStreak = 1;
      } else {
        final lastDate = DateTime(
          streak.lastReadingDate!.year,
          streak.lastReadingDate!.month,
          streak.lastReadingDate!.day,
        );

        final difference = targetDate.difference(lastDate).inDays;

        if (difference == 1) {
          // Leyó el día anterior consecutivamente
          streak.currentStreak += 1;
        } else if (difference > 1) {
          // Se rompió la racha por inactividad
          streak.currentStreak = 1;
        }
        // Si difference == 0 (ya leyó en este día), conserva la racha sin duplicar
      }

      // Actualizar récord histórico de mejor racha
      if (streak.currentStreak > streak.bestStreak) {
        streak.bestStreak = streak.currentStreak;
      }

      // Si la lectura es más reciente que la última registrada, actualizamos lastReadingDate
      if (streak.lastReadingDate == null || targetDate.isAfter(streak.lastReadingDate!)) {
        streak.lastReadingDate = targetDate;
      }

      // Guardar la fecha en el historial del calendario para que aparezca el punto
      final hasReadOnTargetDate = streak.readingDays.any((d) =>
          d.year == targetDate.year &&
          d.month == targetDate.month &&
          d.day == targetDate.day);

      if (!hasReadOnTargetDate) {
        streak.readingDays.add(targetDate);
      }

      await isar.userStreaks.put(streak);
    });
  }

  /// Verifica al abrir la app si la racha debe reiniciarse a 0
  Future<void> checkAndResetStreakIfInactive() async {
    await isar.writeTxn(() async {
      final streak = await isar.userStreaks.get(1);
      if (streak == null || streak.lastReadingDate == null) return;

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final lastDate = DateTime(
        streak.lastReadingDate!.year,
        streak.lastReadingDate!.month,
        streak.lastReadingDate!.day,
      );

      final difference = today.difference(lastDate).inDays;

      // Si pasaron más de 24 horas sin leer ayer (diferencia mayor a 1 día)
      if (difference > 1 && streak.currentStreak > 0) {
        streak.currentStreak = 0;
        await isar.userStreaks.put(streak); // Conserva bestStreak e historial intactos
      }
    });
  }

  /// Obtiene el desglose de libros leídos y páginas en una fecha específica
  Future<List<BookReadingSummary>> getReadingsForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    // Consulta directa en la colección de sesiones de Isar
    final sessionsOfDay = await isar.readingSessions
        .filter()
        .startTimeBetween(startOfDay, endOfDay)
        .findAll();

    if (sessionsOfDay.isEmpty) return [];

    // Agrupar sesiones por bookId
    final Map<int, List<ReadingSession>> grouped = {};
    for (final session in sessionsOfDay) {
      grouped.putIfAbsent(session.bookId, () => []).add(session);
    }

    final List<BookReadingSummary> summaries = [];

    for (final entry in grouped.entries) {
      final bookId = entry.key;
      final sessions = entry.value;

      final book = await isar.books.get(bookId);
      if (book != null) {
        final totalPages = sessions.fold<int>(0, (sum, s) => sum + s.pagesRead);
        final totalDuration = sessions.fold<int>(0, (sum, s) => sum + s.durationSeconds);

        summaries.add(BookReadingSummary(
          book: book,
          totalPagesRead: totalPages,
          totalDurationSeconds: totalDuration,
        ));
      }
    }

    return summaries;
  }

  /// Obtiene todas las sesiones de lectura dentro de un rango de fechas especificado
  Future<List<ReadingSession>> getSessionsInDateRange(DateTime start, DateTime end) async {
    return await isar.readingSessions
        .filter()
        .startTimeBetween(start, end)
        .findAll();
  }
}