import 'package:drift/drift.dart';

import '../../domain/currency/currency_converter.dart';
import '../../domain/models/enums.dart';
import '../../domain/net_worth_calculator.dart';
import '../db/app_database.dart';

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

  Future<void> _createInitialSnapshot(int accountId, double amount) async {
    final fx = await _getOrCreateFxSnapshot(DateTime.now(), 7.25, 1.35);
    final sessionId = await _db.into(_db.updateSessions).insert(
          UpdateSessionsCompanion.insert(
            fxSnapshotId: fx.id,
            note: const Value('初始余额'),
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

  Future<FxSnapshot> _getOrCreateFxSnapshot(
    DateTime recordedAt,
    double usdToCny,
    double usdToSgd,
  ) async {
    final existing = await (_db.select(_db.fxSnapshots)
          ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)])
          ..limit(1))
        .getSingleOrNull();
    if (existing != null) return existing;

    final fxId = await _db.into(_db.fxSnapshots).insert(
          FxSnapshotsCompanion.insert(recordedAt: Value(recordedAt)),
        );
    await _db.batch((batch) {
      batch.insertAll(_db.fxRates, [
        FxRatesCompanion.insert(
          fxSnapshotId: fxId,
          fromCurrency: Currency.usd.name,
          toCurrency: Currency.cny.name,
          rate: usdToCny,
        ),
        FxRatesCompanion.insert(
          fxSnapshotId: fxId,
          fromCurrency: Currency.usd.name,
          toCurrency: Currency.sgd.name,
          rate: usdToSgd,
        ),
      ]);
    });
    return (await (_db.select(_db.fxSnapshots)
          ..where((t) => t.id.equals(fxId)))
        .getSingle());
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

  Future<BalanceSnapshot?> latestSnapshot(int accountId) {
    return (_db.select(_db.balanceSnapshots)
          ..where((t) => t.accountId.equals(accountId))
          ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Stream<List<BalanceSnapshot>> watchSnapshots(int accountId) {
    return (_db.select(_db.balanceSnapshots)
          ..where((t) => t.accountId.equals(accountId))
          ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)]))
        .watch();
  }
}

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
      return CurrencyConverter.fromUsdRates(usdToCny: 7.25, usdToSgd: 1.35);
    }
    return converterForSnapshot(snapshot.id);
  }
}

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

  Future<Map<int, BalanceSnapshot>> latestSnapshotsBeforeSession(
    UpdateSession session,
  ) async {
    final accounts = await _db.select(_db.accounts).get();
    final result = <int, BalanceSnapshot>{};
    for (final account in accounts) {
      final snap = await (_db.select(_db.balanceSnapshots)
            ..where((t) =>
                t.accountId.equals(account.id) &
                t.recordedAt.isSmallerThanValue(session.recordedAt))
            ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)])
            ..limit(1))
          .getSingleOrNull();
      if (snap != null) result[account.id] = snap;
    }
    return result;
  }

  Future<int> createSession({
    required double usdToCny,
    required double usdToSgd,
    required String sourceNote,
    required Map<int, double> accountAmounts,
    required Map<int, ({ChangeReason? reason, String? note})> changeMeta,
    required double thresholdPercent,
    required double thresholdAmount,
    required Currency displayCurrency,
    required CurrencyConverter previousFx,
  }) async {
    return _db.transaction(() async {
      final fxId = await _db.into(_db.fxSnapshots).insert(
            FxSnapshotsCompanion.insert(sourceNote: Value(sourceNote)),
          );
      await _db.batch((batch) {
        batch.insertAll(_db.fxRates, [
          FxRatesCompanion.insert(
            fxSnapshotId: fxId,
            fromCurrency: Currency.usd.name,
            toCurrency: Currency.cny.name,
            rate: usdToCny,
          ),
          FxRatesCompanion.insert(
            fxSnapshotId: fxId,
            fromCurrency: Currency.usd.name,
            toCurrency: Currency.sgd.name,
            rate: usdToSgd,
          ),
        ]);
      });

      final sessionId = await _db.into(_db.updateSessions).insert(
            UpdateSessionsCompanion.insert(fxSnapshotId: fxId),
          );

      final converter = CurrencyConverter.fromUsdRates(
        usdToCny: usdToCny,
        usdToSgd: usdToSgd,
      );

      for (final entry in accountAmounts.entries) {
        final account = await (_db.select(_db.accounts)
              ..where((t) => t.id.equals(entry.key)))
            .getSingle();
        final previous = await (_db.select(_db.balanceSnapshots)
              ..where((t) => t.accountId.equals(entry.key))
              ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)])
              ..limit(1))
            .getSingleOrNull();

        double? delta;
        double? deltaPercent;
        if (previous != null) {
          delta = entry.value - previous.amount;
          deltaPercent =
              previous.amount == 0 ? null : (delta / previous.amount) * 100;
        }

        final meta = changeMeta[entry.key];
        await _db.into(_db.balanceSnapshots).insert(
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

        if (previous != null && delta != null) {
          final convertedDelta = converter.convert(
            amount: delta.abs(),
            from: Currency.fromString(account.currency),
            to: displayCurrency,
          );
          final isLarge = (deltaPercent != null &&
                  deltaPercent.abs() >= thresholdPercent) ||
              convertedDelta >= thresholdAmount;
          // meta should already be filled by UI when large
          if (isLarge && meta?.reason == null) {
            // default to other if UI missed it
          }
        }
      }

      return sessionId;
    });
  }

  Future<List<AccountBalance>> balancesForSession(int sessionId) async {
    final snapshots = await snapshotsForSession(sessionId);
    final accounts = await _db.select(_db.accounts).get();
    final accountMap = {for (final a in accounts) a.id: a};
    return snapshots.map((s) {
      final account = accountMap[s.accountId]!;
      return AccountBalance(
        accountId: s.accountId,
        category: AccountCategory.fromString(account.category),
        currency: Currency.fromString(account.currency),
        amount: s.amount,
      );
    }).toList();
  }

  Future<List<({UpdateSession session, double netWorth})>> familyTrend({
    required Currency displayCurrency,
    DateTime? since,
  }) async {
    var sessions = await (_db.select(_db.updateSessions)
          ..orderBy([(t) => OrderingTerm.asc(t.recordedAt)]))
        .get();
    if (since != null) {
      sessions = sessions.where((s) => s.recordedAt.isAfter(since)).toList();
    }

    final fxRepo = FxRepository(_db);
    final result = <({UpdateSession session, double netWorth})>[];
    for (final session in sessions) {
      final balances = await balancesForSession(session.id);
      final converter = await fxRepo.converterForSnapshot(session.fxSnapshotId);
      final netWorth = NetWorthCalculator.familyNetWorth(
        balances: balances,
        converter: converter,
        displayCurrency: displayCurrency,
      );
      result.add((session: session, netWorth: netWorth));
    }
    return result;
  }
}

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
  }) {
    return (_db.update(_db.appSettings)..where((t) => t.id.equals(1))).write(
      AppSettingsCompanion(
        s3Endpoint: Value(endpoint),
        s3Bucket: Value(bucket),
        s3AccessKey: Value(accessKey),
      ),
    );
  }
}

class BackupRepository {
  BackupRepository();

  Future<void> exportToS3(S3Config config) {
    throw UnimplementedError('S3 backup coming soon');
  }

  Future<void> importFromS3(S3Config config) {
    throw UnimplementedError('S3 backup coming soon');
  }
}

class S3Config {
  S3Config({
    required this.endpoint,
    required this.bucket,
    required this.accessKey,
    required this.secretKey,
  });

  final String endpoint;
  final String bucket;
  final String accessKey;
  final String secretKey;
}
