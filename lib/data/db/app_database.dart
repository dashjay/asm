import 'package:drift/drift.dart';

import '../../domain/currency/fx_defaults.dart';
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
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await into(appSettings).insert(
            AppSettingsCompanion.insert(),
            mode: InsertMode.insertOrIgnore,
          );
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(
              appSettings,
              appSettings.localeLanguageCode,
            );
          }
          if (from < 3) {
            await m.addColumn(
              appSettings,
              appSettings.s3Prefix,
            );
          }
          if (from < 4) {
            await m.addColumn(
              appSettings,
              appSettings.biometricLockEnabled,
            );
          }
        },
      );

  /// Streams change events for every table that feeds a net-worth computation.
  /// Reactive providers listen to this to recompute dashboards/charts on write.
  Stream<Set<TableUpdate>> dashboardChanges() {
    return tableUpdates(
      TableUpdateQuery.onAllTables([
        updateSessions,
        balanceSnapshots,
        accounts,
        fxSnapshots,
        fxRates,
      ]),
    );
  }

  /// Inserts an FX snapshot plus its USD->CNY and USD->SGD rate rows.
  ///
  /// Shared by the repositories so the snapshot shape is defined in exactly one place.
  Future<int> insertFxSnapshot({
    double? usdToCny,
    double? usdToSgd,
    DateTime? recordedAt,
    String? sourceNote,
  }) async {
    final fxId = await into(fxSnapshots).insert(
      FxSnapshotsCompanion.insert(
        recordedAt:
            recordedAt != null ? Value(recordedAt) : const Value.absent(),
        sourceNote:
            sourceNote != null ? Value(sourceNote) : const Value.absent(),
      ),
    );
    await batch((batch) {
      batch.insertAll(fxRates, [
        FxRatesCompanion.insert(
          fxSnapshotId: fxId,
          fromCurrency: Currency.usd.name,
          toCurrency: Currency.cny.name,
          rate: usdToCny ?? kDefaultUsdToCny,
        ),
        FxRatesCompanion.insert(
          fxSnapshotId: fxId,
          fromCurrency: Currency.usd.name,
          toCurrency: Currency.sgd.name,
          rate: usdToSgd ?? kDefaultUsdToSgd,
        ),
      ]);
    });
    return fxId;
  }
}
