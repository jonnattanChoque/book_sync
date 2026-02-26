import 'package:intl/intl.dart';

class DateFormatter {
  static String getHomeDate(DateTime date) {
    return DateFormat('dd MMM').format(date).toUpperCase();
  }
}