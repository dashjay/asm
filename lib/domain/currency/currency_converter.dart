import '../models/enums.dart';
import 'fx_defaults.dart';

/// Converts amounts between [Currency] values using a snapshot of cross rates.
///
/// Rates are keyed by `"from_to"`, e.g. `"usd_cny" => 7.25` means 1 USD = 7.25
/// CNY. The converter is immutable: it represents the rates at a single point
/// in time so historical calculations stay reproducible.
class CurrencyConverter {
  CurrencyConverter(this._rates);

  final Map<String, double> _rates;

  /// Builds a fully-populated converter from the two rates we actually capture
  /// (USD->CNY and USD->SGD), deriving every other direction from them.
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

  /// Builds a converter from stored rate rows. When both USD pairs are present
  /// we re-derive the full cross-rate matrix so partial data never produces a
  /// missing-rate error at conversion time.
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

  double get usdToCny => _rates['usd_cny'] ?? kDefaultUsdToCny;
  double get usdToSgd => _rates['usd_sgd'] ?? kDefaultUsdToSgd;
}
