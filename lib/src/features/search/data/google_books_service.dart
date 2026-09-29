import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class GoogleBooksService {
  final http.Client _client;
  static const String _apiKey = 'AIzaSyDQ7XZ_5As81luJ4WUhaShj5f1IV9tnS80';

  GoogleBooksService({http.Client? client}) : _client = client ?? http.Client();

  /// Consulta general por texto (Devuelve JSON crudo)
  Future<List<Map<String, dynamic>>> searchBooksRaw(String query) async {
    if (query.trim().isEmpty) return [];

    final url = Uri.parse(
      'https://www.googleapis.com/books/v1/volumes?q=${Uri.encodeComponent(query)}&key=$_apiKey&maxResults=20&printType=books',
    );

    return _fetchRawItems(url);
  }

  /// Consulta por ISBN / Código de barras (Devuelve JSON crudo)
  Future<List<Map<String, dynamic>>> searchByIsbnRaw(String isbn) async {
    final cleanIsbn = isbn.trim();
    if (cleanIsbn.isEmpty) return [];

    final url = Uri.parse(
      'https://www.googleapis.com/books/v1/volumes?q=isbn:${Uri.encodeComponent(cleanIsbn)}&key=$_apiKey&maxResults=1',
    );

    return _fetchRawItems(url);
  }

  Future<List<Map<String, dynamic>>> _fetchRawItems(Uri url) async {
    try {
      final response = await _client.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final items = data['items'] as List<dynamic>?;

        if (items == null) return [];

        return items.cast<Map<String, dynamic>>();
      } else if (response.statusCode == 429) {
        debugPrint('DEBUG API ERROR: Límite de peticiones alcanzado (429).');
        throw Exception('Demasiadas solicitudes. Intenta de nuevo en unos momentos.');
      } else {
        throw Exception('Error al consultar libros online: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('DEBUG API EXCEPCIÓN: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getVolumeByIdRaw(String volumeId) async {
    if (volumeId.trim().isEmpty) return null;

    final url = Uri.parse(
      'https://www.googleapis.com/books/v1/volumes/${Uri.encodeComponent(volumeId)}?key=$_apiKey',
    );

    try {
      final response = await _client.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('DEBUG API EXCEPCIÓN AL OBTENER DETALLE POR ID: $e');
      rethrow;
    }
  }
}