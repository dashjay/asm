import 'package:asm/domain/backup/backup_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isSqliteDatabaseHeader', () {
    test('accepts a valid SQLite 3 header', () {
      final bytes = 'SQLite format 3\u0000'.codeUnits + List.filled(8, 0);
      expect(isSqliteDatabaseHeader(bytes), isTrue);
    });

    test('rejects empty or short input', () {
      expect(isSqliteDatabaseHeader([]), isFalse);
      expect(isSqliteDatabaseHeader([1, 2, 3]), isFalse);
    });

    test('rejects non-sqlite files', () {
      expect(isSqliteDatabaseHeader('not sqlite data'.codeUnits), isFalse);
    });
  });
}
