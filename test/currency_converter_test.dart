import 'package:asm/domain/currency/currency_converter.dart';
import 'package:asm/domain/currency/fx_defaults.dart';
import 'package:asm/domain/models/enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CurrencyConverter.fromUsdRates', () {
    final converter = CurrencyConverter.fromUsdRates(const {
      Currency.cny: 7.25,
      Currency.sgd: 1.35,
      Currency.eur: 0.92,
    });

    test('returns the same amount for identical currencies', () {
      expect(
        converter.convert(amount: 100, from: Currency.usd, to: Currency.usd),
        100,
      );
    });

    test('converts USD to each currency using its USD rate', () {
      expect(
        converter.convert(amount: 10, from: Currency.usd, to: Currency.cny),
        closeTo(72.5, 1e-9),
      );
      expect(
        converter.convert(amount: 10, from: Currency.usd, to: Currency.eur),
        closeTo(9.2, 1e-9),
      );
    });

    test('derives cross rates through the USD pivot', () {
      // 1 CNY = (1/7.25) USD = (1/7.25) * 0.92 EUR.
      expect(
        converter.convert(amount: 7.25, from: Currency.cny, to: Currency.eur),
        closeTo(0.92, 1e-9),
      );
      // Round-tripping returns the original amount.
      final eur = converter.convert(
        amount: 100,
        from: Currency.sgd,
        to: Currency.eur,
      );
      expect(
        converter.convert(amount: eur, from: Currency.eur, to: Currency.sgd),
        closeTo(100, 1e-9),
      );
    });
  });

  group('CurrencyConverter.fromRateRows', () {
    test('fills missing currencies with defaults so conversion never throws',
        () {
      // An old snapshot that only stored USD->CNY / USD->SGD.
      final converter = CurrencyConverter.fromRateRows([
        (from: 'usd', to: 'cny', rate: 7.0),
        (from: 'usd', to: 'sgd', rate: 1.3),
      ]);

      expect(
        converter.convert(amount: 1, from: Currency.usd, to: Currency.cny),
        closeTo(7.0, 1e-9),
      );
      // A currency added later still converts, using its fallback rate.
      expect(
        converter.convert(amount: 1, from: Currency.usd, to: Currency.eur),
        closeTo(defaultUsdRate(Currency.eur), 1e-9),
      );
    });
  });
}
