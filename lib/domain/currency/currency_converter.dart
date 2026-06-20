import '../models/enums.dart';

/// Cross rates keyed by "FROM_TO", e.g. "usd_cny" => 7.25 means 1 USD = 7.25 CNY.
class CurrencyConverter {
  CurrencyConverter(this._rates);

  final Map<String, double> _rates;

  factory CurrencyConverter.fromUsdRates({
    required double usdToCny,
    required double usdToSgd,
  }) {
    return CurrencyConverter({
      'usd_cny': usdToCny,
      'usd_sgd': usdToSgd,
      'cny_usd': 1 / usdToCny,
      'sgd_usd': 1 / usdToSgd,
      'cny_sgd': usdToSgd / usdToCny,
      'sgd_cny': usdToCny / usdToSgd,
    });
  }

  factory CurrencyConverter.fromRateRows(
    List<({String from, String to, double rate})> rows,
  ) {
    final map = <String, double>{};
    for (final row in rows) {
      map['${row.from}_${row.to}'] = row.rate;
    }

    final usdToCny = map['usd_cny'];
    final usdToSgd = map['usd_sgd'];
    if (usdToCny != null && usdToSgd != null) {
      return CurrencyConverter.fromUsdRates(
        usdToCny: usdToCny,
        usdToSgd: usdToSgd,
      );
    }

    return CurrencyConverter(map);
  }

  double convert({
    required double amount,
    required Currency from,
    required Currency to,
  }) {
    if (from == to) return amount;
    final key = '${from.name}_${to.name}';
    final rate = _rates[key];
    if (rate == null) {
      throw StateError('Missing rate for $key');
    }
    return amount * rate;
  }

  double? rateBetween(Currency from, Currency to) {
    if (from == to) return 1;
    return _rates['${from.name}_${to.name}'];
  }

  double get usdToCny => _rates['usd_cny'] ?? 7.25;
  double get usdToSgd => _rates['usd_sgd'] ?? 1.35;
}
