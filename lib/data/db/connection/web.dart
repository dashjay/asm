import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

import '../app_database.dart';

AppDatabase constructDatabase() {
  return AppDatabase(_openConnection());
}

QueryExecutor _openConnection() {
  return DatabaseConnection.delayed(
    Future(() async {
      final result = await WasmDatabase.open(
        databaseName: 'asm',
        sqlite3Uri: Uri.parse('sqlite3.wasm'),
        driftWorkerUri: Uri.parse('drift_worker.js'),
      );
      return result.resolvedExecutor;
    }),
  );
}
