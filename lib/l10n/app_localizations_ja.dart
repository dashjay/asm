// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '家族の資産';

  @override
  String get navHome => 'ホーム';

  @override
  String get navAccounts => '口座';

  @override
  String get navCharts => '推移';

  @override
  String get navFx => '為替レート';

  @override
  String get navSettings => '設定';

  @override
  String get updateBalances => '残高を更新';

  @override
  String loadFailed(String error) {
    return '読み込みに失敗しました: $error';
  }

  @override
  String get accountNotFound => '口座が見つかりません';

  @override
  String get changeReason => '変動理由';

  @override
  String get close => '閉じる';

  @override
  String get noSnapshots => 'スナップショットがありません';

  @override
  String get nativeCurrency => '現地通貨';

  @override
  String get noDataUpdateFirst => 'データがありません。まず残高を更新してください。';

  @override
  String get familyNetWorth => '家族の純資産';

  @override
  String changeSinceLast(String amount) {
    return '前回から $amount';
  }

  @override
  String daysSinceUpdate(int days) {
    return '前回の更新から $days 日';
  }

  @override
  String get fxMayBeStale => '為替レートが古い可能性があります';

  @override
  String fxLastRecordedDaysAgo(int days) {
    return '$days 日前に記録。更新をおすすめします。';
  }

  @override
  String get goUpdate => '更新する';

  @override
  String get familyTrend => '家族の推移';

  @override
  String get accountsToUpdate => '更新待ちの口座';

  @override
  String overdueDays(int days) {
    return '$days 日周期を超過';
  }

  @override
  String get trendForecast => '推移予測';

  @override
  String forecastDescription(String amount) {
    return '直近6か月の推移に基づくと、約3か月後の家族の純資産は $amount と予測されます';
  }

  @override
  String get forecastDisclaimer => '参考情報です。投資助言ではありません。';

  @override
  String get accountsTitle => '口座';

  @override
  String get noAccountsHint => '口座がありません。＋をタップして追加してください。';

  @override
  String get unknownMember => '不明なメンバー';

  @override
  String approxAmount(String amount) {
    return '≈ $amount';
  }

  @override
  String get fxHistory => '為替レート履歴';

  @override
  String get noFxRecords => '為替レートの記録がありません';

  @override
  String get settingsTitle => '設定';

  @override
  String get language => '言語';

  @override
  String get displaySettings => '表示設定';

  @override
  String get appLock => 'アプリロック';

  @override
  String get biometricLock => '指紋で解除';

  @override
  String get biometricLockSubtitle => 'アプリを開くときに指紋またはデバイスの認証情報を要求します';

  @override
  String get biometricUnlockReason => '家族の資産にアクセスするには認証してください';

  @override
  String get biometricNotAvailable => 'このデバイスには指紋や画面ロックが設定されていません';

  @override
  String get appLockedMessage => 'ロックを解除するには認証してください';

  @override
  String get unlock => '解除';

  @override
  String get largeChangeThresholds => '大きな変動のしきい値';

  @override
  String get changePercentLabel => '変動率 (%)';

  @override
  String get changeAmountLabel => '変動額（表示通貨）';

  @override
  String get saveThresholds => 'しきい値を保存';

  @override
  String get thresholdsSaved => 'しきい値を保存しました';

  @override
  String get dataBackup => 'データのバックアップ';

  @override
  String exportFailed(String error) {
    return 'エクスポートに失敗しました: $error';
  }

  @override
  String get exportLocalBackup => 'ローカルバックアップをエクスポート';

  @override
  String get importCompleteRestart => 'インポートが完了しました。アプリを再起動してください。';

  @override
  String get importBackup => 'バックアップをインポート';

  @override
  String get importBackupConfirmTitle => 'バックアップを復元しますか？';

  @override
  String get importBackupConfirmMessage =>
      '現在のすべてのデータが選択したバックアップファイルで置き換えられます。この操作は取り消せません。';

  @override
  String get importCancelled => 'インポートをキャンセルしました';

  @override
  String importFailed(String error) {
    return 'インポートに失敗しました: $error';
  }

  @override
  String get invalidBackupFile => '選択したファイルは有効な ASM データベースのバックアップではありません';

  @override
  String get backupFileUnreadable =>
      '選択したファイルを読み込めませんでした。一度ローカルに保存してから再度インポートしてください。';

  @override
  String get s3BackupReserved => 'S3 バックアップ';

  @override
  String get s3Backup => 'S3 バックアップ';

  @override
  String get s3Endpoint => 'Endpoint';

  @override
  String get s3Bucket => 'Bucket';

  @override
  String get s3AccessKey => 'Access Key';

  @override
  String get s3SecretKey => 'Secret Key';

  @override
  String get s3Prefix => 'オブジェクトキーのプレフィックス';

  @override
  String get saveS3Config => 'S3 設定を保存';

  @override
  String get s3ConfigSaved => 'S3 設定を保存しました';

  @override
  String get s3Upload => 'S3 にアップロード';

  @override
  String get s3UploadSuccess => 'バックアップを S3 にアップロードしました';

  @override
  String s3UploadFailed(String error) {
    return 'S3 へのアップロードに失敗しました: $error';
  }

  @override
  String get s3ConfigIncomplete =>
      'Endpoint、Bucket、Access Key、Secret Key を入力してください';

  @override
  String get s3NetworkAccessDenied =>
      'S3 のエンドポイントに接続できません。ネットワークを確認し、システム設定でこのアプリの Wi‑Fi とモバイルデータの使用を許可してください。';

  @override
  String get s3InvalidEndpoint =>
      'Endpoint の URL が無効です。https://your-account.r2.cloudflarestorage.com の形式で入力してください';

  @override
  String get assetTrends => '資産の推移';

  @override
  String get familyTotalNetWorth => '家族の純資産合計';

  @override
  String get viewTrendDetails => '詳細を見る';

  @override
  String get trendDetailsTitle => '推移の詳細';

  @override
  String get trendFilterHint => '1人以上のメンバーと資産タイプを選択すると、合算した純資産を表示できます。';

  @override
  String get allMembers => 'すべてのメンバー';

  @override
  String get allCategories => 'すべてのタイプ';

  @override
  String get wizardStepFx => '為替レートを入力';

  @override
  String get wizardStepBalances => '残高を入力';

  @override
  String get wizardStepPreview => 'プレビューと確認';

  @override
  String get enterValidFxRates => '有効な為替レートを入力してください';

  @override
  String get fetchingFxRates => '最新レートを取得しています…';

  @override
  String get fxRatesAutoFilled => '最新レートを自動入力しました';

  @override
  String get fxFetchFailed => 'レートを自動取得できませんでした。下に手動で入力してください。';

  @override
  String get fetchLatestFxRates => '最新レートを取得';

  @override
  String get retry => '再試行';

  @override
  String get confirmSubmit => '確定';

  @override
  String get next => '次へ';

  @override
  String get previous => '戻る';

  @override
  String get fxSnapshot => '為替レートのスナップショット';

  @override
  String get usdToCnyLabel => '1 USD = ? CNY';

  @override
  String get usdToSgdLabel => '1 USD = ? SGD';

  @override
  String get sourceNoteLabel => '出典メモ（例：銀行アプリ）';

  @override
  String get accountBalances => '口座残高';

  @override
  String get preview => 'プレビュー';

  @override
  String accountBalanceLabel(String name, String symbol) {
    return '$name ($symbol)';
  }

  @override
  String familyNetWorthCurrency(String currency) {
    return '$currency 家族の純資産';
  }

  @override
  String compareWithPrevious(String currency) {
    return '前回の更新との比較（$currency）';
  }

  @override
  String balanceChange(String amount) {
    return '残高の変動: $amount';
  }

  @override
  String fxChange(String amount) {
    return '為替の変動: $amount';
  }

  @override
  String largeChangeTitle(String accountName) {
    return '大きな変動 - $accountName';
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
  String get noteOptional => 'メモ（任意）';

  @override
  String get confirm => '確定';

  @override
  String get familyMembers => '家族メンバー';

  @override
  String get addMember => 'メンバーを追加';

  @override
  String get editMember => 'メンバーを編集';

  @override
  String get nameLabel => '名前';

  @override
  String get delete => '削除';

  @override
  String get deleteAccountTitle => '口座を削除しますか？';

  @override
  String get deleteAccountWarning =>
      'この口座は削除せず、残高を0に更新することをおすすめします。そうすれば履歴が保持されます。\n\nこの口座を削除すると、すべての残高スナップショットと更新履歴が完全に削除されます。';

  @override
  String get deleteAccountConfirm => 'それでも削除';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String get newAccount => '新しい口座';

  @override
  String get editAccount => '口座を編集';

  @override
  String get accountNameLabel => '口座名';

  @override
  String get familyMemberLabel => '家族メンバー';

  @override
  String get accountCategoryLabel => '口座カテゴリ';

  @override
  String get currencyLabel => '通貨';

  @override
  String initialBalanceOptional(String currency) {
    return '初期残高（$currency、任意）';
  }

  @override
  String get enableUpdateReminder => '更新リマインダーを有効にする';

  @override
  String get reminderIntervalLabel => 'リマインダー間隔';

  @override
  String reminderDays(int days) {
    return '$days 日';
  }

  @override
  String get selectMemberFirst => 'メンバーを選択してください';

  @override
  String get accountCategoryCurrent => '普通預金';

  @override
  String get accountCategoryFixedAsset => '固定資産';

  @override
  String get accountCategoryInvestment => '投資';

  @override
  String get accountCategoryLiability => '負債';

  @override
  String get accountCategoryReceivable => '債権';

  @override
  String get changeReasonSalary => '給与';

  @override
  String get changeReasonInvestmentReturn => '投資収益';

  @override
  String get changeReasonRepayment => 'ローン返済';

  @override
  String get changeReasonPurchase => '資産購入';

  @override
  String get changeReasonTransfer => '振替';

  @override
  String get changeReasonGift => '贈与';

  @override
  String get changeReasonFxFluctuation => '為替変動';

  @override
  String get changeReasonOther => 'その他';

  @override
  String get chartRangeAll => 'すべて';

  @override
  String get notificationChannelName => '口座更新リマインダー';

  @override
  String get notificationChannelDescription => '口座残高の定期的な更新リマインダー';

  @override
  String get notificationTitle => '口座更新リマインダー';

  @override
  String notificationBody(String accountName, int days) {
    return '$accountName の残高を更新する時期です（前回の更新は $days 日前）';
  }

  @override
  String get backupWebExportUnsupported =>
      'Web 版は IndexedDB を使用します。ファイルのエクスポートはまだサポートされていません。';

  @override
  String get backupWebImportUnsupported => 'Web 版のインポートはまだサポートされていません。';
}
