// lib/src/features/books/presentation/providers/unrated_books_provider.dart

import 'package:book_sync/src/features/reading_slider/presentation/providers/books_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_sync/src/domain/book.dart';

final unratedBooksNotifierProvider =
    AsyncNotifierProvider<UnratedBooksNotifier, List<Book>>(() {
  return UnratedBooksNotifier();
});

class UnratedBooksNotifier extends AsyncNotifier<List<Book>> {
  @override
  Future<List<Book>> build() async {
    final repository = ref.watch(bookRepositoryProvider);
    return repository.getUnratedFinishedBooks();
  }

  /// Método para re-consultar o actualizar la lista de pendientes
  Future<void> fetchUnratedBooks() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(bookRepositoryProvider);
      return repository.getUnratedFinishedBooks();
    });
  }

  /// Guarda la calificación y conclusiones de un libro terminado
  Future<void> submitRatingAndConclusions({
    required int bookId,
    required double rating,
    required String conclusions,
  }) async {
    final repository = ref.read(bookRepositoryProvider);
    await repository.updateBookRatingAndConclusions(
      bookId: bookId,
      rating: rating,
      conclusions: conclusions,
    );
    // Refrescamos la lista tras actualizar
    await fetchUnratedBooks();
  }
}