import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/app_database.dart';
import '../../data/db/connection/connect.dart';
import '../../data/repositories/repositories.dart';
import '../../domain/currency/currency_converter.dart';
import '../../domain/forecast/linear_forecast.dart';
import '../../domain/models/enums.dart';
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
  (ref) => BackupRepository(),
);

final settingsProvider = StreamProvider<AppSetting>(
  (ref) => ref.watch(settingsRepositoryProvider).watch(),
);

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

final latestFxProvider = FutureProvider<FxSnapshot?>((ref) async {
  return ref.watch(fxRepositoryProvider).latest();
});

final latestConverterProvider = FutureProvider<CurrencyConverter>((ref) async {
  return ref.watch(fxRepositoryProvider).latestConverter();
});

final latestSessionProvider = FutureProvider<UpdateSession?>((ref) async {
  return ref.watch(sessionRepositoryProvider).latest();
});

final familyTrendProvider =
    FutureProvider.family<List<({UpdateSession session, double netWorth})>, ChartRange>(
  (ref, range) async {
    final settings = await ref.watch(settingsRepositoryProvider).get();
    final display = Currency.fromString(settings.displayCurrency);
    final since = range.duration != null
        ? DateTime.now().subtract(range.duration!)
        : null;
    return ref.watch(sessionRepositoryProvider).familyTrend(
          displayCurrency: display,
          since: since,
        );
  },
);

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

final homeSummaryProvider = FutureProvider<HomeSummary>((ref) async {
  final sessionRepo = ref.watch(sessionRepositoryProvider);
  final fxRepo = ref.watch(fxRepositoryProvider);
  final accountRepo = ref.watch(accountRepositoryProvider);
  final settings = await ref.watch(settingsRepositoryProvider).get();
  final display = Currency.fromString(settings.displayCurrency);

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

  final balances = await sessionRepo.balancesForSession(latest.id);
  final converter = await fxRepo.converterForSnapshot(latest.fxSnapshotId);

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
    final prevBalances = await sessionRepo.balancesForSession(previous.id);
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

  final fxSnapshot = await (_dbFxSnapshot(ref, latest.fxSnapshotId));
  final daysSinceUpdate = DateTime.now().difference(latest.recordedAt).inDays;
  final daysSinceFxUpdate =
      fxSnapshot != null ? DateTime.now().difference(fxSnapshot.recordedAt).inDays : null;

  final accounts = await accountRepo.watchActive().first;
  final overdueAccounts = <Account>[];
  for (final account in accounts) {
    final snap = await accountRepo.latestSnapshot(account.id);
    if (snap == null) {
      overdueAccounts.add(account);
      continue;
    }
    final days = DateTime.now().difference(snap.recordedAt).inDays;
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
});

Future<FxSnapshot?> _dbFxSnapshot(Ref ref, int id) async {
  final db = ref.watch(databaseProvider);
  return (db.select(db.fxSnapshots)..where((t) => t.id.equals(id)))
      .getSingleOrNull();
}

final fxHistoryProvider = StreamProvider((ref) {
  return ref.watch(fxRepositoryProvider).watchAll();
});
