import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract class DateHelper {
  static Locale? _locale;

  static init(BuildContext context) {
    _locale = Localizations.localeOf(context);
  }

  static String getFormatedDate(DateTime date) {
    return DateFormat.yMMMMd(_locale.toString()).format(date);
  }

  static String getShortFormatedDate(DateTime date) {
    final day = DateFormat.d(_locale.toString()).format(date);

    final month = DateFormat.MMMM(_locale.toString()).format(date);
    final monthShort = month.substring(0, 3);
    final year = DateFormat.y(_locale.toString()).format(date);

    return '$day $monthShort $year';
  }

  static String getShortFormatedDateWithTime(DateTime date) {
    final day = DateFormat.d(_locale.toString()).format(date);
    final month =
        DateFormat.MMMM(_locale.toString()).format(date).substring(0, 3);
    final year = DateFormat.y(_locale.toString()).format(date);

    final time = DateFormat.Hm(_locale.toString()).format(date);

    return '$day $month $year, $time';
  }
}
