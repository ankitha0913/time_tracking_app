import 'package:intl/intl.dart';

class DateTimeUtil {
  static const yyyy_MM_dd_hh_mm_ss_a = 'yyyy-MM-dd hh:mm:ss a';

  static String formatDate(DateTime dateTime) {
    return DateFormat(yyyy_MM_dd_hh_mm_ss_a).format(dateTime);
  }

  static String formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$secs";
  }

}