// lib/src/features/streak/data/streak_repository.dart
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
  Future<void> registerReadingDay() async {
    await isar.writeTxn(() async {
      final streak = await isar.userStreaks.get(1) ?? UserStreak();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      if (streak.lastReadingDate == null) {
        // Primera lectura registrada
        streak.currentStreak = 1;
      } else {
        final lastDate = DateTime(
          streak.lastReadingDate!.year,
          streak.lastReadingDate!.month,
          streak.lastReadingDate!.day,
        );

        final difference = today.difference(lastDate).inDays;

        if (difference == 1) {
          // Leyó el día anterior consecutivamente
          streak.currentStreak += 1;
        } else if (difference > 1) {
          // Se rompió la racha por inactividad
          streak.currentStreak = 1;
        }
        // Si difference == 0 (ya leyó hoy), conserva la racha actual sin duplicar conteo
      }

      // Actualizar récord histórico de mejor racha
      if (streak.currentStreak > streak.bestStreak) {
        streak.bestStreak = streak.currentStreak;
      }

      streak.lastReadingDate = today;

      // Guardar la fecha en el historial del calendario si no estaba agregada
      final hasReadToday = streak.readingDays.any((d) =>
          d.year == today.year && d.month == today.month && d.day == today.day);
      if (!hasReadToday) {
        streak.readingDays.add(today);
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
}