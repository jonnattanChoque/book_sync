// lib/src/features/streak/presentation/providers/streak_providers.dart
import 'package:book_sync/core/persistence/isar_provider.dart';
import 'package:book_sync/src/features/reader_session/domain/models/book_reading_summary.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_sync/src/domain/user_streak.dart';
import 'package:book_sync/src/features/streak/data/streak_repository.dart';

// Proveedor del Repositorio
final streakRepositoryProvider = Provider<StreakRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return StreakRepository(isar);
});

// Escucha en tiempo real la racha para mostrar en la UI (Cards del Home y Métricas)
final userStreakStreamProvider = StreamProvider<UserStreak?>((ref) {
  final repository = ref.watch(streakRepositoryProvider);
  return repository.watchStreak();
});

// Caso de uso: Registrar lectura
final registerReadingDayProvider = Provider((ref) {
  final repository = ref.watch(streakRepositoryProvider);
  return ([DateTime? date]) async {
    await repository.registerReadingDay(date);
  };
});

// Caso de uso: Verificar inactividad al abrir la app
final checkStreakInactivityProvider = Provider((ref) {
  final repository = ref.watch(streakRepositoryProvider);
  return () async {
    await repository.checkAndResetStreakIfInactive();
  };
});

final selectedCalendarDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

// Lecturas y páginas leídas en la fecha seleccionada del calendario
final selectedDateReadingsProvider = FutureProvider<List<BookReadingSummary>>((ref) async {
  final repository = ref.watch(streakRepositoryProvider);
  final selectedDate = ref.watch(selectedCalendarDateProvider);
  return repository.getReadingsForDate(selectedDate);
});