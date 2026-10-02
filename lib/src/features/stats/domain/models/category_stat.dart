class CategoryStat {
  final String categoryName;
  final int bookCount;
  final List<String> bookTitles;

  const CategoryStat({
    required this.categoryName,
    required this.bookCount,
    this.bookTitles = const [],
  });
}