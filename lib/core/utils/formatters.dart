import 'package:intl/intl.dart';

import '../../domain/models/enums.dart';

String formatMoney(double amount, Currency currency, [String? locale]) {
  final prefix = currency.symbol;
  final formatted = NumberFormat('#,##0.##', locale).format(amount);
  return '$prefix$formatted';
}

String formatSignedMoney(double amount, Currency currency, [String? locale]) {
  final sign = amount >= 0 ? '+' : '';
  return '$sign${formatMoney(amount, currency, locale)}';
}

String formatDate(DateTime date, [String? locale]) =>
    DateFormat.yMd(locale).format(date);

String formatShortDate(DateTime date, [String? locale]) =>
    DateFormat('M/d', locale).format(date);

String formatMonthYear(DateTime date, [String? locale]) =>
    DateFormat('M/yy', locale).format(date);

String formatAxisMoney(double amount, Currency currency, [String? locale]) {
  final prefix = currency.symbol;
  final abs = amount.abs();
  if (abs >= 1000000) {
    return '$prefix${NumberFormat('#,##0.##', locale).format(amount / 1000000)}M';
  }
  if (abs >= 1000) {
    return '$prefix${NumberFormat('#,##0', locale).format(amount.round())}';
  }
  return formatMoney(amount, currency, locale);
}

String formatDateTime(DateTime date, [String? locale]) =>
    DateFormat.yMd(locale).add_Hm().format(date);

String formatPercent(double? value) {
  if (value == null) return '-';
  return '${value >= 0 ? '+' : ''}${value.toStringAsFixed(1)}%';
}
