enum AccountCategory {
  current,
  fixedAsset,
  investment,
  liability,
  receivable;

  String get label => switch (this) {
        current => '活期',
        fixedAsset => '固定资产',
        investment => '投资理财',
        liability => '负债',
        receivable => '债权',
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

  String get label => switch (this) {
        salary => '工资收入',
        investmentReturn => '投资收益',
        repayment => '还贷',
        purchase => '购置资产',
        transfer => '转账',
        gift => '赠予',
        fxFluctuation => '汇率波动',
        other => '其他',
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

  String get label => switch (this) {
        oneMonth => '1M',
        threeMonths => '3M',
        sixMonths => '6M',
        oneYear => '1Y',
        all => '全部',
      };

  Duration? get duration => switch (this) {
        oneMonth => const Duration(days: 30),
        threeMonths => const Duration(days: 90),
        sixMonths => const Duration(days: 180),
        oneYear => const Duration(days: 365),
        all => null,
      };
}
