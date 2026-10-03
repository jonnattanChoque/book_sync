import 'package:intl/intl.dart';

class DateFormatter {
  static String getHomeDate(DateTime date) {
    return DateFormat('dd MMM').format(date).toUpperCase();
  }

  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}