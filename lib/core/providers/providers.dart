import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/backup/s3_client.dart';
import '../../data/db/app_database.dart';
import '../../data/fx/fx_rate_service.dart';
import '../../data/db/connection/connect.dart';
import '../../data/repositories/repositories.dart';
import '../../domain/currency/currency_converter.dart';
import '../../domain/forecast/linear_forecast.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/trend_filter.dart';
import '../../domain/net_worth_calculator.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = constructDatabase();
  ref.onDispose(db.close);
  return db;
});

final memberRepositoryProvider = Provider(
  (ref) => MemberRepository(ref.watch(databaseProvider)),
);
final accountRepositoryProvider = Provider(
  (ref) => AccountRepository(ref.watch(databaseProvider)),
);
final fxRepositoryProvider = Provider(
  (ref) => FxRepository(ref.watch(databaseProvider)),
);
final sessionRepositoryProvider = Provider(
  (ref) => SessionRepository(ref.watch(databaseProvider)),
);
final settingsRepositoryProvider = Provider(
  (ref) => SettingsRepository(ref.watch(databaseProvider)),
);
final backupRepositoryProvider = Provider(
  (ref) => BackupRepository(S3Client()),
);
final fxRateServiceProvider = Provider((ref) => FxRateService());

final settingsProvider = StreamProvider<AppSetting>(
  (ref) => ref.watch(settingsRepositoryProvider).watch(),
);

/// The currency the UI should render totals in. Centralizes the "read it from
/// settings, fall back to CNY while loading" logic that was duplicated across
/// many widgets.
final displayCurrencyProvider = Provider<Currency>((ref) {
  final settings = ref.watch(settingsProvider).valueOrNull;
  return settings != null
      ? Currency.fromString(settings.displayCurrency)
      : Currency.cny;
});

final membersProvider = StreamProvider(
  (ref) => ref.watch(memberRepositoryProvider).watchAll(),
);

final accountsProvider = StreamProvider(
  (ref) => ref.watch(accountRepositoryProvider).watchActive(),
);

final accountProvider = FutureProvider.family<Account?, int>((ref, id) {
  return ref.watch(accountRepositoryProvider).getById(id);
});

final accountSnapshotsProvider =
    StreamProvider.family<List<BalanceSnapshot>, int>((ref, accountId) {
  return ref.watch(accountRepositoryProvider).watchSnapshots(accountId);
});

/// Recomputes [compute] once now and again on every dashboard-relevant write,
/// turning a one-shot query into a stream that keeps derived UI in sync.
Stream<T> _watchDashboard<T>(
  AppDatabase db,
  Future<T> Function() compute,
) async* {
  yield await compute();
  await for (final _ in db.dashboardChanges()) {
    yield await compute();
  }
}

final latestFxProvider = StreamProvider<FxSnapshot?>((ref) {
  final db = ref.watch(databaseProvider);
  final repo = ref.watch(fxRepositoryProvider);
  return _watchDashboard(db, repo.latest);
});

final latestConverterProvider = StreamProvider<CurrencyConverter>((ref) {
  final db = ref.watch(databaseProvider);
  final repo = ref.watch(fxRepositoryProvider);
  return _watchDashboard(db, repo.latestConverter);
});

final latestSessionProvider = StreamProvider<UpdateSession?>((ref) {
  final db = ref.watch(databaseProvider);
  final repo = ref.watch(sessionRepositoryProvider);
  return _watchDashboard(db, repo.latest);
});

/// Parameters for [familyTrendProvider]: the visible time window plus an
/// optional multi-select [TrendFilter] by family members and asset categories.
/// An empty filter means "all".
typedef TrendQuery = ({
  ChartRange range,
  TrendFilter filter,
});

final familyTrendProvider = StreamProvider.family<
    List<({UpdateSession session, double netWorth})>, TrendQuery>(
  (ref, query) {
    final display = ref.watch(displayCurrencyProvider);
    final since = query.range.duration != null
        ? DateTime.now().subtract(query.range.duration!)
        : null;
    return ref.watch(sessionRepositoryProvider).watchFamilyTrend(
          displayCurrency: display,
          since: since,
          memberIds: query.filter.memberIds,
          categories: query.filter.categories,
        );
  },
);

/// Aggregated state for the home dashboard.
class HomeSummary {
  HomeSummary({
    required this.netWorthByCurrency,
    required this.displayCurrency,
    required this.changeFromPreviousByCurrency,
    required this.daysSinceUpdate,
    required this.daysSinceFxUpdate,
    required this.overdueAccounts,
    required this.forecast,
  });

  final Map<Currency, double> netWorthByCurrency;
  final Currency displayCurrency;
  final Map<Currency, double?> changeFromPreviousByCurrency;
  final int? daysSinceUpdate;
  final int? daysSinceFxUpdate;
  final List<Account> overdueAccounts;
  final LinearForecastResult? forecast;
}

/// Reactive home summary: recomputes whenever settings or any dashboard table
/// change, so the displayed net worth can never go stale (the bug this refactor
/// targets). Net worth is precomputed for every currency so toggling the
/// display currency is instant and does not hit the database again.
final homeSummaryProvider = StreamProvider<HomeSummary>((ref) {
  final settings = ref.watch(settingsProvider).valueOrNull;
  if (settings == null) return const Stream<HomeSummary>.empty();

  final db = ref.watch(databaseProvider);
  final display = Currency.fromString(settings.displayCurrency);
  final sessionRepo = ref.watch(sessionRepositoryProvider);
  final fxRepo = ref.watch(fxRepositoryProvider);
  final accountRepo = ref.watch(accountRepositoryProvider);

  return _watchDashboard(
    db,
    () => _computeHomeSummary(
      sessionRepo: sessionRepo,
      fxRepo: fxRepo,
      accountRepo: accountRepo,
      display: display,
    ),
  );
});

Future<HomeSummary> _computeHomeSummary({
  required SessionRepository sessionRepo,
  required FxRepository fxRepo,
  required AccountRepository accountRepo,
  required Currency display,
}) async {
  final latest = await sessionRepo.latest();
  if (latest == null) {
    return HomeSummary(
      netWorthByCurrency: {for (final c in Currency.values) c: 0},
      displayCurrency: display,
      changeFromPreviousByCurrency: {for (final c in Currency.values) c: null},
      daysSinceUpdate: null,
      daysSinceFxUpdate: null,
      overdueAccounts: [],
      forecast: null,
    );
  }

  final balances = await sessionRepo.balancesLatest();
  final converter = await fxRepo.latestConverter();

  final netWorthByCurrency = {
    for (final c in Currency.values)
      c: NetWorthCalculator.familyNetWorth(
        balances: balances,
        converter: converter,
        displayCurrency: c,
      ),
  };

  final changeFromPreviousByCurrency = <Currency, double?>{
    for (final c in Currency.values) c: null,
  };
  final previous = await sessionRepo.previous(latest);
  if (previous != null) {
    final prevBalances = await sessionRepo.balancesAsOfSession(previous);
    final prevConverter =
        await fxRepo.converterForSnapshot(previous.fxSnapshotId);
    for (final c in Currency.values) {
      final prevNet = NetWorthCalculator.familyNetWorth(
        balances: prevBalances,
        converter: prevConverter,
        displayCurrency: c,
      );
      changeFromPreviousByCurrency[c] = netWorthByCurrency[c]! - prevNet;
    }
  }

  final fxSnapshot = await fxRepo.snapshotById(latest.fxSnapshotId);
  final now = DateTime.now();
  final daysSinceUpdate = now.difference(latest.recordedAt).inDays;
  final daysSinceFxUpdate = fxSnapshot != null
      ? now.difference(fxSnapshot.recordedAt).inDays
      : null;

  // One query for the latest snapshot of every account, instead of one query
  // per account.
  final accounts = await accountRepo.watchActive().first;
  final latestByAccount = await accountRepo.latestSnapshotByAccount();
  final overdueAccounts = <Account>[];
  for (final account in accounts) {
    final snap = latestByAccount[account.id];
    if (snap == null) {
      overdueAccounts.add(account);
      continue;
    }
    final days = now.difference(snap.recordedAt).inDays;
    if (account.reminderEnabled && days >= account.reminderIntervalDays) {
      overdueAccounts.add(account);
    }
  }

  final trend = await sessionRepo.familyTrend(displayCurrency: display);
  final forecast = LinearForecast.compute(
    history: trend
        .map((e) => (date: e.session.recordedAt, value: e.netWorth))
        .toList(),
    forwardDays: const [30, 90],
  );

  return HomeSummary(
    netWorthByCurrency: netWorthByCurrency,
    displayCurrency: display,
    changeFromPreviousByCurrency: changeFromPreviousByCurrency,
    daysSinceUpdate: daysSinceUpdate,
    daysSinceFxUpdate: daysSinceFxUpdate,
    overdueAccounts: overdueAccounts,
    forecast: forecast,
  );
}

final fxHistoryProvider = StreamProvider((ref) {
  return ref.watch(fxRepositoryProvider).watchAll();
});
