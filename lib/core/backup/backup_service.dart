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

class BackupService {
  BackupService(this._ref);

  final Ref _ref;

  Future<String> exportDatabase() async {
    if (kIsWeb) {
      throw UnsupportedError('web_export');
    }
    return exportDatabaseFile();
  }

  Future<void> importDatabase() async {
    if (kIsWeb) {
      throw UnsupportedError('web_import');
    }
    await importDatabaseFile(_ref);
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
    final source = await openDatabaseFile(dir.path);
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

Future<String> exportDatabaseFile() async {
  final dir = await getApplicationDocumentsDirectory();
  final source = await openDatabaseFile(dir.path);
  final exportDir = await getTemporaryDirectory();
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final dest = p.join(exportDir.path, 'asm_backup_$timestamp.db');
  await copyDatabaseFile(source, dest);
  await Share.shareXFiles([XFile(dest)], text: kBackupShareText);
  return dest;
}

Future<void> importDatabaseFile(Ref ref) async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['db'],
  );
  if (result == null || result.files.single.path == null) return;

  final pickedPath = result.files.single.path!;
  final dir = await getApplicationDocumentsDirectory();
  final dest = p.join(dir.path, 'asm.db');

  await ref.read(databaseProvider).close();
  await replaceDatabaseFile(pickedPath, dest);
  ref.invalidate(databaseProvider);
}
