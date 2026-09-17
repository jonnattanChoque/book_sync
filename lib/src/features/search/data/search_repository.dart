import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:book_sync/src/features/search/data/google_books_service.dart';
import 'package:book_sync/src/features/search/domain/book_search_dto.dart';

final googleBooksServiceProvider = Provider<GoogleBooksService>((ref) {
  return GoogleBooksService();
});

/// StateNotifier con Debounce para evitar sobrecargar la API (HTTP 429)
class SearchQueryNotifier extends StateNotifier<String> {
  SearchQueryNotifier() : super('');

  // Ya no necesitamos _debounceTimer porque la búsqueda es bajo demanda (manual)

  // Solo guarda el texto localmente mientras se escribe (si lo necesitas para UI)
  // o puedes omitirlo si el TextField maneja su propio TextEditingController.
  void updateQuery(String newQuery) {
    if (newQuery.trim().isEmpty) {
      state = '';
    }
  }

  // Este método se ejecuta exclusivamente al presionar el botón de búsqueda
  void submitQuery(String query) {
    state = query.trim();
  }

  void clearSearch() {
    state = '';
  }
}

// 1. Agregamos .autoDispose para reiniciar el query al salir de la pantalla
final searchQueryProvider =
    StateNotifierProvider.autoDispose<SearchQueryNotifier, String>((ref) {
  return SearchQueryNotifier();
});

// 2. Agregamos .autoDispose para descartar los resultados en caché al salir
final searchBooksProvider =
    FutureProvider.autoDispose<List<BookSearchDto>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return [];

  final service = ref.watch(googleBooksServiceProvider);

  // 1. Solicitamos los JSONs crudos al servicio
  final rawItems = await service.searchBooksRaw(query);

  // 2. Transmutamos la lista cruda a DTOs consumibles por la vista
  return rawItems.map((item) => BookSearchDto.fromJson(item)).toList();
});