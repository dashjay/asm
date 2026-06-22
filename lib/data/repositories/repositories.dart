import 'package:drift/drift.dart';

import '../../core/app_constants.dart';
import '../../domain/currency/currency_converter.dart';
import '../../domain/currency/fx_defaults.dart';
import '../../domain/models/enums.dart';
import '../../domain/net_worth_calculator.dart';
import '../db/app_database.dart';
import '../backup/s3_client.dart';

/// CRUD for family members. Deleting a member cascades to their accounts and
/// the related balance snapshots so no orphaned money lingers in totals.
class MemberRepository {
  MemberRepository(this._db);

  final AppDatabase _db;

  Stream<List<FamilyMember>> watchAll() =>
      (_db.select(_db.familyMembers)
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  Future<int> create(String name, {int avatarColor = 0xFF6750A4}) {
    return _db.into(_db.familyMembers).insert(
          FamilyMembersCompanion.insert(
            name: name,
            avatarColor: Value(avatarColor),
          ),
        );
  }

  Future<void> update(int id, String name) {
    return (_db.update(_db.familyMembers)..where((t) => t.id.equals(id))).write(
      FamilyMembersCompanion(name: Value(name)),
    );
  }

  Future<void> delete(int id) async {
    final accountIds = await (_db.select(_db.accounts)
          ..where((t) => t.memberId.equals(id)))
        .map((a) => a.id)
        .get();
    for (final accountId in accountIds) {
      await (_db.delete(_db.balanceSnapshots)
            ..where((t) => t.accountId.equals(accountId)))
          .go();
      await (_db.delete(_db.accounts)..where((t) => t.id.equals(accountId)))
          .go();
    }
    await (_db.delete(_db.familyMembers)..where((t) => t.id.equals(id))).go();
  }
}

/// CRUD for accounts plus access to their balance-snapshot history.
class AccountRepository {
  AccountRepository(this._db);

  final AppDatabase _db;

  Stream<List<Account>> watchActive() => (_db.select(_db.accounts)
        ..where((t) => t.isArchived.equals(false))
        ..orderBy([(t) => OrderingTerm.asc(t.name)]))
      .watch();

  Stream<List<Account>> watchAll() =>
      (_db.select(_db.accounts)..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .watch();

  Future<Account?> getById(int id) =>
      (_db.select(_db.accounts)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> create({
    required int memberId,
    required String name,
    required AccountCategory category,
    required Currency currency,
    int reminderIntervalDays = 30,
    double? initialBalance,
  }) async {
    final id = await _db.into(_db.accounts).insert(
          AccountsCompanion.insert(
            memberId: memberId,
            name: name,
            category: category.name,
            currency: currency.name,
            reminderIntervalDays: Value(reminderIntervalDays),
          ),
        );

    if (initialBalance != null) {
      await _createInitialSnapshot(id, initialBalance);
    }
    return id;
  }

  /// Records the opening balance as its own session so the account immediately
  /// shows up in net-worth totals and history.
  Future<void> _createInitialSnapshot(int accountId, double amount) async {
    final fx = await FxRepository(_db).latestOrSeeded();
    final sessionId = await _db.into(_db.updateSessions).insert(
          UpdateSessionsCompanion.insert(
            fxSnapshotId: fx.id,
            note: const Value(kInitialBalanceNote),
          ),
        );
    await _db.into(_db.balanceSnapshots).insert(
          BalanceSnapshotsCompanion.insert(
            accountId: accountId,
            updateSessionId: sessionId,
            amount: amount,
          ),
        );
  }

  Future<void> update({
    required int id,
    required String name,
    required AccountCategory category,
    required Currency currency,
    required bool reminderEnabled,
    required int reminderIntervalDays,
  }) {
    return (_db.update(_db.accounts)..where((t) => t.id.equals(id))).write(
      AccountsCompanion(
        name: Value(name),
        category: Value(category.name),
        currency: Value(currency.name),
        reminderEnabled: Value(reminderEnabled),
        reminderIntervalDays: Value(reminderIntervalDays),
      ),
    );
  }

  Future<void> archive(int id) {
    return (_db.update(_db.accounts)..where((t) => t.id.equals(id))).write(
      const AccountsCompanion(isArchived: Value(true)),
    );
  }

  Future<void> delete(int id) async {
    await (_db.delete(_db.balanceSnapshots)
          ..where((t) => t.accountId.equals(id)))
        .go();
    await (_db.delete(_db.accounts)..where((t) => t.id.equals(id))).go();
  }

  Future<BalanceSnapshot?> latestSnapshot(int accountId) {
    return (_db.select(_db.balanceSnapshots)
          ..where((t) => t.accountId.equals(accountId))
          ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Returns the most recent snapshot for every account in a single query.
  ///
  /// Replaces the previous per-account fan-out (one query per account) used by
  /// the home dashboard, which scaled poorly as accounts grew.
  Future<Map<int, BalanceSnapshot>> latestSnapshotByAccount() async {
    final snapshots = await (_db.select(_db.balanceSnapshots)
          ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)]))
        .get();
    final result = <int, BalanceSnapshot>{};
    for (final snapshot in snapshots) {
      result.putIfAbsent(snapshot.accountId, () => snapshot);
    }
    return result;
  }

  Stream<List<BalanceSnapshot>> watchSnapshots(int accountId) {
    return (_db.select(_db.balanceSnapshots)
          ..where((t) => t.accountId.equals(accountId))
          ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)]))
        .watch();
  }
}

/// Reads and writes FX snapshots and exposes ready-to-use [CurrencyConverter]s.
class FxRepository {
  FxRepository(this._db);

  final AppDatabase _db;

  Stream<List<FxSnapshot>> watchAll() => (_db.select(_db.fxSnapshots)
        ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)]))
      .watch();

  Future<FxSnapshot?> latest() => (_db.select(_db.fxSnapshots)
        ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)])
        ..limit(1))
      .getSingleOrNull();

  Future<FxSnapshot?> snapshotById(int id) =>
      (_db.select(_db.fxSnapshots)..where((t) => t.id.equals(id)))
          .getSingleOrNull();

  /// Returns the latest snapshot, creating a default one (using the fallback
  /// rates) if none exists yet so callers always have a valid FX reference.
  Future<FxSnapshot> latestOrSeeded() async {
    final existing = await latest();
    if (existing != null) return existing;
    final id = await _db.insertFxSnapshot();
    return (await snapshotById(id))!;
  }

  /// Persists an FX snapshot together with its USD->CNY and USD->SGD rates.
  ///
  /// This is the single source of truth for "what an FX snapshot looks like",
  /// replacing three near-identical copies that previously lived in repositories.
  Future<int> insertSnapshot({
    double? usdToCny,
    double? usdToSgd,
    DateTime? recordedAt,
    String? sourceNote,
  }) {
    return _db.insertFxSnapshot(
      usdToCny: usdToCny,
      usdToSgd: usdToSgd,
      recordedAt: recordedAt,
      sourceNote: sourceNote,
    );
  }

  Future<List<FxRate>> ratesForSnapshot(int fxSnapshotId) =>
      (_db.select(_db.fxRates)
            ..where((t) => t.fxSnapshotId.equals(fxSnapshotId)))
          .get();

  Future<CurrencyConverter> converterForSnapshot(int fxSnapshotId) async {
    final rates = await ratesForSnapshot(fxSnapshotId);
    return CurrencyConverter.fromRateRows(
      rates
          .map((r) => (from: r.fromCurrency, to: r.toCurrency, rate: r.rate))
          .toList(),
    );
  }

  Future<CurrencyConverter> latestConverter() async {
    final snapshot = await latest();
    if (snapshot == null) {
      return CurrencyConverter.fromUsdRates(
        usdToCny: kDefaultUsdToCny,
        usdToSgd: kDefaultUsdToSgd,
      );
    }
    return converterForSnapshot(snapshot.id);
  }
}

/// Update sessions group the balance changes recorded at one point in time and
/// own the heavier aggregate queries used by the dashboard and charts.
class SessionRepository {
  SessionRepository(this._db);

  final AppDatabase _db;

  Stream<List<UpdateSession>> watchAll() => (_db.select(_db.updateSessions)
        ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)]))
      .watch();

  Future<UpdateSession?> latest() => (_db.select(_db.updateSessions)
        ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)])
        ..limit(1))
      .getSingleOrNull();

  Future<UpdateSession?> previous(UpdateSession session) =>
      (_db.select(_db.updateSessions)
            ..where((t) => t.recordedAt.isSmallerThanValue(session.recordedAt))
            ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)])
            ..limit(1))
          .getSingleOrNull();

  Future<List<BalanceSnapshot>> snapshotsForSession(int sessionId) =>
      (_db.select(_db.balanceSnapshots)
            ..where((t) => t.updateSessionId.equals(sessionId)))
          .get();

  /// Creates a new snapshot session: persists the FX rates, then one balance
  /// snapshot per account with its delta vs. the previous value.
  Future<int> createSession({
    required double usdToCny,
    required double usdToSgd,
    required String sourceNote,
    required Map<int, double> accountAmounts,
    required Map<int, ({ChangeReason? reason, String? note})> changeMeta,
  }) async {
    return _db.transaction(() async {
      final fxId = await _db.insertFxSnapshot(
        usdToCny: usdToCny,
        usdToSgd: usdToSgd,
        sourceNote: sourceNote,
      );

      final sessionId = await _db.into(_db.updateSessions).insert(
            UpdateSessionsCompanion.insert(fxSnapshotId: fxId),
          );

      // Bulk-load the previous snapshot for every affected account up front
      // instead of querying once per account inside the loop.
      final accountIds = accountAmounts.keys.toList();
      final previousByAccount = <int, BalanceSnapshot>{};
      if (accountIds.isNotEmpty) {
        final priorSnapshots = await (_db.select(_db.balanceSnapshots)
              ..where((t) => t.accountId.isIn(accountIds))
              ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)]))
            .get();
        for (final snapshot in priorSnapshots) {
          previousByAccount.putIfAbsent(snapshot.accountId, () => snapshot);
        }
      }

      final inserts = <BalanceSnapshotsCompanion>[];
      for (final entry in accountAmounts.entries) {
        final previous = previousByAccount[entry.key];

        double? delta;
        double? deltaPercent;
        if (previous != null) {
          delta = entry.value - previous.amount;
          deltaPercent =
              previous.amount == 0 ? null : (delta / previous.amount) * 100;
        }

        final meta = changeMeta[entry.key];
        inserts.add(
          BalanceSnapshotsCompanion.insert(
            accountId: entry.key,
            updateSessionId: sessionId,
            amount: entry.value,
            changeReason: Value(meta?.reason?.name),
            changeReasonText: Value(meta?.note ?? ''),
            deltaFromPrevious: Value(delta),
            deltaPercent: Value(deltaPercent),
          ),
        );
      }

      await _db.batch((batch) => batch.insertAll(_db.balanceSnapshots, inserts));
      return sessionId;
    });
  }

  Future<List<AccountBalance>> balancesForSession(int sessionId) async {
    final snapshots = await snapshotsForSession(sessionId);
    final accounts = await _db.select(_db.accounts).get();
    final accountMap = {for (final a in accounts) a.id: a};
    return snapshots
        .where((s) => accountMap.containsKey(s.accountId))
        .map((s) {
      final account = accountMap[s.accountId]!;
      return AccountBalance(
        accountId: s.accountId,
        category: AccountCategory.fromString(account.category),
        currency: Currency.fromString(account.currency),
        amount: s.amount,
      );
    }).toList();
  }

  /// Latest known balance per active account, used for current net-worth totals.
  ///
  /// Unlike [balancesForSession], this spans all update sessions so a
  /// single-account initial snapshot session cannot hide other accounts.
  Future<List<AccountBalance>> balancesLatest() async {
    final snapshots = await (_db.select(_db.balanceSnapshots)
          ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)]))
        .get();
    final latestByAccount = <int, BalanceSnapshot>{};
    for (final snapshot in snapshots) {
      latestByAccount.putIfAbsent(snapshot.accountId, () => snapshot);
    }

    final accounts = await (_db.select(_db.accounts)
          ..where((t) => t.isArchived.equals(false)))
        .get();

    return [
      for (final account in accounts)
        if (latestByAccount.containsKey(account.id))
          AccountBalance(
            accountId: account.id,
            category: AccountCategory.fromString(account.category),
            currency: Currency.fromString(account.currency),
            amount: latestByAccount[account.id]!.amount,
          ),
    ];
  }

  /// Cumulative latest balance per active account as of [session] (inclusive).
  ///
  /// Walks every snapshot recorded in [session] or an earlier session and keeps
  /// the most recent value per account, mirroring the running total in
  /// [familyTrend]. Unlike [balancesForSession] this is symmetric with
  /// [balancesLatest], so comparing the latest total against an earlier session
  /// (e.g. the home "change since last" delta) no longer treats accounts that
  /// were not part of that one session as if they had a zero balance. Adding a
  /// brand-new account in its own single-account session therefore reports a
  /// delta of just that account's value instead of the whole family total.
  Future<List<AccountBalance>> balancesAsOfSession(UpdateSession session) async {
    final sessions = await (_db.select(_db.updateSessions)
          ..orderBy([
            (t) => OrderingTerm.asc(t.recordedAt),
            (t) => OrderingTerm.asc(t.id),
          ]))
        .get();

    final allSnapshots = await _db.select(_db.balanceSnapshots).get();
    final snapshotsBySession = <int, List<BalanceSnapshot>>{};
    for (final snapshot in allSnapshots) {
      snapshotsBySession
          .putIfAbsent(snapshot.updateSessionId, () => [])
          .add(snapshot);
    }

    final accounts = await (_db.select(_db.accounts)
          ..where((t) => t.isArchived.equals(false)))
        .get();
    final accountMap = {for (final a in accounts) a.id: a};

    final latestByAccount = <int, BalanceSnapshot>{};
    for (final s in sessions) {
      for (final snapshot
          in snapshotsBySession[s.id] ?? const <BalanceSnapshot>[]) {
        if (accountMap.containsKey(snapshot.accountId)) {
          latestByAccount[snapshot.accountId] = snapshot;
        }
      }
      if (s.id == session.id) break;
    }

    return [
      for (final account in accounts)
        if (latestByAccount.containsKey(account.id))
          AccountBalance(
            accountId: account.id,
            category: AccountCategory.fromString(account.category),
            currency: Currency.fromString(account.currency),
            amount: latestByAccount[account.id]!.amount,
          ),
    ];
  }

  /// Computes the family net worth trend, emitting at most one point per
  /// calendar day (the last session of that day).
  ///
  /// Net worth at each point reflects the cumulative latest balance per
  /// account as of that day, so many accounts created on the same day
  /// collapse to a single chart dot instead of one per initial snapshot.
  ///
  /// Performance: loads all sessions, snapshots, accounts and FX rates in four
  /// queries and joins them in memory, rather than issuing several queries per
  /// session (the previous O(sessions) query storm).
  /// [memberIds] and [categories] are optional multi-select filters. An empty
  /// set means "all" for that dimension; the two combine with AND.
  Future<List<({UpdateSession session, double netWorth})>> familyTrend({
    required Currency displayCurrency,
    DateTime? since,
    Set<int> memberIds = const {},
    Set<AccountCategory> categories = const {},
  }) async {
    final allSessions = await (_db.select(_db.updateSessions)
          ..orderBy([(t) => OrderingTerm.asc(t.recordedAt)]))
        .get();
    if (allSessions.isEmpty) return [];

    final accounts = await _db.select(_db.accounts).get();
    final accountMap = {for (final a in accounts) a.id: a};

    final allSnapshots = await _db.select(_db.balanceSnapshots).get();
    final snapshotsBySession = <int, List<BalanceSnapshot>>{};
    for (final snapshot in allSnapshots) {
      snapshotsBySession
          .putIfAbsent(snapshot.updateSessionId, () => [])
          .add(snapshot);
    }

    final allRates = await _db.select(_db.fxRates).get();
    final rateRowsBySnapshot =
        <int, List<({String from, String to, double rate})>>{};
    for (final rate in allRates) {
      rateRowsBySnapshot.putIfAbsent(rate.fxSnapshotId, () => []).add(
            (from: rate.fromCurrency, to: rate.toCurrency, rate: rate.rate),
          );
    }

    final latestByAccount = <int, BalanceSnapshot>{};
    if (since != null) {
      for (final session in allSessions) {
        if (session.recordedAt.isAfter(since)) continue;
        for (final snapshot in snapshotsBySession[session.id] ?? const []) {
          if (accountMap.containsKey(snapshot.accountId)) {
            latestByAccount[snapshot.accountId] = snapshot;
          }
        }
      }
    }

    final sessions = since == null
        ? allSessions
        : allSessions.where((s) => s.recordedAt.isAfter(since)).toList();
    if (sessions.isEmpty) return [];

    final converterCache = <int, CurrencyConverter>{};
    final result = <({UpdateSession session, double netWorth})>[];
    for (var i = 0; i < sessions.length; i++) {
      final session = sessions[i];
      for (final snapshot in snapshotsBySession[session.id] ?? const []) {
        if (accountMap.containsKey(snapshot.accountId)) {
          latestByAccount[snapshot.accountId] = snapshot;
        }
      }

      final isLastSessionOfDay = i == sessions.length - 1 ||
          !_isSameCalendarDay(
            session.recordedAt,
            sessions[i + 1].recordedAt,
          );
      if (!isLastSessionOfDay) continue;

      final balances = [
        for (final account in accounts)
          if (!account.isArchived &&
              latestByAccount.containsKey(account.id) &&
              (memberIds.isEmpty || memberIds.contains(account.memberId)) &&
              (categories.isEmpty ||
                  categories.contains(
                      AccountCategory.fromString(account.category))))
            AccountBalance(
              accountId: account.id,
              category: AccountCategory.fromString(account.category),
              currency: Currency.fromString(account.currency),
              amount: latestByAccount[account.id]!.amount,
            ),
      ];

      final converter = converterCache.putIfAbsent(
        session.fxSnapshotId,
        () => CurrencyConverter.fromRateRows(
          rateRowsBySnapshot[session.fxSnapshotId] ?? const [],
        ),
      );

      result.add((
        session: session,
        netWorth: NetWorthCalculator.familyNetWorth(
          balances: balances,
          converter: converter,
          displayCurrency: displayCurrency,
        ),
      ));
    }
    return result;
  }

  /// Reactive variant of [familyTrend] that re-emits whenever any dashboard
  /// table changes, so charts and forecasts stay in sync automatically.
  Stream<List<({UpdateSession session, double netWorth})>> watchFamilyTrend({
    required Currency displayCurrency,
    DateTime? since,
    Set<int> memberIds = const {},
    Set<AccountCategory> categories = const {},
  }) async* {
    yield await familyTrend(
      displayCurrency: displayCurrency,
      since: since,
      memberIds: memberIds,
      categories: categories,
    );
    await for (final _ in _db.dashboardChanges()) {
      yield await familyTrend(
        displayCurrency: displayCurrency,
        since: since,
        memberIds: memberIds,
        categories: categories,
      );
    }
  }
}

/// Single-row application settings (display currency, thresholds, locale, S3).
class SettingsRepository {
  SettingsRepository(this._db);

  final AppDatabase _db;

  Stream<AppSetting> watch() =>
      _db.select(_db.appSettings).watchSingle();

  Future<AppSetting> get() => _db.select(_db.appSettings).getSingle();

  Future<void> updateDisplayCurrency(Currency currency) {
    return (_db.update(_db.appSettings)..where((t) => t.id.equals(1))).write(
      AppSettingsCompanion(displayCurrency: Value(currency.name)),
    );
  }

  Future<void> updateThresholds({
    required double percent,
    required double amount,
  }) {
    return (_db.update(_db.appSettings)..where((t) => t.id.equals(1))).write(
      AppSettingsCompanion(
        largeChangeThresholdPercent: Value(percent),
        largeChangeThresholdAmount: Value(amount),
      ),
    );
  }

  Future<void> updateS3Config({
    required String endpoint,
    required String bucket,
    required String accessKey,
    required String prefix,
  }) {
    return (_db.update(_db.appSettings)..where((t) => t.id.equals(1))).write(
      AppSettingsCompanion(
        s3Endpoint: Value(endpoint),
        s3Bucket: Value(bucket),
        s3AccessKey: Value(accessKey),
        s3Prefix: Value(prefix),
      ),
    );
  }

  Future<void> updateLocale(String languageCode) {
    return (_db.update(_db.appSettings)..where((t) => t.id.equals(1))).write(
      AppSettingsCompanion(localeLanguageCode: Value(languageCode)),
    );
  }
}

/// S3 backup upload via path-style PUT (import from S3 not yet implemented).
class BackupRepository {
  BackupRepository(this._s3Client);

  final S3Client _s3Client;

  Future<void> exportToS3({
    required S3Config config,
    required String localFilePath,
    required String objectKey,
  }) {
    return _s3Client.putObject(
      endpoint: config.endpoint,
      bucket: config.bucket,
      accessKey: config.accessKey,
      secretKey: config.secretKey,
      objectKey: objectKey,
      localFilePath: localFilePath,
    );
  }

  Future<void> importFromS3(S3Config config) {
    throw UnimplementedError('S3 import coming soon');
  }
}

class S3Config {
  S3Config({
    required this.endpoint,
    required this.bucket,
    required this.accessKey,
    required this.secretKey,
    required this.prefix,
  });

  final String endpoint;
  final String bucket;
  final String accessKey;
  final String secretKey;
  final String prefix;
}

bool _isSameCalendarDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;
