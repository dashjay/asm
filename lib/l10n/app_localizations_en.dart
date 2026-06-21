// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Family Assets';

  @override
  String get navHome => 'Home';

  @override
  String get navAccounts => 'Accounts';

  @override
  String get navCharts => 'Trends';

  @override
  String get navFx => 'FX Rates';

  @override
  String get navSettings => 'Settings';

  @override
  String get updateBalances => 'Update Balances';

  @override
  String loadFailed(String error) {
    return 'Failed to load: $error';
  }

  @override
  String get accountNotFound => 'Account not found';

  @override
  String get changeReason => 'Change reason';

  @override
  String get close => 'Close';

  @override
  String get noSnapshots => 'No snapshots yet';

  @override
  String get nativeCurrency => 'Native';

  @override
  String get noDataUpdateFirst => 'No data yet. Update balances first.';

  @override
  String get familyNetWorth => 'Family Net Worth';

  @override
  String changeSinceLast(String amount) {
    return 'Since last update $amount';
  }

  @override
  String daysSinceUpdate(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days since last update',
      one: '1 day since last update',
    );
    return '$_temp0';
  }

  @override
  String get fxMayBeStale => 'Exchange rates may be outdated';

  @override
  String fxLastRecordedDaysAgo(int days) {
    return 'Last recorded $days days ago. Consider updating.';
  }

  @override
  String get goUpdate => 'Update';

  @override
  String get familyTrend => 'Family Trend';

  @override
  String get accountsToUpdate => 'Accounts to Update';

  @override
  String overdueDays(int days) {
    return 'Over $days-day cycle';
  }

  @override
  String get trendForecast => 'Trend Forecast';

  @override
  String forecastDescription(String amount) {
    return 'Based on the recent 6-month trend, family net worth in ~3 months is estimated at $amount';
  }

  @override
  String get forecastDisclaimer => 'For reference only. Not investment advice.';

  @override
  String get accountsTitle => 'Accounts';

  @override
  String get noAccountsHint => 'No accounts yet. Tap + to add one.';

  @override
  String get unknownMember => 'Unknown member';

  @override
  String approxAmount(String amount) {
    return '≈ $amount';
  }

  @override
  String get fxHistory => 'FX History';

  @override
  String get noFxRecords => 'No FX records yet';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChinese => '中文';

  @override
  String get displaySettings => 'Display';

  @override
  String get largeChangeThresholds => 'Large Change Thresholds';

  @override
  String get changePercentLabel => 'Change percent (%)';

  @override
  String get changeAmountLabel => 'Change amount (display currency)';

  @override
  String get saveThresholds => 'Save Thresholds';

  @override
  String get thresholdsSaved => 'Thresholds saved';

  @override
  String get dataBackup => 'Data Backup';

  @override
  String exportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String get exportLocalBackup => 'Export Local Backup';

  @override
  String get importCompleteRestart =>
      'Import complete. Please restart the app.';

  @override
  String get importBackup => 'Import Backup';

  @override
  String get s3BackupReserved => 'S3 Backup (Coming Soon)';

  @override
  String get s3Endpoint => 'Endpoint';

  @override
  String get s3Bucket => 'Bucket';

  @override
  String get s3AccessKey => 'Access Key';

  @override
  String get s3SecretKey => 'Secret Key';

  @override
  String get saveS3Config => 'Save S3 Config';

  @override
  String get s3ConfigSaved => 'S3 config saved';

  @override
  String get uploadToS3ComingSoon => 'Upload to S3 (Coming Soon)';

  @override
  String get assetTrends => 'Asset Trends';

  @override
  String get familyTotalNetWorth => 'Family Total Net Worth';

  @override
  String get wizardStepFx => 'Enter FX Rates';

  @override
  String get wizardStepBalances => 'Enter Balances';

  @override
  String get wizardStepPreview => 'Preview & Confirm';

  @override
  String get enterValidFxRates => 'Please enter valid exchange rates';

  @override
  String get confirmSubmit => 'Confirm';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get fxSnapshot => 'FX Snapshot';

  @override
  String get usdToCnyLabel => '1 USD = ? CNY';

  @override
  String get usdToSgdLabel => '1 USD = ? SGD';

  @override
  String get sourceNoteLabel => 'Source note (e.g. Bank of China app)';

  @override
  String get accountBalances => 'Account Balances';

  @override
  String get preview => 'Preview';

  @override
  String accountBalanceLabel(String name, String symbol) {
    return '$name ($symbol)';
  }

  @override
  String familyNetWorthCurrency(String currency) {
    return '$currency Family Net Worth';
  }

  @override
  String compareWithPrevious(String currency) {
    return 'Compared to last update ($currency)';
  }

  @override
  String balanceChange(String amount) {
    return 'Balance change: $amount';
  }

  @override
  String fxChange(String amount) {
    return 'FX change: $amount';
  }

  @override
  String largeChangeTitle(String accountName) {
    return 'Large change - $accountName';
  }

  @override
  String changeAmountDetail(
    String previous,
    String current,
    String delta,
    String percent,
  ) {
    return '$previous → $current ($delta, $percent)';
  }

  @override
  String get noteOptional => 'Note (optional)';

  @override
  String get confirm => 'Confirm';

  @override
  String get familyMembers => 'Family Members';

  @override
  String get addMember => 'Add Member';

  @override
  String get editMember => 'Edit Member';

  @override
  String get nameLabel => 'Name';

  @override
  String get delete => 'Delete';

  @override
  String get deleteAccountTitle => 'Delete Account?';

  @override
  String get deleteAccountWarning =>
      'We recommend keeping this account and updating its balance to 0 instead of deleting it. This preserves your historical records.\n\nIf you delete this account, all balance snapshots and update history for it will be permanently removed.';

  @override
  String get deleteAccountConfirm => 'Delete anyway';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get newAccount => 'New Account';

  @override
  String get editAccount => 'Edit Account';

  @override
  String get accountNameLabel => 'Account name';

  @override
  String get familyMemberLabel => 'Family member';

  @override
  String get accountCategoryLabel => 'Account category';

  @override
  String get currencyLabel => 'Currency';

  @override
  String initialBalanceOptional(String currency) {
    return 'Initial balance ($currency, optional)';
  }

  @override
  String get enableUpdateReminder => 'Enable update reminder';

  @override
  String get reminderIntervalLabel => 'Reminder interval';

  @override
  String reminderDays(int days) {
    return '$days days';
  }

  @override
  String get selectMemberFirst => 'Please select a member';

  @override
  String get accountCategoryCurrent => 'Current';

  @override
  String get accountCategoryFixedAsset => 'Fixed Asset';

  @override
  String get accountCategoryInvestment => 'Investment';

  @override
  String get accountCategoryLiability => 'Liability';

  @override
  String get accountCategoryReceivable => 'Receivable';

  @override
  String get changeReasonSalary => 'Salary';

  @override
  String get changeReasonInvestmentReturn => 'Investment Return';

  @override
  String get changeReasonRepayment => 'Loan Repayment';

  @override
  String get changeReasonPurchase => 'Asset Purchase';

  @override
  String get changeReasonTransfer => 'Transfer';

  @override
  String get changeReasonGift => 'Gift';

  @override
  String get changeReasonFxFluctuation => 'FX Fluctuation';

  @override
  String get changeReasonOther => 'Other';

  @override
  String get chartRangeAll => 'All';

  @override
  String get notificationChannelName => 'Account Update Reminders';

  @override
  String get notificationChannelDescription =>
      'Periodic reminders to update account balances';

  @override
  String get notificationTitle => 'Account Update Reminder';

  @override
  String notificationBody(String accountName, int days) {
    return 'Time to update balance for $accountName (last updated $days days ago)';
  }

  @override
  String get backupWebExportUnsupported =>
      'Web uses IndexedDB. File export is not supported yet.';

  @override
  String get backupWebImportUnsupported => 'Web import is not supported yet.';
}
