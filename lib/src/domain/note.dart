
import 'package:isar/isar.dart';

part 'note.g.dart'; 

@collection
class Note {
  Id id = Isar.autoIncrement;

  @Index()
  late int bookId;

  late String category;
  late int page;
  late String content;
  late DateTime createdAt;

  Note();

  Note.create({
    required this.bookId,
    required this.category,
    required this.page,
    required this.content,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}