import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleBooksService {
  final http.Client _client;
  static const String _apiKey = 'AIzaSyDV0-NSOq-mb_vmWGOvCTeLcpt5ZFL_s2Y';
  GoogleBooksService({http.Client? client}) : _client = client ?? http.Client();

  /// Método preliminar para inspeccionar los datos reales retornados por Google Books
  Future<List<Map<String, dynamic>>> searchBooksRaw(String query) async {
    if (query.trim().isEmpty) return [];

    final url = Uri.parse(
      'https://www.googleapis.com/books/v1/volumes?q=${Uri.encodeComponent(query)}&key=$_apiKey&maxResults=20&printType=books',
    );

    try {
      final response = await _client.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final items = data['items'] as List<dynamic>?;

        if (items == null) return [];

        return items.cast<Map<String, dynamic>>();
      } else if (response.statusCode == 429) {
        throw Exception('Demasiadas solicitudes. Intenta de nuevo en unos momentos.');
      } else {
        throw Exception('Error al consultar libros online: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}