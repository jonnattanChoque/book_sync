class StarRatingStat {
  final int rating; // 1 a 5
  final int bookCount;
  final List<String> bookTitles; // <--- Nueva propiedad

  const StarRatingStat({
    required this.rating,
    required this.bookCount,
    this.bookTitles = const [],
  });
}