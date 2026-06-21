import 'package:asm/core/backup/backup_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('backupFilename', () {
    test('uses fixed timestamp format', () {
      final name = backupFilename(DateTime(2025, 6, 21, 14, 30, 52));
      expect(name, 'asm-20250621-143052.db');
    });
  });

  group('buildObjectKey', () {
    test('joins prefix and filename', () {
      expect(buildObjectKey('backups', 'asm-20250621-143052.db'),
          'backups/asm-20250621-143052.db');
    });

    test('omits empty prefix', () {
      expect(buildObjectKey('', 'asm-20250621-143052.db'),
          'asm-20250621-143052.db');
    });

    test('trims slashes from prefix', () {
      expect(buildObjectKey('/backups/', 'asm-20250621-143052.db'),
          'backups/asm-20250621-143052.db');
    });
  });
}
