import 'dart:async';
import 'package:book_sync/core/domain/entities/app_settings_stat.dart';
import 'package:book_sync/core/providers/app_settings_provider.dart';
import 'package:book_sync/src/data/book_repository.dart';
import 'package:book_sync/src/domain/book.dart';
import 'package:book_sync/src/features/reading_slider/presentation/providers/books_provider.dart';
import 'package:book_sync/src/features/stats/domain/models/category_stat.dart';
import 'package:book_sync/src/features/stats/domain/models/monthly_book_stat.dart';
import 'package:book_sync/src/features/stats/domain/models/monthly_reading_time_stat.dart';
import 'package:book_sync/src/features/stats/domain/models/star_rating_stat.dart';
import 'package:book_sync/src/features/stats/domain/models/stats_stat.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatsNotifier extends StateNotifier<StatsState> {
  final Ref _ref;
  final BookRepository _repository;
  StreamSubscription<List<Book>>? _booksSubscription;

  StatsNotifier(this._ref, this._repository) : super(StatsState()) {
    _initSubscription();
  }

  void _initSubscription() {
    state = state.copyWith(isLoading: true);

    _booksSubscription = _repository.watchAllBooks().listen((books) async {
      await _calculateStats(books);
    });

    _ref.listen<AppSettings>(appSettingsProvider, (previous, next) {
      if (previous?.yearlyGoalBooks != next.yearlyGoalBooks ||
          previous?.weeklyGoalHours != next.weeklyGoalHours) {
        
        final annualGoal = next.yearlyGoalBooks;
        final progress = annualGoal > 0
            ? (state.finishedBooksYear / annualGoal).clamp(0.0, 1.0)
            : 0.0;

        state = state.copyWith(
          annualGoal: annualGoal,
          weeklyHoursGoal: next.weeklyGoalHours,
          goalProgressPercentage: progress,
        );
      }
    });
  }

  Future<void> loadStats() async {
    final books = await _repository.watchAllBooks().first;
    await _calculateStats(books);
  }

  Future<void> _calculateStats(List<Book> books) async {
    // 1. Asegurar la carga de sesiones asíncronas
    await _ensureSessionsLoaded(books);

    final now = DateTime.now();
    final currentSelectedYear = state.selectedYear;

    // 2. Leer las configuraciones globales actuales de objetivos
    final settings = _ref.read(appSettingsProvider);
    final annualGoal = settings.yearlyGoalBooks;
    final weeklyHoursGoal = settings.weeklyGoalHours;

    // 3. Extraer datos mediante funciones con responsabilidad única
    final availableYears = _getAvailableYears(books, now.year);
    final yearMetrics = _calculateYearlyMetrics(books, currentSelectedYear);
    final weeklyHoursRead = 2.0;//_calculateCurrentWeeklyHours(books);

    final int monthsToDivide = (currentSelectedYear == now.year) ? now.month : 12;
    final double monthlyBooksAvg = yearMetrics.finishedBooks / monthsToDivide;

    final double yearlyHours = yearMetrics.totalSeconds / 3600.0;
    final double pagesPerHour = yearlyHours > 0 ? (yearMetrics.totalPages / yearlyHours) : 0.0;

    await Future.delayed(const Duration(seconds: 1));

    state = state.copyWith(
      availableYears: availableYears,
      monthlyBooksAvg: monthlyBooksAvg,
      pagesPerHour: pagesPerHour,
      totalMinutesReadYear: (yearMetrics.totalSeconds / 60).round(),
      totalPagesReadYear: yearMetrics.totalPages,
      finishedBooksYear: yearMetrics.finishedBooks,
      weeklyHoursRead: weeklyHoursRead,
      annualGoal: annualGoal,
      weeklyHoursGoal: weeklyHoursGoal,
      monthlyBooksChartData: _calculateMonthlyBooks(books, currentSelectedYear),
      monthlyReadingTimeChartData: _calculateMonthlyReadingTime(books, currentSelectedYear),
      starRatingChartData: _calculateStarRatings(books, currentSelectedYear),
      categoryChartData: _calculateCategoryStats(books, currentSelectedYear),
      isLoading: false,
    );
  }

  // ============================================================================
  // FUNCIONES CON RESPONSABILIDAD ÚNICA (HELPER METHODS)
  // ============================================================================

  /// Asegura que todas las sesiones en las relaciones de Isar estén cargadas
  Future<void> _ensureSessionsLoaded(List<Book> books) async {
    for (final book in books) {
      if (!book.sessions.isLoaded) {
        await book.sessions.load();
      }
    }
  }

  /// Obtiene y ordena la lista de años disponibles
  List<int> _getAvailableYears(List<Book> books, int currentYear) {
    const int startYear = 2020;
    final int totalYears = currentYear - startYear + 1;

    final Set<int> yearSet = List.generate(
      totalYears > 0 ? totalYears : 1, 
      (index) => startYear + index,
    ).toSet();

    for (final book in books) {
      for (final session in book.sessions) {
        yearSet.add(session.startTime.year);
      }
    }

    return yearSet.toList()..sort();
  }

  /// Agrupa las métricas crudas acumuladas del año seleccionado
  ({int finishedBooks, int totalSeconds, int totalPages}) _calculateYearlyMetrics(
    List<Book> books, 
    int selectedYear,
  ) {
    int finishedBooks = 0;
    int totalSeconds = 0;
    int totalPages = 0;

    for (final book in books) {
      // Libros terminados en el año seleccionado
      if (book.status == BookStatus.finished && book.sessions.isNotEmpty) {
        final sortedSessions = book.sessions.toList()
          ..sort((a, b) => a.startTime.compareTo(b.startTime));
        if (sortedSessions.last.startTime.year == selectedYear) {
          finishedBooks++;
        }
      }

      // Acumulado de tiempo y páginas
      for (final session in book.sessions) {
        if (session.startTime.year == selectedYear) {
          totalSeconds += session.durationSeconds;
          totalPages += session.pagesRead;
        }
      }
    }

    return (
      finishedBooks: finishedBooks, 
      totalSeconds: totalSeconds, 
      totalPages: totalPages,
    );
  }

  /// Calcula las horas leídas en la semana en curso (de domingo a sábado)
  double _calculateCurrentWeeklyHours(List<Book> books) {
    final now = DateTime.now();
    
    // En Dart, weekday es 1 (lunes) a 7 (domingo). 
    // Calculamos la fecha del domingo de inicio de esta semana:
    final daysSinceSunday = now.weekday % 7;
    final startOfWeek = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: daysSinceSunday));
    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    int totalSecondsThisWeek = 0;

    for (final book in books) {
      for (final session in book.sessions) {
        final sessionDate = session.startTime;
        if (sessionDate.isAfter(startOfWeek) && sessionDate.isBefore(endOfWeek)) {
          totalSecondsThisWeek += session.durationSeconds;
        }
      }
    }

    return totalSecondsThisWeek / 3600.0;
  }
  List<MonthlyBookStat> _calculateMonthlyBooks(List<Book> books, int currentYear) {
    // Inicializamos los 12 meses en 0
    final List<int> monthCounts = List.filled(12, 0);
    final monthLabels = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];

    for (final book in books) {
      if (book.status == BookStatus.finished && book.sessions.isNotEmpty) {
        final sortedSessions = book.sessions.toList()
          ..sort((a, b) => a.startTime.compareTo(b.startTime));
        
        final lastSessionDate = sortedSessions.last.startTime;

        if (lastSessionDate.year == currentYear) {
          // month index va de 0 a 11
          final monthIndex = lastSessionDate.month - 1;
          monthCounts[monthIndex]++;
        }
      }
    }

    return List.generate(12, (index) {
      return MonthlyBookStat(
        monthLabel: monthLabels[index],
        bookCount: monthCounts[index],
      );
    });
  }

  List<MonthlyReadingTimeStat> _calculateMonthlyReadingTime(List<Book> books, int selectedYear) {
    final List<int> monthMinutes = List.filled(12, 0);
    final List<int> monthPages = List.filled(12, 0);

    // Nombres de los meses abreviados (puedes adaptarlo según tus Helpers de fecha)
    final monthLabels = [
      'Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun',
      'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'
    ];

    for (final book in books) {
      for (final session in book.sessions) {
        if (session.startTime.year == selectedYear) {
          final monthIndex = session.startTime.month - 1;
          monthMinutes[monthIndex] += (session.durationSeconds / 60).round();
          monthPages[monthIndex] += session.pagesRead;
        }
      }
    }

    return List.generate(12, (index) {
      return MonthlyReadingTimeStat(
        monthLabel: monthLabels[index],
        totalMinutes: monthMinutes[index],
        totalPages: monthPages[index],
      );
    });
  }
  
  /// Calcula la cantidad de libros terminados por calificación de 1 a 5 estrellas
  List<StarRatingStat> _calculateStarRatings(List<Book> books, int selectedYear) {
    final Map<int, List<String>> ratingBooks = {
      1: [],
      2: [],
      3: [],
      4: [],
      5: [],
    };

    for (final book in books) {
      if (book.status == BookStatus.finished && book.sessions.isNotEmpty) {
        final sortedSessions = book.sessions.toList()
          ..sort((a, b) => a.startTime.compareTo(b.startTime));

        final lastSessionYear = sortedSessions.last.startTime.year;

        if (lastSessionYear == selectedYear && book.rating != null) {
          final roundedRating = book.rating!.round();

          if (roundedRating >= 1 && roundedRating <= 5) {
            ratingBooks[roundedRating]?.add(book.title);
          }
        }
      }
    }

    return List.generate(5, (index) {
      final star = index + 1;
      final titles = ratingBooks[star] ?? [];
      return StarRatingStat(
        rating: star,
        bookCount: titles.length,
        bookTitles: titles,
      );
    });
  }

  /// Calcula la distribución de libros terminados en el año por categoría/género
  List<CategoryStat> _calculateCategoryStats(List<Book> books, int selectedYear) {
    final Map<String, List<String>> categoryBooks = {};

    for (final book in books) {
      if (book.status == BookStatus.finished && book.sessions.isNotEmpty) {
        final sortedSessions = book.sessions.toList()
          ..sort((a, b) => a.startTime.compareTo(b.startTime));

        final lastSessionYear = sortedSessions.last.startTime.year;

        if (lastSessionYear == selectedYear) {
          // Si no tiene categorías o la lista está vacía
          if (book.categories == null || book.categories!.isEmpty) {
            categoryBooks.putIfAbsent('Sin categoría', () => []).add(book.title);
          } else {
            // Iteramos sobre la lista de categorías del libro
            for (final rawCategory in book.categories!) {
              final category = rawCategory.trim();
              if (category.isNotEmpty) {
                final list = categoryBooks.putIfAbsent(category, () => []);
                // Evitamos duplicar el título si el arreglo de categorías viniera con repetidos
                if (!list.contains(book.title)) {
                  list.add(book.title);
                }
              }
            }
          }
        }
      }
    }

    // Convertimos el mapa a la lista DTO y ordenamos de mayor a menor
    final statsList = categoryBooks.entries.map((entry) {
      return CategoryStat(
        categoryName: entry.key,
        bookCount: entry.value.length,
        bookTitles: entry.value,
      );
    }).toList();

    statsList.sort((a, b) => b.bookCount.compareTo(a.bookCount));

    return statsList;
  }

  void changeYear(int year) {
    if (state.selectedYear == year) return;
    state = state.copyWith(selectedYear: year, isLoading: true);
    _recalculateWithCurrentBooks();
  }

  void _recalculateWithCurrentBooks() async {
    final books = await _repository.watchAllBooks().first;
    await _calculateStats(books);
  }
  
  @override
  void dispose() {
    _booksSubscription?.cancel();
    super.dispose();
  }
}

final statsProvider = StateNotifierProvider<StatsNotifier, StatsState>((ref) {
  final repository = ref.watch(bookRepositoryProvider);
  return StatsNotifier(ref, repository);
});