import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Family Assets'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get navAccounts;

  /// No description provided for @navCharts.
  ///
  /// In en, this message translates to:
  /// **'Trends'**
  String get navCharts;

  /// No description provided for @navFx.
  ///
  /// In en, this message translates to:
  /// **'FX Rates'**
  String get navFx;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @updateBalances.
  ///
  /// In en, this message translates to:
  /// **'Update Balances'**
  String get updateBalances;

  /// No description provided for @loadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load: {error}'**
  String loadFailed(String error);

  /// No description provided for @accountNotFound.
  ///
  /// In en, this message translates to:
  /// **'Account not found'**
  String get accountNotFound;

  /// No description provided for @changeReason.
  ///
  /// In en, this message translates to:
  /// **'Change reason'**
  String get changeReason;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @noSnapshots.
  ///
  /// In en, this message translates to:
  /// **'No snapshots yet'**
  String get noSnapshots;

  /// No description provided for @nativeCurrency.
  ///
  /// In en, this message translates to:
  /// **'Native'**
  String get nativeCurrency;

  /// No description provided for @noDataUpdateFirst.
  ///
  /// In en, this message translates to:
  /// **'No data yet. Update balances first.'**
  String get noDataUpdateFirst;

  /// No description provided for @familyNetWorth.
  ///
  /// In en, this message translates to:
  /// **'Family Net Worth'**
  String get familyNetWorth;

  /// No description provided for @changeSinceLast.
  ///
  /// In en, this message translates to:
  /// **'Since last update {amount}'**
  String changeSinceLast(String amount);

  /// No description provided for @daysSinceUpdate.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1 day since last update} other{{days} days since last update}}'**
  String daysSinceUpdate(int days);

  /// No description provided for @fxMayBeStale.
  ///
  /// In en, this message translates to:
  /// **'Exchange rates may be outdated'**
  String get fxMayBeStale;

  /// No description provided for @fxLastRecordedDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'Last recorded {days} days ago. Consider updating.'**
  String fxLastRecordedDaysAgo(int days);

  /// No description provided for @goUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get goUpdate;

  /// No description provided for @familyTrend.
  ///
  /// In en, this message translates to:
  /// **'Family Trend'**
  String get familyTrend;

  /// No description provided for @accountsToUpdate.
  ///
  /// In en, this message translates to:
  /// **'Accounts to Update'**
  String get accountsToUpdate;

  /// No description provided for @overdueDays.
  ///
  /// In en, this message translates to:
  /// **'Over {days}-day cycle'**
  String overdueDays(int days);

  /// No description provided for @trendForecast.
  ///
  /// In en, this message translates to:
  /// **'Trend Forecast'**
  String get trendForecast;

  /// No description provided for @forecastDescription.
  ///
  /// In en, this message translates to:
  /// **'Based on the recent 6-month trend, family net worth in ~3 months is estimated at {amount}'**
  String forecastDescription(String amount);

  /// No description provided for @forecastDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'For reference only. Not investment advice.'**
  String get forecastDisclaimer;

  /// No description provided for @accountsTitle.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accountsTitle;

  /// No description provided for @noAccountsHint.
  ///
  /// In en, this message translates to:
  /// **'No accounts yet. Tap + to add one.'**
  String get noAccountsHint;

  /// No description provided for @unknownMember.
  ///
  /// In en, this message translates to:
  /// **'Unknown member'**
  String get unknownMember;

  /// No description provided for @approxAmount.
  ///
  /// In en, this message translates to:
  /// **'≈ {amount}'**
  String approxAmount(String amount);

  /// No description provided for @fxHistory.
  ///
  /// In en, this message translates to:
  /// **'FX History'**
  String get fxHistory;

  /// No description provided for @noFxRecords.
  ///
  /// In en, this message translates to:
  /// **'No FX records yet'**
  String get noFxRecords;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageChinese.
  ///
  /// In en, this message translates to:
  /// **'中文'**
  String get languageChinese;

  /// No description provided for @displaySettings.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get displaySettings;

  /// No description provided for @appLock.
  ///
  /// In en, this message translates to:
  /// **'App Lock'**
  String get appLock;

  /// No description provided for @biometricLock.
  ///
  /// In en, this message translates to:
  /// **'Unlock with fingerprint'**
  String get biometricLock;

  /// No description provided for @biometricLockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Require fingerprint or device credential when opening the app'**
  String get biometricLockSubtitle;

  /// No description provided for @biometricUnlockReason.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to access your family assets'**
  String get biometricUnlockReason;

  /// No description provided for @biometricNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'No fingerprint or screen lock is set up on this device'**
  String get biometricNotAvailable;

  /// No description provided for @appLockedMessage.
  ///
  /// In en, this message translates to:
  /// **'Authenticate to unlock'**
  String get appLockedMessage;

  /// No description provided for @unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock;

  /// No description provided for @largeChangeThresholds.
  ///
  /// In en, this message translates to:
  /// **'Large Change Thresholds'**
  String get largeChangeThresholds;

  /// No description provided for @changePercentLabel.
  ///
  /// In en, this message translates to:
  /// **'Change percent (%)'**
  String get changePercentLabel;

  /// No description provided for @changeAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Change amount (display currency)'**
  String get changeAmountLabel;

  /// No description provided for @saveThresholds.
  ///
  /// In en, this message translates to:
  /// **'Save Thresholds'**
  String get saveThresholds;

  /// No description provided for @thresholdsSaved.
  ///
  /// In en, this message translates to:
  /// **'Thresholds saved'**
  String get thresholdsSaved;

  /// No description provided for @dataBackup.
  ///
  /// In en, this message translates to:
  /// **'Data Backup'**
  String get dataBackup;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed: {error}'**
  String exportFailed(String error);

  /// No description provided for @exportLocalBackup.
  ///
  /// In en, this message translates to:
  /// **'Export Local Backup'**
  String get exportLocalBackup;

  /// No description provided for @importCompleteRestart.
  ///
  /// In en, this message translates to:
  /// **'Import complete. Please restart the app.'**
  String get importCompleteRestart;

  /// No description provided for @importBackup.
  ///
  /// In en, this message translates to:
  /// **'Import Backup'**
  String get importBackup;

  /// No description provided for @importBackupConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore backup?'**
  String get importBackupConfirmTitle;

  /// No description provided for @importBackupConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will replace all current data with the selected backup file. This cannot be undone.'**
  String get importBackupConfirmMessage;

  /// No description provided for @importCancelled.
  ///
  /// In en, this message translates to:
  /// **'Import cancelled'**
  String get importCancelled;

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed: {error}'**
  String importFailed(String error);

  /// No description provided for @invalidBackupFile.
  ///
  /// In en, this message translates to:
  /// **'The selected file is not a valid ASM database backup'**
  String get invalidBackupFile;

  /// No description provided for @backupFileUnreadable.
  ///
  /// In en, this message translates to:
  /// **'Could not read the selected file. Try saving it locally first, then import again.'**
  String get backupFileUnreadable;

  /// No description provided for @s3BackupReserved.
  ///
  /// In en, this message translates to:
  /// **'S3 Backup'**
  String get s3BackupReserved;

  /// No description provided for @s3Backup.
  ///
  /// In en, this message translates to:
  /// **'S3 Backup'**
  String get s3Backup;

  /// No description provided for @s3Endpoint.
  ///
  /// In en, this message translates to:
  /// **'Endpoint'**
  String get s3Endpoint;

  /// No description provided for @s3Bucket.
  ///
  /// In en, this message translates to:
  /// **'Bucket'**
  String get s3Bucket;

  /// No description provided for @s3AccessKey.
  ///
  /// In en, this message translates to:
  /// **'Access Key'**
  String get s3AccessKey;

  /// No description provided for @s3SecretKey.
  ///
  /// In en, this message translates to:
  /// **'Secret Key'**
  String get s3SecretKey;

  /// No description provided for @s3Prefix.
  ///
  /// In en, this message translates to:
  /// **'Object Key Prefix'**
  String get s3Prefix;

  /// No description provided for @saveS3Config.
  ///
  /// In en, this message translates to:
  /// **'Save S3 Config'**
  String get saveS3Config;

  /// No description provided for @s3ConfigSaved.
  ///
  /// In en, this message translates to:
  /// **'S3 config saved'**
  String get s3ConfigSaved;

  /// No description provided for @s3Upload.
  ///
  /// In en, this message translates to:
  /// **'Upload to S3'**
  String get s3Upload;

  /// No description provided for @s3UploadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Backup uploaded to S3'**
  String get s3UploadSuccess;

  /// No description provided for @s3UploadFailed.
  ///
  /// In en, this message translates to:
  /// **'S3 upload failed: {error}'**
  String s3UploadFailed(String error);

  /// No description provided for @s3ConfigIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Please fill in endpoint, bucket, access key, and secret key'**
  String get s3ConfigIncomplete;

  /// No description provided for @s3NetworkAccessDenied.
  ///
  /// In en, this message translates to:
  /// **'Cannot reach the S3 endpoint. Check network access and allow this app to use Wi‑Fi and mobile data in system settings.'**
  String get s3NetworkAccessDenied;

  /// No description provided for @s3InvalidEndpoint.
  ///
  /// In en, this message translates to:
  /// **'Endpoint URL is invalid. Use https://your-account.r2.cloudflarestorage.com'**
  String get s3InvalidEndpoint;

  /// No description provided for @assetTrends.
  ///
  /// In en, this message translates to:
  /// **'Asset Trends'**
  String get assetTrends;

  /// No description provided for @familyTotalNetWorth.
  ///
  /// In en, this message translates to:
  /// **'Family Total Net Worth'**
  String get familyTotalNetWorth;

  /// No description provided for @viewTrendDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewTrendDetails;

  /// No description provided for @trendDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Trend Details'**
  String get trendDetailsTitle;

  /// No description provided for @trendFilterHint.
  ///
  /// In en, this message translates to:
  /// **'Pick a member and/or asset type to view that portion of net worth.'**
  String get trendFilterHint;

  /// No description provided for @allMembers.
  ///
  /// In en, this message translates to:
  /// **'All members'**
  String get allMembers;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All types'**
  String get allCategories;

  /// No description provided for @wizardStepFx.
  ///
  /// In en, this message translates to:
  /// **'Enter FX Rates'**
  String get wizardStepFx;

  /// No description provided for @wizardStepBalances.
  ///
  /// In en, this message translates to:
  /// **'Enter Balances'**
  String get wizardStepBalances;

  /// No description provided for @wizardStepPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview & Confirm'**
  String get wizardStepPreview;

  /// No description provided for @enterValidFxRates.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid exchange rates'**
  String get enterValidFxRates;

  /// No description provided for @confirmSubmit.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmSubmit;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @fxSnapshot.
  ///
  /// In en, this message translates to:
  /// **'FX Snapshot'**
  String get fxSnapshot;

  /// No description provided for @usdToCnyLabel.
  ///
  /// In en, this message translates to:
  /// **'1 USD = ? CNY'**
  String get usdToCnyLabel;

  /// No description provided for @usdToSgdLabel.
  ///
  /// In en, this message translates to:
  /// **'1 USD = ? SGD'**
  String get usdToSgdLabel;

  /// No description provided for @sourceNoteLabel.
  ///
  /// In en, this message translates to:
  /// **'Source note (e.g. Bank of China app)'**
  String get sourceNoteLabel;

  /// No description provided for @accountBalances.
  ///
  /// In en, this message translates to:
  /// **'Account Balances'**
  String get accountBalances;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @accountBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'{name} ({symbol})'**
  String accountBalanceLabel(String name, String symbol);

  /// No description provided for @familyNetWorthCurrency.
  ///
  /// In en, this message translates to:
  /// **'{currency} Family Net Worth'**
  String familyNetWorthCurrency(String currency);

  /// No description provided for @compareWithPrevious.
  ///
  /// In en, this message translates to:
  /// **'Compared to last update ({currency})'**
  String compareWithPrevious(String currency);

  /// No description provided for @balanceChange.
  ///
  /// In en, this message translates to:
  /// **'Balance change: {amount}'**
  String balanceChange(String amount);

  /// No description provided for @fxChange.
  ///
  /// In en, this message translates to:
  /// **'FX change: {amount}'**
  String fxChange(String amount);

  /// No description provided for @largeChangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Large change - {accountName}'**
  String largeChangeTitle(String accountName);

  /// No description provided for @changeAmountDetail.
  ///
  /// In en, this message translates to:
  /// **'{previous} → {current} ({delta}, {percent})'**
  String changeAmountDetail(
    String previous,
    String current,
    String delta,
    String percent,
  );

  /// No description provided for @noteOptional.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get noteOptional;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @familyMembers.
  ///
  /// In en, this message translates to:
  /// **'Family Members'**
  String get familyMembers;

  /// No description provided for @addMember.
  ///
  /// In en, this message translates to:
  /// **'Add Member'**
  String get addMember;

  /// No description provided for @editMember.
  ///
  /// In en, this message translates to:
  /// **'Edit Member'**
  String get editMember;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account?'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'We recommend keeping this account and updating its balance to 0 instead of deleting it. This preserves your historical records.\n\nIf you delete this account, all balance snapshots and update history for it will be permanently removed.'**
  String get deleteAccountWarning;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete anyway'**
  String get deleteAccountConfirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @newAccount.
  ///
  /// In en, this message translates to:
  /// **'New Account'**
  String get newAccount;

  /// No description provided for @editAccount.
  ///
  /// In en, this message translates to:
  /// **'Edit Account'**
  String get editAccount;

  /// No description provided for @accountNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Account name'**
  String get accountNameLabel;

  /// No description provided for @familyMemberLabel.
  ///
  /// In en, this message translates to:
  /// **'Family member'**
  String get familyMemberLabel;

  /// No description provided for @accountCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Account category'**
  String get accountCategoryLabel;

  /// No description provided for @currencyLabel.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currencyLabel;

  /// No description provided for @initialBalanceOptional.
  ///
  /// In en, this message translates to:
  /// **'Initial balance ({currency}, optional)'**
  String initialBalanceOptional(String currency);

  /// No description provided for @enableUpdateReminder.
  ///
  /// In en, this message translates to:
  /// **'Enable update reminder'**
  String get enableUpdateReminder;

  /// No description provided for @reminderIntervalLabel.
  ///
  /// In en, this message translates to:
  /// **'Reminder interval'**
  String get reminderIntervalLabel;

  /// No description provided for @reminderDays.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String reminderDays(int days);

  /// No description provided for @selectMemberFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a member'**
  String get selectMemberFirst;

  /// No description provided for @accountCategoryCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get accountCategoryCurrent;

  /// No description provided for @accountCategoryFixedAsset.
  ///
  /// In en, this message translates to:
  /// **'Fixed Asset'**
  String get accountCategoryFixedAsset;

  /// No description provided for @accountCategoryInvestment.
  ///
  /// In en, this message translates to:
  /// **'Investment'**
  String get accountCategoryInvestment;

  /// No description provided for @accountCategoryLiability.
  ///
  /// In en, this message translates to:
  /// **'Liability'**
  String get accountCategoryLiability;

  /// No description provided for @accountCategoryReceivable.
  ///
  /// In en, this message translates to:
  /// **'Receivable'**
  String get accountCategoryReceivable;

  /// No description provided for @changeReasonSalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get changeReasonSalary;

  /// No description provided for @changeReasonInvestmentReturn.
  ///
  /// In en, this message translates to:
  /// **'Investment Return'**
  String get changeReasonInvestmentReturn;

  /// No description provided for @changeReasonRepayment.
  ///
  /// In en, this message translates to:
  /// **'Loan Repayment'**
  String get changeReasonRepayment;

  /// No description provided for @changeReasonPurchase.
  ///
  /// In en, this message translates to:
  /// **'Asset Purchase'**
  String get changeReasonPurchase;

  /// No description provided for @changeReasonTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get changeReasonTransfer;

  /// No description provided for @changeReasonGift.
  ///
  /// In en, this message translates to:
  /// **'Gift'**
  String get changeReasonGift;

  /// No description provided for @changeReasonFxFluctuation.
  ///
  /// In en, this message translates to:
  /// **'FX Fluctuation'**
  String get changeReasonFxFluctuation;

  /// No description provided for @changeReasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get changeReasonOther;

  /// No description provided for @chartRangeAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get chartRangeAll;

  /// No description provided for @notificationChannelName.
  ///
  /// In en, this message translates to:
  /// **'Account Update Reminders'**
  String get notificationChannelName;

  /// No description provided for @notificationChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Periodic reminders to update account balances'**
  String get notificationChannelDescription;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Update Reminder'**
  String get notificationTitle;

  /// No description provided for @notificationBody.
  ///
  /// In en, this message translates to:
  /// **'Time to update balance for {accountName} (last updated {days} days ago)'**
  String notificationBody(String accountName, int days);

  /// No description provided for @backupWebExportUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Web uses IndexedDB. File export is not supported yet.'**
  String get backupWebExportUnsupported;

  /// No description provided for @backupWebImportUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Web import is not supported yet.'**
  String get backupWebImportUnsupported;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
