import 'package:book_sync/src/domain/book.dart';
import 'package:book_sync/src/domain/note.dart';
import 'package:isar/isar.dart';

class BookRepository {
  final Isar isar;

  BookRepository(this.isar);

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
    DateTime? startedAt,
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
      startedAt: startedAt,
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

  Future<Book?> findBookByIsbn(String isbn) async {
    final cleanIsbn = isbn.replaceAll(RegExp(r'[\s-]'), '');
    if (cleanIsbn.isEmpty) return null;

    return await isar.books
        .filter()
        .isbnEqualTo(cleanIsbn)
        .findFirst();
  }

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

  Future<void> updateBookStatus(Id bookId, BookStatus newStatus) async {
    await isar.writeTxn(() async {
      final book = await isar.books.get(bookId);
      if (book != null) {
        book.status = newStatus;
        await isar.books.put(book);
      }
    });
  }

  Future<void> updateBookFavorite(Id bookId, bool isFavorite) async {
    await isar.writeTxn(() async {
      final book = await isar.books.get(bookId);
      if (book != null) {
        book.isFavorite = isFavorite;
        await isar.books.put(book);
      }
    });
  }

  Future<void> addNote(Note note) async {
    await isar.writeTxn(() async {
      await isar.notes.put(note);
      final totalNotes = await isar.notes
        .filter()
        .bookIdEqualTo(note.bookId)
        .count();

      // 3. Actualizar el libro con el total exacto
      final book = await isar.books.get(note.bookId);
      if (book != null) {
        book.notesCount = totalNotes;
        await isar.books.put(book);
      }
    });
  }

  Future<List<Note>> getNotesByBookId(int bookId) async {
    return await isar.notes
      .filter()
      .bookIdEqualTo(bookId)
      .sortByCreatedAtDesc()
      .findAll();
  } 

  // En tu repositorio o servicio de Isar (e.g., ReadingRepository):
  Future<({Book book, ReadingSession session})?> saveReadingSession({
    required int bookId,
    required int startPage,
    required int endPage,
    required Duration duration,
  }) async {
    final now = DateTime.now();
    final pagesRead = endPage > startPage ? endPage - startPage : 0;

    final session = ReadingSession()
      ..bookId = bookId
      ..startPage = startPage
      ..endPage = endPage
      ..pagesRead = pagesRead
      ..durationSeconds = duration.inSeconds
      ..startTime = now;

    Book? updatedBook;

    await isar.writeTxn(() async {
      // 1. Guardar el registro de la sesión en su colección
      await isar.readingSessions.put(session);

      // 2. Obtener y actualizar el libro
      updatedBook = await isar.books.get(bookId);
      if (updatedBook != null) {
        final totalPages = updatedBook!.totalPages ?? 0;

        // Actualizar página, progreso y estado
        updatedBook!.currentPage = endPage;
        if (totalPages > 0) {
          updatedBook!.progress = (endPage / totalPages).clamp(0.0, 1.0);
          if (endPage >= totalPages) {
            updatedBook!.status = BookStatus.finished;
          } else {
            updatedBook!.status = BookStatus.reading;
          }
        }

        await isar.books.put(updatedBook!);

        // 3. Vincular la sesión al enlace de Isar y guardar el vínculo
        updatedBook!.sessions.add(session);
        await updatedBook!.sessions.save();
      }
    });

    if (updatedBook == null) return null;

    return (book: updatedBook!, session: session);
  }

  Future<void> updateBookRatingAndConclusions({
    required int bookId,
    required double rating,
    required String conclusions,
  }) async {
    await isar.writeTxn(() async {
      final book = await isar.books.get(bookId);
      if (book != null) {
        book.rating = rating;
        book.conclusions = conclusions;
        await isar.books.put(book);
      }
    });
  }

  Future<List<Book>> getUnratedFinishedBooks() async {
    return await isar.books
    .filter()
    .statusEqualTo(BookStatus.finished)
    .group((q) => q.ratingIsNull().or().ratingEqualTo(0))
    .findAll();
  }
}