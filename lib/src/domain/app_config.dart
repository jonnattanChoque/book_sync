import 'package:isar/isar.dart';

part 'app_config.g.dart'; 

@collection
class AppConfig {
  Id id = Isar.autoIncrement;
  String? lastBookmarkAnimDate;
  String? dailyQuoteText;
  String? dailyQuoteAuthor;
}