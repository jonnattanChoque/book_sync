class Quote {
  final String text;
  final String author;
  final String book;

  Quote({
    required this.text,
    required this.author,
    required this.book,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      text: json['text'] ?? '',
      author: json['author'] ?? 'Anónimo',
      book: json['book'] ?? 'Desconocido',
    );
  }
}