import 'dart:io';

import 'package:path/path.dart' as p;

import '../../domain/backup/backup_validation.dart';

Future<String> openDatabaseFile(String dir) async {
  final source = File(p.join(dir, 'asm.db'));
  if (!await source.exists()) {
    throw StateError('database_not_found');
  }
  return source.path;
}

Future<void> copyDatabaseFile(String source, String dest) async {
  await File(source).copy(dest);
}

Future<void> replaceDatabaseFile(String pickedPath, String dest) async {
  final destFile = File(dest);
  if (await destFile.exists()) {
    await destFile.delete();
  }
  await File(pickedPath).copy(dest);
}

Future<void> deleteFileIfExists(String path) async {
  final file = File(path);
  if (await file.exists()) {
    await file.delete();
  }
}

Future<bool> isValidSqliteBackupFile(String path) async {
  final file = File(path);
  if (!await file.exists()) return false;
  final bytes = await file.openRead(0, 16).fold<List<int>>(
        [],
        (previous, chunk) => [...previous, ...chunk],
      );
  return isSqliteDatabaseHeader(bytes);
}

Future<String> writeBytesToTempFile(String dir, String name, List<int> bytes) async {
  final safeName = name.isNotEmpty ? name : 'asm_backup.db';
  final path = p.join(dir, safeName);
  await File(path).writeAsBytes(bytes, flush: true);
  return path;
}
