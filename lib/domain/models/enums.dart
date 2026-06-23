import 'package:asm/l10n/app_localizations.dart';

enum AccountCategory {
  current,
  fixedAsset,
  investment,
  liability,
  receivable;

  String label(AppLocalizations l10n) => switch (this) {
        current => l10n.accountCategoryCurrent,
        fixedAsset => l10n.accountCategoryFixedAsset,
        investment => l10n.accountCategoryInvestment,
        liability => l10n.accountCategoryLiability,
        receivable => l10n.accountCategoryReceivable,
      };

  bool get isLiability => this == AccountCategory.liability;

  static AccountCategory fromString(String value) =>
      AccountCategory.values.firstWhere((e) => e.name == value);
}

/// Supported display/account currencies.
///
/// USD is the pivot used for FX math: every snapshot stores `USD -> X` rates
/// and [CurrencyConverter] derives all cross rates from them. Adding a new
/// region is therefore just a new entry here plus a fallback rate in
/// `fx_defaults.dart` — no schema, converter or wizard changes required.
enum Currency {
  cny('CNY', '¥'),
  usd('USD', '\$'),
  sgd('SGD', 'S\$'),
  eur('EUR', '€'),
  gbp('GBP', '£'),
  jpy('JPY', 'JP¥'),
  hkd('HKD', 'HK\$'),
  aud('AUD', 'A\$'),
  cad('CAD', 'C\$'),
  inr('INR', '₹');

  const Currency(this.code, this.symbol);

  /// ISO 4217 code, e.g. `USD`.
  final String code;

  /// Short display symbol, e.g. `\$`.
  final String symbol;

  static Currency fromString(String value) =>
      Currency.values.firstWhere((e) => e.name == value);
}

enum ChangeReason {
  salary,
  investmentReturn,
  repayment,
  purchase,
  transfer,
  gift,
  fxFluctuation,
  other;

  String label(AppLocalizations l10n) => switch (this) {
        salary => l10n.changeReasonSalary,
        investmentReturn => l10n.changeReasonInvestmentReturn,
        repayment => l10n.changeReasonRepayment,
        purchase => l10n.changeReasonPurchase,
        transfer => l10n.changeReasonTransfer,
        gift => l10n.changeReasonGift,
        fxFluctuation => l10n.changeReasonFxFluctuation,
        other => l10n.changeReasonOther,
      };

  static ChangeReason fromString(String? value) {
    if (value == null) return ChangeReason.other;
    return ChangeReason.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ChangeReason.other,
    );
  }
}

enum ChartRange {
  oneMonth,
  threeMonths,
  sixMonths,
  oneYear,
  all;

  String label(AppLocalizations l10n) => switch (this) {
        oneMonth => '1M',
        threeMonths => '3M',
        sixMonths => '6M',
        oneYear => '1Y',
        all => l10n.chartRangeAll,
      };

  Duration? get duration => switch (this) {
        oneMonth => const Duration(days: 30),
        threeMonths => const Duration(days: 90),
        sixMonths => const Duration(days: 180),
        oneYear => const Duration(days: 365),
        all => null,
      };
}
