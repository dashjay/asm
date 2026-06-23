import '../models/enums.dart';
import 'fx_defaults.dart';

/// Converts amounts between [Currency] values using a snapshot of cross rates.
///
/// Rates are keyed by `"from_to"`, e.g. `"usd_cny" => 7.25` means 1 USD = 7.25
/// CNY. The converter is immutable: it represents the rates at a single point
/// in time so historical calculations stay reproducible.
///
/// USD is the pivot currency. We only ever capture/persist `USD -> X` rates and
/// derive the full cross-rate matrix from them, so adding a currency never
/// changes the conversion logic.
class CurrencyConverter {
  CurrencyConverter(this._rates);

  final Map<String, double> _rates;

  /// Builds a fully-populated converter from `USD -> X` rates.
  ///
  /// [usdRates] maps each non-USD [Currency] to "units of that currency per 1
  /// USD" (e.g. `{Currency.cny: 7.25}`). USD is implied with a rate of 1. Every
  /// cross rate is derived through USD so the matrix is always complete.
  factory CurrencyConverter.fromUsdRates(Map<Currency, double> usdRates) {
    // Anchor USD at 1 so the double loop below also yields the USD pairs.
    final perUsd = <Currency, double>{Currency.usd: 1.0, ...usdRates};

    final map = <String, double>{};
    for (final from in perUsd.keys) {
      for (final to in perUsd.keys) {
        if (from == to) continue;
        // 1 `from` = (1 / perUsd[from]) USD = perUsd[to] / perUsd[from] `to`.
        map['${from.name}_${to.name}'] = perUsd[to]! / perUsd[from]!;
      }
    }
    return CurrencyConverter(map);
  }

  /// Builds a converter from stored rate rows.
  ///
  /// Reads the `USD -> X` rows and re-derives the full cross-rate matrix. Any
  /// supported currency missing from the rows (e.g. an older snapshot taken
  /// before that currency was added) falls back to [defaultUsdRate], so
  /// conversion never throws a missing-rate error.
  factory CurrencyConverter.fromRateRows(
    List<({String from, String to, double rate})> rows,
  ) {
    final usdRates = <Currency, double>{};
    for (final row in rows) {
      if (row.from != Currency.usd.name) continue;
      final target =
          Currency.values.where((c) => c.name == row.to).firstOrNull;
      if (target != null && target != Currency.usd) {
        usdRates[target] = row.rate;
      }
    }

    final full = <Currency, double>{
      for (final c in Currency.values)
        if (c != Currency.usd) c: usdRates[c] ?? defaultUsdRate(c),
    };
    return CurrencyConverter.fromUsdRates(full);
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

  /// The `USD -> currency` rate (1.0 for USD), falling back to the default when
  /// not present in this snapshot.
  double usdRate(Currency currency) =>
      rateBetween(Currency.usd, currency) ?? defaultUsdRate(currency);
}
