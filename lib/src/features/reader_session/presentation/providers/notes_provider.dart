import 'package:book_sync/src/domain/note.dart';
import 'package:book_sync/src/features/reader_session/presentation/providers/notes_notifier.dart';
import 'package:book_sync/src/features/reading_slider/presentation/providers/books_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider que expone la gestión de notas
final notesNotifierProvider =
    StateNotifierProvider<NotesNotifier, AsyncValue<List<Note>>>((ref) {
  final repository = ref.watch(bookRepositoryProvider);
  return NotesNotifier(repository);
});
