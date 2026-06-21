import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../app_constants.dart';
import '../providers/providers.dart';
import '../../data/repositories/repositories.dart';
import 'backup_io.dart' if (dart.library.js_interop) 'backup_stub.dart';

final secureStorageProvider = Provider((_) => const FlutterSecureStorage());

enum ImportDatabaseResult {
  cancelled,
  success,
}

class BackupService {
  BackupService(this._ref);

  final Ref _ref;

  Future<String> exportDatabase() async {
    if (kIsWeb) {
      throw UnsupportedError('web_export');
    }
    return exportDatabaseFile(_ref);
  }

  Future<ImportDatabaseResult> importDatabase() async {
    if (kIsWeb) {
      throw UnsupportedError('web_import');
    }
    return importDatabaseFile(_ref);
  }

  Future<void> saveS3Secret(String secret) async {
    await _ref.read(secureStorageProvider).write(key: 's3_secret', value: secret);
  }

  Future<String?> loadS3Secret() async {
    return _ref.read(secureStorageProvider).read(key: 's3_secret');
  }

  Future<void> exportToS3({
    required String endpoint,
    required String bucket,
    required String accessKey,
    required String secretKey,
    required String prefix,
  }) async {
    if (kIsWeb) {
      throw UnsupportedError('web_export');
    }

    if (endpoint.isEmpty ||
        bucket.isEmpty ||
        accessKey.isEmpty ||
        secretKey.isEmpty) {
      throw StateError('s3_config_incomplete');
    }

    final dir = await getApplicationDocumentsDirectory();
    final source = await prepareDatabaseForCopy(_ref, dir.path);
    final exportDir = await getTemporaryDirectory();
    final filename = backupFilename(DateTime.now());
    final dest = p.join(exportDir.path, filename);
    await copyDatabaseFile(source, dest);

    final config = S3Config(
      endpoint: endpoint,
      bucket: bucket,
      accessKey: accessKey,
      secretKey: secretKey,
      prefix: prefix,
    );
    final objectKey = buildObjectKey(prefix, filename);

    try {
      await _ref.read(backupRepositoryProvider).exportToS3(
            config: config,
            localFilePath: dest,
            objectKey: objectKey,
          );
    } finally {
      await deleteFileIfExists(dest);
    }
  }
}

/// Fixed-format backup filename, e.g. asm-20250621-143052.db
String backupFilename(DateTime time) {
  final stamp = DateFormat('yyyyMMdd-HHmmss').format(time);
  return 'asm-$stamp.db';
}

String buildObjectKey(String prefix, String filename) {
  final normalized = prefix.trim().replaceAll(RegExp(r'^/+|/+$'), '');
  return normalized.isEmpty ? filename : '$normalized/$filename';
}

final backupServiceProvider = Provider((ref) => BackupService(ref));

Future<String> prepareDatabaseForCopy(Ref ref, String documentsDir) async {
  final db = ref.read(databaseProvider);
  await db.customStatement('PRAGMA wal_checkpoint(FULL);');
  return openDatabaseFile(documentsDir);
}

Future<String> exportDatabaseFile(Ref ref) async {
  final dir = await getApplicationDocumentsDirectory();
  final source = await prepareDatabaseForCopy(ref, dir.path);
  final exportDir = await getTemporaryDirectory();
  final filename = backupFilename(DateTime.now());
  final dest = p.join(exportDir.path, filename);
  await copyDatabaseFile(source, dest);
  await Share.shareXFiles([XFile(dest)], text: kBackupShareText);
  return dest;
}

Future<ImportDatabaseResult> importDatabaseFile(Ref ref) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.any,
    withData: true,
  );
  if (result == null || result.files.isEmpty) {
    return ImportDatabaseResult.cancelled;
  }

  final picked = result.files.single;
  final tempDir = await getTemporaryDirectory();
  final sourcePath = await _resolvePickedBackupPath(picked, tempDir.path);
  final tempCopy = p.join(tempDir.path, 'asm_import_${DateTime.now().millisecondsSinceEpoch}.db');
  var copiedTemp = false;

  try {
    await copyDatabaseFile(sourcePath, tempCopy);
    copiedTemp = true;

    if (!await isValidSqliteBackupFile(tempCopy)) {
      throw StateError('invalid_backup_file');
    }

    final dir = await getApplicationDocumentsDirectory();
    final dest = p.join(dir.path, 'asm.db');
    final rollbackPath = '$dest.bak';

    final db = ref.read(databaseProvider);
    await db.customStatement('PRAGMA wal_checkpoint(FULL);');
    await db.close();

    if (await File(dest).exists()) {
      await copyDatabaseFile(dest, rollbackPath);
    }

    try {
      await replaceDatabaseFile(tempCopy, dest);
      if (!await isValidSqliteBackupFile(dest)) {
        throw StateError('invalid_backup_file');
      }
    } catch (e) {
      if (await File(rollbackPath).exists()) {
        await replaceDatabaseFile(rollbackPath, dest);
      }
      rethrow;
    } finally {
      await deleteFileIfExists(rollbackPath);
    }

    ref.invalidate(databaseProvider);
    return ImportDatabaseResult.success;
  } finally {
    if (copiedTemp) {
      await deleteFileIfExists(tempCopy);
    }
    if (sourcePath != picked.path) {
      await deleteFileIfExists(sourcePath);
    }
  }
}

Future<String> _resolvePickedBackupPath(PlatformFile file, String tempDir) async {
  final path = file.path;
  if (path != null && path.isNotEmpty) {
    final pickedFile = File(path);
    if (await pickedFile.exists() && await pickedFile.length() > 0) {
      return path;
    }
  }

  final bytes = file.bytes;
  if (bytes != null && bytes.isNotEmpty) {
    return writeBytesToTempFile(tempDir, file.name, bytes);
  }

  if (path != null && path.isNotEmpty) {
    final pickedFile = File(path);
    if (await pickedFile.exists()) {
      final fileBytes = await pickedFile.readAsBytes();
      if (fileBytes.isNotEmpty) {
        return writeBytesToTempFile(tempDir, file.name, fileBytes);
      }
    }
  }

  throw StateError('backup_file_unreadable');
}
