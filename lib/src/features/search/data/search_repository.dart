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

final searchBooksProvider = FutureProvider<List<BookSearchDto>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return [];

  final service = ref.watch(googleBooksServiceProvider);

  // 1. Validamos si es una consulta de código numérico (ISBN) o texto general
  final cleanQuery = query.replaceAll('-', '').trim();
  final isOnlyDigits = RegExp(r'^[0-9]+$').hasMatch(cleanQuery);
  final isIsbn = isOnlyDigits && (cleanQuery.length == 10 || cleanQuery.length == 13);

  if (isIsbn) {
    // 1. Obtener la lista preliminar para rescatar el Volume ID
    final rawList = await service.searchByIsbnRaw(cleanQuery);
    if (rawList.isEmpty) return [];

    final volumeId = rawList.first['id'] as String?;
    if (volumeId != null && volumeId.isNotEmpty) {
      final detailedJson = await service.getVolumeByIdRaw(volumeId);
      if (detailedJson != null) {
        return [BookSearchDto.fromJson(detailedJson)];
      }
    }

    // Fallback si por alguna razón falla la segunda petición
    return rawList.map((item) => BookSearchDto.fromJson(item)).toList();
  }

  // Búsqueda general por texto
  final rawItems = await service.searchBooksRaw(query);
  return rawItems.map((item) => BookSearchDto.fromJson(item)).toList();
});