import 'package:book_sync/core/persistence/isar_provider.dart';
import 'package:book_sync/src/data/book_repository.dart';
import 'package:book_sync/src/domain/book.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

// Proveedor del repositorio
final bookRepositoryProvider = Provider<BookRepository>((ref) {
  final isar = ref.watch(isarProvider);
  return BookRepository(isar);
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