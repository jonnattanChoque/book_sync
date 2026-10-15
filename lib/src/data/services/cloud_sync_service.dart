import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:book_sync/src/domain/book.dart';
import 'package:book_sync/src/domain/note.dart';
import 'package:book_sync/src/domain/app_config.dart';
import 'package:book_sync/src/domain/user_streak.dart';

class CloudSyncService {
  final Isar isar;
  final SupabaseClient _supabase = Supabase.instance.client;

  CloudSyncService(this.isar);

  /// Método principal para exportar todos los datos locales del usuario a Supabase
  Future<void> exportAllDataToCloud() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('No hay un usuario autenticado para realizar la sincronización.');
    }

    // 1. Sincronizar AppConfig (Configuración del usuario)
    final appConfig = await isar.appConfigs.filter().userIdEqualTo(userId).findFirst() 
                      ?? await isar.appConfigs.get(1);
                      
    if (appConfig != null) {
      await _supabase.from('app_configs').upsert({
        'user_id': userId,
        'user_name': appConfig.userName,
        'user_email': appConfig.userEmail,
        'profile_image_path': appConfig.profileImagePath,
        'theme_mode': appConfig.themeMode,
        'language_code': appConfig.languageCode,
        'is_premium': appConfig.isPremium,
        'is_alarm_enabled': appConfig.isAlarmEnabled,
        'alarm_hour': appConfig.alarmHour,
        'alarm_minute': appConfig.alarmMinute,
        'yearly_goal_books': appConfig.yearlyGoalBooks,
        'weekly_goal_hours': appConfig.weeklyGoalHours,
      }, onConflict: 'user_id');
    }

    // 2. Sincronizar Libros (Books)
    final books = await isar.books.where().findAll();
    if (books.isNotEmpty) {
      final booksJson = books.map((book) => {
        'id': book.id, // ID local opcional o puedes usar un UUID propio
        'user_id': userId,
        'title': book.title,
        'author': book.author,
        'cover_path': book.coverPath,
        'total_pages': book.totalPages,
        'notes_count': book.notesCount,
        'current_page': book.currentPage,
        'progress': book.progress,
        'started_at': book.startedAt?.toIso8601String(),
        'isbn': book.isbn,
        'language': book.language,
        'description': book.description,
        'publisher': book.publisher,
        'published_date': book.publishedDate,
        'categories': book.categories,
        'is_favorite': book.isFavorite,
        'rating': book.rating,
        'conclusions': book.conclusions,
        'status': book.status.name, // Convertimos el enum a String
      }).toList();

      await _supabase.from('books').upsert(booksJson);
    }

    // 3. Sincronizar Sesiones de Lectura (ReadingSessions)
    final sessions = await isar.readingSessions.where().findAll();
    if (sessions.isNotEmpty) {
      final sessionsJson = sessions.map((session) => {
        'id': session.id,
        'user_id': userId,
        'book_id': session.bookId, // Clave foránea al libro
        'start_time': session.startTime.toIso8601String(),
        'end_time': session.endTime?.toIso8601String(),
        'duration_seconds': session.durationSeconds,
        'start_page': session.startPage,
        'end_page': session.endPage,
        'pages_read': session.pagesRead,
      }).toList();

      await _supabase.from('reading_sessions').upsert(sessionsJson);
    }

    // 4. Sincronizar Notas (Notes)
    final notes = await isar.notes.where().findAll();
    if (notes.isNotEmpty) {
      final notesJson = notes.map((note) => {
        'id': note.id,
        'user_id': userId,
        'book_id': note.bookId,
        'category': note.category,
        'page': note.page,
        'content': note.content,
        'created_at': note.createdAt.toIso8601String(),
      }).toList();

      await _supabase.from('notes').upsert(notesJson);
    }

    // 5. Sincronizar Rachas y Calendario (UserStreak)
    final streak = await isar.userStreaks.get(1);
    if (streak != null) {
      await _supabase.from('user_streaks').upsert({
        'user_id': userId,
        'current_streak': streak.currentStreak,
        'best_streak': streak.bestStreak,
        'last_reading_date': streak.lastReadingDate?.toIso8601String(),
        // Convertimos la lista de DateTime a lista de Strings ISO para Supabase (tipo text[] o json)
        'reading_days': streak.readingDays.map((d) => d.toIso8601String()).toList(),
      }, onConflict: 'user_id');
    }
  }
}