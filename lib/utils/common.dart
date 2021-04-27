import 'package:intl/intl.dart';

class Common {
  static String cutString(String str, int length) {
    return (str != null && str.length > length
        ? str.substring(0, length) + ' ...'
        : str);
  }

  static String formatDate(DateTime date, String format) {
    var formatter = new DateFormat(format);
    String formattedDate = formatter.format(date);
    return formattedDate;
  }

  static DateTime strToDateTime(String date) {
    return DateTime.parse(date);
  }
}
