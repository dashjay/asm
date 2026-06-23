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

  /// Inserts an FX snapshot plus one `USD -> X` rate row per supported currency.
  ///
  /// Shared by the repositories so the snapshot shape is defined in exactly one
  /// place. [usdRates] maps each non-USD [Currency] to its `USD -> X` rate; any
  /// supported currency omitted from the map falls back to [defaultUsdRate], so
  /// every snapshot always persists a complete set of rates.
  Future<int> insertFxSnapshot({
    Map<Currency, double>? usdRates,
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
        for (final currency in Currency.values)
          if (currency != Currency.usd)
            FxRatesCompanion.insert(
              fxSnapshotId: fxId,
              fromCurrency: Currency.usd.name,
              toCurrency: currency.name,
              rate: usdRates?[currency] ?? defaultUsdRate(currency),
            ),
      ]);
    });
    return fxId;
  }
}
