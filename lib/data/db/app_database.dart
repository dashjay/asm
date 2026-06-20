import 'package:drift/drift.dart';

import '../../domain/models/enums.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  FamilyMembers,
  Accounts,
  FxSnapshots,
  FxRates,
  UpdateSessions,
  BalanceSnapshots,
  AppSettings,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await into(appSettings).insert(
            AppSettingsCompanion.insert(),
            mode: InsertMode.insertOrIgnore,
          );
        },
      );

  Future<void> seedIfEmpty() async {
    final memberCount = await familyMembers.count().getSingle();
    if (memberCount > 0) return;

    final memberId = await into(familyMembers).insert(
      FamilyMembersCompanion.insert(name: '家庭', avatarColor: const Value(0xFF6750A4)),
    );

    final cnyAccount = await into(accounts).insert(
      AccountsCompanion.insert(
        memberId: memberId,
        name: '招商银行活期',
        category: AccountCategory.current.name,
        currency: Currency.cny.name,
      ),
    );
    final usdAccount = await into(accounts).insert(
      AccountsCompanion.insert(
        memberId: memberId,
        name: '美股账户',
        category: AccountCategory.investment.name,
        currency: Currency.usd.name,
      ),
    );
    final sgdAccount = await into(accounts).insert(
      AccountsCompanion.insert(
        memberId: memberId,
        name: 'DBS 储蓄',
        category: AccountCategory.current.name,
        currency: Currency.sgd.name,
      ),
    );

    await _seedSession(
      recordedAt: DateTime(2026, 1, 1),
      usdToCny: 7.20,
      usdToSgd: 1.34,
      balances: {
        cnyAccount: 500000,
        usdAccount: 50000,
        sgdAccount: 80000,
      },
    );
    await _seedSession(
      recordedAt: DateTime(2026, 6, 1),
      usdToCny: 7.25,
      usdToSgd: 1.35,
      balances: {
        cnyAccount: 520000,
        usdAccount: 55000,
        sgdAccount: 85000,
      },
    );
  }

  Future<void> _seedSession({
    required DateTime recordedAt,
    required double usdToCny,
    required double usdToSgd,
    required Map<int, double> balances,
  }) async {
    final fxId = await into(fxSnapshots).insert(
      FxSnapshotsCompanion.insert(
        recordedAt: Value(recordedAt),
        sourceNote: const Value('示例数据'),
      ),
    );
    await batch((batch) {
      batch.insertAll(fxRates, [
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

    final sessionId = await into(updateSessions).insert(
      UpdateSessionsCompanion.insert(
        recordedAt: Value(recordedAt),
        fxSnapshotId: fxId,
      ),
    );

    for (final entry in balances.entries) {
      final previous = await (select(balanceSnapshots)
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

      await into(balanceSnapshots).insert(
        BalanceSnapshotsCompanion.insert(
          accountId: entry.key,
          updateSessionId: sessionId,
          amount: entry.value,
          recordedAt: Value(recordedAt),
          deltaFromPrevious: Value(delta),
          deltaPercent: Value(deltaPercent),
        ),
      );
    }
  }
}
