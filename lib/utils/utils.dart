import 'package:intl/intl.dart';

class DateUtils {
  static String formatDate(String date, String toFormat) {
    try {
      return DateFormat(toFormat).format(DateTime.parse(date));
    } catch (Exception) {
      return "";
    }
  }
}

extension DateConversion on String {
  int toMonth() {
    return DateFormat("yyyy-MM-dd").parse(this).month;
  }
}
