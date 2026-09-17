import 'package:isar/isar.dart';

part 'book.g.dart'; 

@collection
class Book {
  Id id = Isar.autoIncrement;

  late String title;
  late String author;
  String? coverPath;
  int? totalPages;
  int currentPage = 0;
  double progress = 0.0;

  // Nuevos campos para coincidir con BookDetailScreen / BookSearchDto
  String? isbn;
  String? language;
  String? description;
  String? publisher;
  String? publishedDate;
  List<String>? categories;

  @enumerated
  BookStatus status = BookStatus.toRead;

  final sessions = IsarLinks<ReadingSession>();

  Book({
    this.title = '',
    this.author = '',
    this.progress = 0.0,
    this.status = BookStatus.toRead,
    this.coverPath,
    this.totalPages,
    this.currentPage = 0,
    this.isbn,
    this.language,
    this.description,
    this.publisher,
    this.publishedDate,
    this.categories,
  });

  Book.empty(); 
}

enum BookStatus { reading, toRead, paused, dropped, finished }

@collection
class ReadingSession {
  Id id = Isar.autoIncrement;

  late DateTime date;
  late int minutesRead;
  late int endPage;
  int? startPage;
  
  String? note;
  @Backlink(to: 'sessions')
  final book = IsarLink<Book>();
}