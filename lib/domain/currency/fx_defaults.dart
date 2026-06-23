import '../models/enums.dart';

/// Fallback `USD -> X` rates used before the user records their first
/// [FxSnapshot] (or when a stored snapshot predates a newly added currency).
///
/// These are intentionally rough "good enough" defaults; once a real snapshot
/// exists the stored rates always take precedence. Keeping them in one place,
/// keyed by [Currency], avoids magic numbers drifting across the converter,
/// repositories and the snapshot wizard. To support a new currency, add the
/// enum value in `enums.dart` and a fallback rate here.
const Map<Currency, double> kDefaultUsdRates = <Currency, double>{
  Currency.cny: 7.25,
  Currency.sgd: 1.35,
  Currency.eur: 0.92,
  Currency.gbp: 0.79,
  Currency.jpy: 157.0,
  Currency.hkd: 7.81,
  Currency.aud: 1.51,
  Currency.cad: 1.37,
  Currency.inr: 83.5,
};

/// The fallback `USD -> X` rate for [currency] (1.0 for USD itself).
double defaultUsdRate(Currency currency) =>
    currency == Currency.usd ? 1.0 : (kDefaultUsdRates[currency] ?? 1.0);

/// Fallback `USD -> X` rates for every non-USD [Currency], guaranteed complete.
Map<Currency, double> defaultUsdRates() => <Currency, double>{
      for (final c in Currency.values)
        if (c != Currency.usd) c: defaultUsdRate(c),
    };
