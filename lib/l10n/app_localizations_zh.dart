// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '家庭资产';

  @override
  String get navHome => '首页';

  @override
  String get navAccounts => '账户';

  @override
  String get navCharts => '走势';

  @override
  String get navFx => '汇率';

  @override
  String get navSettings => '设置';

  @override
  String get updateBalances => '更新余额';

  @override
  String loadFailed(String error) {
    return '加载失败: $error';
  }

  @override
  String get accountNotFound => '账户不存在';

  @override
  String get changeReason => '变动原因';

  @override
  String get close => '关闭';

  @override
  String get noSnapshots => '暂无快照';

  @override
  String get nativeCurrency => '原币';

  @override
  String get noDataUpdateFirst => '暂无数据，请先更新余额';

  @override
  String get familyNetWorth => '家庭净值';

  @override
  String changeSinceLast(String amount) {
    return '较上次 $amount';
  }

  @override
  String daysSinceUpdate(int days) {
    return '距上次更新 $days 天';
  }

  @override
  String get fxMayBeStale => '汇率可能已过期';

  @override
  String fxLastRecordedDaysAgo(int days) {
    return '上次录入 $days 天前，建议更新';
  }

  @override
  String get goUpdate => '去更新';

  @override
  String get familyTrend => '家庭走势';

  @override
  String get accountsToUpdate => '待更新账户';

  @override
  String overdueDays(int days) {
    return '已超过 $days 天周期';
  }

  @override
  String get trendForecast => '趋势预测';

  @override
  String forecastDescription(String amount) {
    return '按近 6 个月趋势，预计约 3 个月后家庭净值约 $amount';
  }

  @override
  String get forecastDisclaimer => '仅供参考，不构成投资建议';

  @override
  String get accountsTitle => '账户';

  @override
  String get noAccountsHint => '暂无账户，点击 + 添加';

  @override
  String get unknownMember => '未知成员';

  @override
  String approxAmount(String amount) {
    return '≈ $amount';
  }

  @override
  String get fxHistory => '汇率历史';

  @override
  String get noFxRecords => '暂无汇率记录';

  @override
  String get settingsTitle => '设置';

  @override
  String get language => '语言';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageChinese => '中文';

  @override
  String get displaySettings => '展示设置';

  @override
  String get largeChangeThresholds => '大额变动阈值';

  @override
  String get changePercentLabel => '变动百分比 (%)';

  @override
  String get changeAmountLabel => '变动金额（展示币种）';

  @override
  String get saveThresholds => '保存阈值';

  @override
  String get thresholdsSaved => '阈值已保存';

  @override
  String get dataBackup => '数据备份';

  @override
  String exportFailed(String error) {
    return '导出失败: $error';
  }

  @override
  String get exportLocalBackup => '导出本地备份';

  @override
  String get importCompleteRestart => '导入完成，请重启应用';

  @override
  String get importBackup => '导入备份';

  @override
  String get importBackupConfirmTitle => '恢复备份？';

  @override
  String get importBackupConfirmMessage => '将用所选备份文件替换当前所有数据，此操作不可撤销。';

  @override
  String get importCancelled => '已取消导入';

  @override
  String importFailed(String error) {
    return '导入失败：$error';
  }

  @override
  String get invalidBackupFile => '所选文件不是有效的 ASM 数据库备份';

  @override
  String get backupFileUnreadable => '无法读取所选文件，请先保存到本地后再导入';

  @override
  String get s3BackupReserved => 'S3 备份';

  @override
  String get s3Backup => 'S3 备份';

  @override
  String get s3Endpoint => 'Endpoint';

  @override
  String get s3Bucket => 'Bucket';

  @override
  String get s3AccessKey => 'Access Key';

  @override
  String get s3SecretKey => 'Secret Key';

  @override
  String get s3Prefix => 'Object Key 前缀';

  @override
  String get saveS3Config => '保存 S3 配置';

  @override
  String get s3ConfigSaved => 'S3 配置已保存';

  @override
  String get s3Upload => '上传到 S3';

  @override
  String get s3UploadSuccess => '备份已上传到 S3';

  @override
  String s3UploadFailed(String error) {
    return 'S3 上传失败：$error';
  }

  @override
  String get s3ConfigIncomplete =>
      '请填写 Endpoint、Bucket、Access Key 和 Secret Key';

  @override
  String get s3NetworkAccessDenied =>
      '无法连接 S3 Endpoint，请检查网络并在系统设置中允许本应用使用 WLAN 和移动数据。';

  @override
  String get s3InvalidEndpoint =>
      'Endpoint 格式无效，请填写类似 https://账号ID.r2.cloudflarestorage.com';

  @override
  String get assetTrends => '资产走势';

  @override
  String get familyTotalNetWorth => '家庭总净值';

  @override
  String get viewTrendDetails => '查看细节';

  @override
  String get trendDetailsTitle => '走势详情';

  @override
  String get trendFilterHint => '可多选家庭成员和资产类型，合并查看对应净值变化。';

  @override
  String get allMembers => '全部成员';

  @override
  String get allCategories => '全部类型';

  @override
  String get wizardStepFx => '录入汇率';

  @override
  String get wizardStepBalances => '录入余额';

  @override
  String get wizardStepPreview => '预览确认';

  @override
  String get enterValidFxRates => '请输入有效汇率';

  @override
  String get fetchingFxRates => '正在获取最新汇率…';

  @override
  String get fxRatesAutoFilled => '已自动填入最新汇率';

  @override
  String get fxFetchFailed => '无法自动获取汇率，请在下方手动输入。';

  @override
  String get fetchLatestFxRates => '获取最新汇率';

  @override
  String get retry => '重试';

  @override
  String get confirmSubmit => '确认提交';

  @override
  String get next => '下一步';

  @override
  String get previous => '上一步';

  @override
  String get fxSnapshot => '汇率快照';

  @override
  String get usdToCnyLabel => '1 USD = ? CNY';

  @override
  String get usdToSgdLabel => '1 USD = ? SGD';

  @override
  String get sourceNoteLabel => '来源备注（如：中国银行 App）';

  @override
  String get accountBalances => '账户余额';

  @override
  String get preview => '预览';

  @override
  String accountBalanceLabel(String name, String symbol) {
    return '$name ($symbol)';
  }

  @override
  String familyNetWorthCurrency(String currency) {
    return '$currency 家庭净值';
  }

  @override
  String compareWithPrevious(String currency) {
    return '与上次对比（$currency）';
  }

  @override
  String balanceChange(String amount) {
    return '余额变动: $amount';
  }

  @override
  String fxChange(String amount) {
    return '汇率变动: $amount';
  }

  @override
  String largeChangeTitle(String accountName) {
    return '大额变动 - $accountName';
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
  String get noteOptional => '备注（可选）';

  @override
  String get confirm => '确认';

  @override
  String get familyMembers => '家庭成员';

  @override
  String get addMember => '添加成员';

  @override
  String get editMember => '编辑成员';

  @override
  String get nameLabel => '姓名';

  @override
  String get delete => '删除';

  @override
  String get deleteAccountTitle => '删除账户？';

  @override
  String get deleteAccountWarning =>
      '建议保留此账户并将余额更新为 0，而不是删除，这样可以保留历史记录。\n\n如果删除此账户，其所有余额快照和更新记录将被永久删除。';

  @override
  String get deleteAccountConfirm => '仍然删除';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get newAccount => '新建账户';

  @override
  String get editAccount => '编辑账户';

  @override
  String get accountNameLabel => '账户名称';

  @override
  String get familyMemberLabel => '家庭成员';

  @override
  String get accountCategoryLabel => '账户类别';

  @override
  String get currencyLabel => '币种';

  @override
  String initialBalanceOptional(String currency) {
    return '初始余额（$currency，可选）';
  }

  @override
  String get enableUpdateReminder => '启用更新提醒';

  @override
  String get reminderIntervalLabel => '提醒周期';

  @override
  String reminderDays(int days) {
    return '$days 天';
  }

  @override
  String get selectMemberFirst => '请选择成员';

  @override
  String get accountCategoryCurrent => '活期';

  @override
  String get accountCategoryFixedAsset => '固定资产';

  @override
  String get accountCategoryInvestment => '投资理财';

  @override
  String get accountCategoryLiability => '负债';

  @override
  String get accountCategoryReceivable => '债权';

  @override
  String get changeReasonSalary => '工资收入';

  @override
  String get changeReasonInvestmentReturn => '投资收益';

  @override
  String get changeReasonRepayment => '还贷';

  @override
  String get changeReasonPurchase => '购置资产';

  @override
  String get changeReasonTransfer => '转账';

  @override
  String get changeReasonGift => '赠予';

  @override
  String get changeReasonFxFluctuation => '汇率波动';

  @override
  String get changeReasonOther => '其他';

  @override
  String get chartRangeAll => '全部';

  @override
  String get notificationChannelName => '账户更新提醒';

  @override
  String get notificationChannelDescription => '周期提醒更新账户余额';

  @override
  String get notificationTitle => '账户更新提醒';

  @override
  String notificationBody(String accountName, int days) {
    return '该更新【$accountName】余额了（上次更新 $days 天前）';
  }

  @override
  String get backupWebExportUnsupported => 'Web 端请使用浏览器 IndexedDB，暂不支持文件导出';

  @override
  String get backupWebImportUnsupported => 'Web 端暂不支持导入本地备份文件';
}
