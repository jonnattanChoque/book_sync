// lib/src/domain/user_streak.dart
import 'package:isar/isar.dart';

part 'user_streak.g.dart';

@collection
class UserStreak {
  Id id = 1; // Un solo registro único para el usuario

  int currentStreak = 0;
  int bestStreak = 0;
  DateTime? lastReadingDate;

  // Lista con las fechas de lectura para el calendario
  List<DateTime> readingDays = [];
}