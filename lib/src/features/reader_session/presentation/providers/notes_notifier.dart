import 'package:book_sync/src/data/book_repository.dart';
import 'package:book_sync/src/domain/note.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotesNotifier extends StateNotifier<AsyncValue<List<Note>>> {
  final BookRepository _repository;

  NotesNotifier(this._repository) : super(const AsyncValue.loading());

  /// Carga las notas de un libro específico
  Future<void> loadNotes(int bookId) async {
    try {
      state = const AsyncValue.loading();
      final notes = await _repository.getNotesByBookId(bookId);
      state = AsyncValue.data(notes);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> createNote({
    required int bookId,
    required String category,
    required int page,
    required String content,
  }) async {
    try {
      final note = Note.create(
        bookId: bookId,
        category: category,
        page: page,
        content: content,
      );

      await _repository.addNote(note);
      await loadNotes(bookId);
      return true;
    } catch (e) {
      return false;
    }
  }
}