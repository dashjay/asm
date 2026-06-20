import 'dart:io';

import 'package:path/path.dart' as p;

Future<String> openDatabaseFile(String dir) async {
  final source = File(p.join(dir, 'asm.db'));
  if (!await source.exists()) {
    throw StateError('数据库文件不存在');
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
