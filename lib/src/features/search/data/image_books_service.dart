import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ImageSearchService {
  Future<List<String>> searchBookCovers(String query) async {
    final url = Uri.parse(
      'https://openlibrary.org/search.json?q=${Uri.encodeComponent(query)}&fields=cover_i&limit=15',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List docs = data['docs'] ?? [];

        // Filtramos solo los que tienen cover_i y armamos la URL directa
        return docs
            .where((doc) => doc['cover_i'] != null)
            .map((doc) => 'https://covers.openlibrary.org/b/id/${doc['cover_i']}-L.jpg')
            .toList();
      }
    } catch (e) {
      debugPrint('Error al buscar portadas: $e');
      rethrow;
    }

    return [];
  }
}