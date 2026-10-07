import 'package:book_sync/core/persistence/isar_provider.dart';
import 'package:book_sync/core/providers/app_settings_provider.dart';
import 'package:book_sync/src/data/book_repository.dart';
import 'package:book_sync/src/domain/book.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

// Proveedor del repositorio
final bookRepositoryProvider = Provider<BookRepository>((ref) {
  final isar = ref.watch(isarProvider);
  final settings = ref.watch(appSettingsProvider);
  final currentUserId = settings.userId;
  return BookRepository(isar, currentUserId: currentUserId);
});

// Proveedor que emite la lista dinámica de libros en curso
final currentlyReadingProvider = StreamProvider<List<Book>>((ref) {
  final repository = ref.watch(bookRepositoryProvider);
  return repository.watchBooksReading();
});

final allBooksProvider = StreamProvider<List<Book>>((ref) {
  final repository = ref.watch(bookRepositoryProvider);
  return repository.watchAllBooks();
});

// Proveedor para comunicar el libro recién guardado hacia el carrusel del Home
final selectedBookIdProvider = StateProvider<Id?>((ref) => null);

final checkDuplicateIsbnProvider = Provider((ref) {
  final repository = ref.watch(bookRepositoryProvider);

  return (String? isbn) async {
    if (isbn == null || isbn.trim().isEmpty) return null;
    return await repository.findBookByIsbn(isbn);
  };
});
