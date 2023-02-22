import 'package:intl/intl.dart';

abstract class MoneyHelper {
  static final _currencyFormat = NumberFormat("#,##0.00", "ru_RU");

  static String format(double value) {
    return _currencyFormat.format(value);
  }
}
