import 'package:book_sync/src/features/search/data/image_books_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider del servicio
final imageSearchServiceProvider = Provider<ImageSearchService>((ref) {
  return ImageSearchService();
});

// Notifier para el query de búsqueda de imágenes
class ImageSearchQueryNotifier extends StateNotifier<String> {
  ImageSearchQueryNotifier() : super('');

  void submitQuery(String query) {
    state = query.trim();
  }

  void clearSearch() {
    state = '';
  }
}

// Provider de estado del query
final imageSearchQueryProvider =
    StateNotifierProvider.autoDispose<ImageSearchQueryNotifier, String>((ref) {
  return ImageSearchQueryNotifier();
});

// Provider asíncrono para obtener las URLs de las portadas
final searchImageCoversProvider = FutureProvider.autoDispose<List<String>>((ref) async {
  final query = ref.watch(imageSearchQueryProvider);
  if (query.trim().isEmpty) return [];

  final service = ref.watch(imageSearchServiceProvider);
  return await service.searchBookCovers(query);
});