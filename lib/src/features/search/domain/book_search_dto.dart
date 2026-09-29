class BookSearchDto {
  final String id;
  final String title;
  final List<String> authors;
  final String? coverUrl;
  final String? description;
  final String? isbn;
  final String? publisher;
  final String? publishedDate;
  final String? language;
  final int? pageCount;
  final List<String> categories;
  final double? averageRating;
  final int? ratingsCount;
  final String? previewLink;
  final bool isEbook;

  const BookSearchDto({
    required this.id,
    required this.title,
    required this.authors,
    this.coverUrl,
    this.description,
    this.isbn,
    this.publisher,
    this.publishedDate,
    this.language,
    this.pageCount,
    this.categories = const [],
    this.averageRating,
    this.ratingsCount,
    this.previewLink,
    this.isEbook = false,
  });

  factory BookSearchDto.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] as Map<String, dynamic>? ?? {};
    final saleInfo = json['saleInfo'] as Map<String, dynamic>? ?? {};
    final imageLinks = volumeInfo['imageLinks'] as Map<String, dynamic>?;

    // Extracción limpia del ISBN (prioriza ISBN_13, luego ISBN_10)
    String? extractedIsbn;
    final identifiers = volumeInfo['industryIdentifiers'] as List<dynamic>?;
    if (identifiers != null) {
      for (final item in identifiers) {
        if (item is Map<String, dynamic>) {
          if (item['type'] == 'ISBN_13') {
            extractedIsbn = item['identifier'] as String?;
            break;
          } else if (item['type'] == 'ISBN_10') {
            extractedIsbn = item['identifier'] as String?;
          }
        }
      }
    }

    // Aseguramos que las imágenes utilicen HTTPS
    String? rawCover = imageLinks?['thumbnail'] as String? ?? imageLinks?['smallThumbnail'] as String?;
    // 2. Si existe, asegurar protocolo HTTPS
    if (rawCover != null && rawCover.isNotEmpty) {
      if (rawCover.startsWith('http://')) {
        rawCover = rawCover.replaceFirst('http://', 'https://');
      }
    } 
    // 3. Si viene nula o vacía, armar la URL usando el id del volumen de Google Books
    else if (json['id'] != null && (json['id'] as String).isNotEmpty) {
      rawCover = 'https://covers.openlibrary.org/b/isbn/$extractedIsbn-L.jpg?default=false';
    }
    
    return BookSearchDto(
      id: json['id'] as String? ?? '',
      title: volumeInfo['title'] as String? ?? 'Sin título',
      authors: (volumeInfo['authors'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      coverUrl: rawCover,
      description: volumeInfo['description'] as String?,
      isbn: extractedIsbn,
      publisher: volumeInfo['publisher'] as String?,
      publishedDate: volumeInfo['publishedDate'] as String?,
      language: volumeInfo['language'] as String?,
      pageCount: volumeInfo['pageCount'] as int?,
      categories: (volumeInfo['categories'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      averageRating: (volumeInfo['averageRating'] as num?)?.toDouble(),
      ratingsCount: volumeInfo['ratingsCount'] as int?,
      previewLink: volumeInfo['previewLink'] as String?,
      isEbook: saleInfo['isEbook'] as bool? ?? false,
    );
  }
}