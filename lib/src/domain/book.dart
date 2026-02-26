import 'package:isar/isar.dart';

part 'book.g.dart'; 

@collection
class Book {
  Id id = Isar.autoIncrement;

  late String title;
  late String author;
  String? coverPath;
  int? totalPages;
  double progress = 0.0;

  @enumerated
  BookStatus status = BookStatus.toRead;

  final sessions = IsarLinks<ReadingSession>();

  Book({
    required this.title,
    required this.author,
    this.progress = 0.0,
    this.status = BookStatus.toRead,
    this.coverPath,
    this.totalPages,
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