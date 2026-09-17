import 'package:book_sync/src/domain/book.dart';
import 'package:isar/isar.dart';

class BookRepository {
  final Isar isar;

  BookRepository(this.isar);

  // Escucha en tiempo real los libros que se están leyendo actualmente
  Stream<List<Book>> watchBooksReading() {
    return isar.books
        .filter()
        .statusEqualTo(BookStatus.reading)
        .watch(fireImmediately: true);
  }

  Stream<List<Book>> watchAllBooks() {
    return isar.books.where().watch(fireImmediately: true);
  }

  Future<Id> saveBookFromForm({
    required String title,
    required String author,
    BookStatus status = BookStatus.toRead,
    String? coverPath,
    int? totalPages,
    String? isbn,
    String? language,
    String? description,
    String? publisher,
    String? publishedDate,
    List<String>? categories,
  }) async {
    final book = Book(
      title: title,
      author: author,
      coverPath: coverPath,
      totalPages: totalPages,
      currentPage: 0,
      progress: 0.0,
      status: status,
      isbn: isbn,
      language: language,
      description: description,
      publisher: publisher,
      publishedDate: publishedDate,
      categories: categories,
    );

    return await isar.writeTxn(() async {
      return await isar.books.put(book);
    });
  }

  /// Elimina un libro de Isar según su ID
  Future<bool> deleteBook(Id bookId) async {
    return await isar.writeTxn(() async {
      return await isar.books.delete(bookId);
    });
  }

  Future<void> clearAllBooks() async {
    await isar.writeTxn(() async {
      await isar.books.clear();
    });
  }
}