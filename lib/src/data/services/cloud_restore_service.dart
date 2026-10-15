import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:book_sync/src/domain/book.dart';
import 'package:book_sync/src/domain/note.dart';
import 'package:book_sync/src/domain/app_config.dart';
import 'package:book_sync/src/domain/user_streak.dart';

class CloudRestoreService {
  final Isar isar;
  final SupabaseClient _supabase = Supabase.instance.client;

  CloudRestoreService(this.isar);

  /// Descarga toda la información desde Supabase y la restaura en Isar
  Future<void> restoreAllDataFromCloud() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('No hay un usuario autenticado para realizar la restauración.');
    }

    await isar.writeTxn(() async {
      // 1. Restaurar AppConfig
      final configResponse = await _supabase
          .from('app_configs')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (configResponse != null) {
        final existingConfig = await isar.appConfigs.filter().userIdEqualTo(userId).findFirst() 
                              ?? await isar.appConfigs.get(1) 
                              ?? AppConfig();

        existingConfig.userId = userId;
        existingConfig.userName = configResponse['user_name'] ?? existingConfig.userName;
        existingConfig.userEmail = configResponse['user_email'] ?? existingConfig.userEmail;
        existingConfig.profileImagePath = configResponse['profile_image_path'] ?? existingConfig.profileImagePath;
        existingConfig.themeMode = configResponse['theme_mode'] ?? existingConfig.themeMode;
        existingConfig.languageCode = configResponse['language_code'] ?? existingConfig.languageCode;
        existingConfig.isPremium = configResponse['is_premium'] ?? existingConfig.isPremium;
        existingConfig.isAlarmEnabled = configResponse['is_alarm_enabled'] ?? existingConfig.isAlarmEnabled;
        existingConfig.alarmHour = configResponse['alarm_hour'] ?? existingConfig.alarmHour;
        existingConfig.alarmMinute = configResponse['alarm_minute'] ?? existingConfig.alarmMinute;
        existingConfig.yearlyGoalBooks = configResponse['yearly_goal_books'] ?? existingConfig.yearlyGoalBooks;
        existingConfig.weeklyGoalHours = (configResponse['weekly_goal_hours'] as num?)?.toDouble() ?? existingConfig.weeklyGoalHours;

        await isar.appConfigs.put(existingConfig);
      }

      // 2. Restaurar Libros (Books)
      final booksResponse = await _supabase
          .from('books')
          .select()
          .eq('user_id', userId);

      if (booksResponse.isNotEmpty) {
        // Opcional: limpiar o actualizar con upsert
        for (var item in booksResponse) {
          final book = Book(
            userId: userId,
            title: item['title'] ?? '',
            author: item['author'] ?? '',
            progress: (item['progress'] as num?)?.toDouble() ?? 0.0,
            status: BookStatus.values.firstWhere(
              (e) => e.name == item['status'],
              orElse: () => BookStatus.toRead,
            ),
            coverPath: item['cover_path'],
            totalPages: item['total_pages'],
            notesCount: item['notes_count'],
            currentPage: item['current_page'] ?? 0,
            startedAt: item['started_at'] != null ? DateTime.parse(item['started_at']) : null,
            isbn: item['isbn'],
            language: item['language'],
            description: item['description'],
            publisher: item['publisher'],
            publishedDate: item['published_date'],
            categories: (item['categories'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
            isFavorite: item['is_favorite'],
            rating: (item['rating'] as num?)?.toDouble(),
            conclusions: item['conclusions'],
          );
          book.id = item['id']; // Mantenemos el mismo ID local si es posible

          await isar.books.put(book);
        }
      }

      // 3. Restaurar Sesiones de Lectura (ReadingSessions)
      final sessionsResponse = await _supabase
          .from('reading_sessions')
          .select()
          .eq('user_id', userId);

      if (sessionsResponse.isNotEmpty) {
        for (var item in sessionsResponse) {
          final session = ReadingSession()
            ..id = item['id']
            ..bookId = item['book_id']
            ..startTime = DateTime.parse(item['start_time'])
            ..endTime = item['end_time'] != null ? DateTime.parse(item['end_time']) : null
            ..durationSeconds = item['duration_seconds'] ?? 0
            ..startPage = item['start_page'] ?? 0
            ..endPage = item['end_page'] ?? 0
            ..pagesRead = item['pages_read'] ?? 0;

          await isar.readingSessions.put(session);
        }
      }

      // 4. Restaurar Notas (Notes)
      final notesResponse = await _supabase
          .from('notes')
          .select()
          .eq('user_id', userId);

      if (notesResponse.isNotEmpty) {
        for (var item in notesResponse) {
          final note = Note()
            ..id = item['id']
            ..bookId = item['book_id']
            ..category = item['category'] ?? ''
            ..page = item['page'] ?? 0
            ..content = item['content'] ?? ''
            ..createdAt = item['created_at'] != null ? DateTime.parse(item['created_at']) : DateTime.now();

          await isar.notes.put(note);
        }
      }

      // 5. Restaurar Rachas y Calendario (UserStreak)
      final streakResponse = await _supabase
          .from('user_streaks')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (streakResponse != null) {
        final streak = await isar.userStreaks.get(1) ?? UserStreak();
        streak.id = 1;
        streak.currentStreak = streakResponse['current_streak'] ?? 0;
        streak.bestStreak = streakResponse['best_streak'] ?? 0;
        streak.lastReadingDate = streakResponse['last_reading_date'] != null 
            ? DateTime.parse(streakResponse['last_reading_date']) 
            : null;
        
        final rawDays = streakResponse['reading_days'] as List<dynamic>?;
        if (rawDays != null) {
          streak.readingDays = rawDays.map((d) => DateTime.parse(d.toString())).toList();
        }

        await isar.userStreaks.put(streak);
      }
    });
  }
}