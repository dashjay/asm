import 'package:intl/intl.dart';

import '../../domain/models/enums.dart';

final _currencyFormat = NumberFormat('#,##0.##');
final _dateFormat = DateFormat('yyyy-MM-dd');
final _dateTimeFormat = DateFormat('yyyy-MM-dd HH:mm');

String formatMoney(double amount, Currency currency) {
  final prefix = currency.symbol;
  final formatted = _currencyFormat.format(amount);
  return '$prefix$formatted';
}

String formatSignedMoney(double amount, Currency currency) {
  final sign = amount >= 0 ? '+' : '';
  return '$sign${formatMoney(amount, currency)}';
}

String formatDate(DateTime date) => _dateFormat.format(date);
String formatDateTime(DateTime date) => _dateTimeFormat.format(date);

String formatPercent(double? value) {
  if (value == null) return '-';
  return '${value >= 0 ? '+' : ''}${value.toStringAsFixed(1)}%';
}
