import 'package:isar/isar.dart';

part 'book.g.dart'; 

@collection
class Book {
  Id id = Isar.autoIncrement;

  late String title;
  late String author;
  String? coverPath;
  int? totalPages;
  int? notesCount;
  int currentPage = 0;
  double progress = 0.0;
  DateTime? startedAt;

  // Campos complementarios
  String? isbn;
  String? language;
  String? description;
  String? publisher;
  String? publishedDate;
  List<String>? categories;
  bool? isFavorite;
  double? rating;
  String? conclusions;

  @enumerated
  BookStatus status = BookStatus.toRead;

  final sessions = IsarLinks<ReadingSession>();

  Book({
    this.title = '',
    this.author = '',
    this.progress = 0.0,
    this.status = BookStatus.toRead,
    this.coverPath,
    this.totalPages,
    this.notesCount,
    this.currentPage = 0,
    this.startedAt,
    this.isbn,
    this.language,
    this.description,
    this.publisher,
    this.publishedDate,
    this.categories,
    this.isFavorite,
    this.rating,
    this.conclusions
  });

  Book.empty(); 

  // ===========================================================================
  // LOGICA Y CÁLCULOS DERIVADOS (GETTERS)
  // ===========================================================================

  /// Retorna la fecha de la primera sesión registrada o '-' si está vacío
  @ignore
  String get startDateText {
    final date = _effectiveStartDate;
    if (date == null) return '-';
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Retorna el día transcurrido a partir de la fecha de inicio (ej: "Día 1")
  @ignore
  String get readingDayText {
    final date = _effectiveStartDate;
    if (date == null) return '';
    final days = DateTime.now().difference(date).inDays + 1;
    return 'Día $days';
  }

  /// Helper privado para resolver la fecha real
  DateTime? get _effectiveStartDate {
    if (startedAt != null) return startedAt;
    
    if (sessions.isNotEmpty) {
      final sorted = sessions.toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));
      return sorted.first.startTime;
    }
    
    return null;
  }

  /// Retorna el estimado del tiempo restante basado en la velocidad de las sesiones
  @ignore
  String get remainingTimeText {
    if (totalPages == null) return '-';
    
    int totalSeconds = 0;
    int totalPagesRead = 0;

    for (var s in sessions) {
      totalSeconds += s.durationSeconds;
      
      // Calculamos el avance si la página final es mayor que la inicial
      if (s.endPage > s.startPage) {
        totalPagesRead += (s.endPage - s.startPage);
      }
    }

    // Si no hay tiempo o páginas leídas registradas
    if (totalSeconds == 0 || totalPagesRead == 0) return '-';

    // Convertimos a minutos con precisión decimal para evitar perder exactitud en sesiones cortas
    double totalMinutes = totalSeconds / 60.0;
    double pagesPerMinute = totalPagesRead / totalMinutes;
    int remainingPages = totalPages! - currentPage;

    if (remainingPages <= 0) return '0 min';
    if (pagesPerMinute <= 0) return '-';

    double remainingMinutes = remainingPages / pagesPerMinute;
    if (remainingMinutes < 60) {
      return '~${remainingMinutes.round()} min';
    } else {
      return '~${(remainingMinutes / 60).toStringAsFixed(1)} hrs';
    }
  }

  @ignore
  int get remainingPages {
    if (totalPages == null) return 0;
    final remaining = totalPages! - currentPage;
    return remaining > 0 ? remaining : 0;
  }

  @ignore
  double get progressPercentage {
    if (totalPages == null || totalPages == 0) return 0.0;
    return (currentPage / totalPages!).clamp(0.0, 1.0);
  }
}

enum BookStatus { reading, toRead, dropped, finished }

@collection
class ReadingSession {
  Id id = Isar.autoIncrement;
  late int bookId;
  late DateTime startTime;
  DateTime? endTime;
  int durationSeconds = 0;
  int startPage = 0;
  int endPage = 0;
  int pagesRead = 0;

  @ignore
  double get pagesPerHour {
    final hours = durationSeconds / 3600.0;
    if (hours <= 0 || pagesRead <= 0) return 0.0;
    return pagesRead / hours;
  }

  /// Duración formateada en minutos (ej: "29m")
  @ignore
  String get durationFormatted {
    final minutes = (durationSeconds / 60).round();
    return '${minutes}m';
  }

  /// Fecha formateada de inicio de la sesión (ej: "28/9/2026")
  @ignore
  String get formattedDate {
    return '${startTime.day}/${startTime.month}/${startTime.year}';
  }
}