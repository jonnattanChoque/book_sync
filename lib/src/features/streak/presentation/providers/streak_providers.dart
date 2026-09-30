// lib/src/features/streak/presentation/providers/streak_providers.dart
import 'package:book_sync/core/persistence/isar_provider.dart';
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
  return () async {
    await repository.registerReadingDay();
  };
});

// Caso de uso: Verificar inactividad al abrir la app
final checkStreakInactivityProvider = Provider((ref) {
  final repository = ref.watch(streakRepositoryProvider);
  return () async {
    await repository.checkAndResetStreakIfInactive();
  };
});