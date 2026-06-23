import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:asm/data/db/app_database.dart';
import 'package:asm/data/repositories/repositories.dart';

void main() {
  late AppDatabase db;
  late SettingsRepository settingsRepo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    settingsRepo = SettingsRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('biometric lock defaults to off', () async {
    final settings = await settingsRepo.get();
    expect(settings.biometricLockEnabled, isFalse);
  });

  test('updateBiometricLock toggles the flag', () async {
    await settingsRepo.updateBiometricLock(true);
    expect((await settingsRepo.get()).biometricLockEnabled, isTrue);

    await settingsRepo.updateBiometricLock(false);
    expect((await settingsRepo.get()).biometricLockEnabled, isFalse);
  });
}
