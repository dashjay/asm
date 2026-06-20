import 'currency/currency_converter.dart';
import 'models/enums.dart';

class AccountBalance {
  AccountBalance({
    required this.accountId,
    required this.category,
    required this.currency,
    required this.amount,
  });

  final int accountId;
  final AccountCategory category;
  final Currency currency;
  final double amount;
}

class NetWorthBreakdown {
  NetWorthBreakdown({
    required this.total,
    required this.byCategory,
  });

  final double total;
  final Map<AccountCategory, double> byCategory;
}

class NetWorthCalculator {
  static double signedAmount(AccountBalance balance) {
    return balance.category.isLiability ? -balance.amount : balance.amount;
  }

  static double familyNetWorth({
    required List<AccountBalance> balances,
    required CurrencyConverter converter,
    required Currency displayCurrency,
  }) {
    var total = 0.0;
    for (final balance in balances) {
      final converted = converter.convert(
        amount: balance.amount,
        from: balance.currency,
        to: displayCurrency,
      );
      total += balance.category.isLiability ? -converted : converted;
    }
    return total;
  }

  static NetWorthBreakdown breakdown({
    required List<AccountBalance> balances,
    required CurrencyConverter converter,
    required Currency displayCurrency,
  }) {
    final byCategory = <AccountCategory, double>{};
    for (final category in AccountCategory.values) {
      byCategory[category] = 0;
    }
    for (final balance in balances) {
      final converted = converter.convert(
        amount: balance.amount,
        from: balance.currency,
        to: displayCurrency,
      );
      final signed = balance.category.isLiability ? -converted : converted;
      byCategory[balance.category] =
          (byCategory[balance.category] ?? 0) + signed;
    }
    final total = byCategory.values.fold(0.0, (a, b) => a + b);
    return NetWorthBreakdown(total: total, byCategory: byCategory);
  }

  static ({double balanceChange, double fxChange}) attributeChange({
    required List<AccountBalance> previousBalances,
    required List<AccountBalance> currentBalances,
    required CurrencyConverter previousFx,
    required CurrencyConverter currentFx,
    required Currency displayCurrency,
  }) {
    final prevMap = {for (final b in previousBalances) b.accountId: b};
    final currMap = {for (final b in currentBalances) b.accountId: b};

    var balanceChange = 0.0;
    var fxChange = 0.0;

    for (final entry in currMap.entries) {
      final curr = entry.value;
      final prev = prevMap[entry.key];
      if (prev == null) {
        final converted = currentFx.convert(
          amount: curr.amount,
          from: curr.currency,
          to: displayCurrency,
        );
        balanceChange +=
            curr.category.isLiability ? -converted : converted;
        continue;
      }

      final prevConvertedOldFx = previousFx.convert(
        amount: prev.amount,
        from: prev.currency,
        to: displayCurrency,
      );
      final prevConvertedNewFx = currentFx.convert(
        amount: prev.amount,
        from: prev.currency,
        to: displayCurrency,
      );
      final prevSigned = prev.category.isLiability
          ? -prevConvertedOldFx
          : prevConvertedOldFx;
      final prevAtNewFx =
          prev.category.isLiability ? -prevConvertedNewFx : prevConvertedNewFx;

      fxChange += prevAtNewFx - prevSigned;

      final deltaNative = curr.amount - prev.amount;
      final deltaConverted = currentFx.convert(
        amount: deltaNative,
        from: curr.currency,
        to: displayCurrency,
      );
      balanceChange +=
          curr.category.isLiability ? -deltaConverted : deltaConverted;
    }

    return (balanceChange: balanceChange, fxChange: fxChange);
  }
}
