import 'package:book_sync/src/domain/book.dart';

List<Book> sortBooksByLastAdded(List<Book> books) {
  final sortedList = List<Book>.from(books);

  sortedList.sort((a, b) {
    // Si tu modelo tiene createdAt (DateTime)
    if (a.startedAt != null && b.startedAt != null) {
      return b.startedAt!.compareTo(a.startedAt!);
    }
    
    // Si no tiene createdAt, ordenamos por ID de forma descendente (los más altos son los más recientes)
    return b.id.compareTo(a.id);
  });

  return sortedList;
}