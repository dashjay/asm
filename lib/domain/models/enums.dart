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

enum Currency {
  cny,
  usd,
  sgd;

  String get code => switch (this) {
        cny => 'CNY',
        usd => 'USD',
        sgd => 'SGD',
      };

  String get symbol => switch (this) {
        cny => '¥',
        usd => '\$',
        sgd => 'S\$',
      };

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
