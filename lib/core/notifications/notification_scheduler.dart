import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../data/db/app_database.dart';
import '../../data/repositories/repositories.dart';
import '../../l10n/app_localizations.dart';

class NotificationScheduler {
  NotificationScheduler(this._accountRepo, this._settingsRepo);

  final AccountRepository _accountRepo;
  final SettingsRepository _settingsRepo;
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  bool _available = false;

  static const _channelId = 'account_reminders';

  Future<void> initialize() async {
    if (kIsWeb || _initialized) return;
    _initialized = true;

    try {
      tz.initializeTimeZones();

      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const ios = DarwinInitializationSettings();
      await _plugin.initialize(
        const InitializationSettings(android: android, iOS: ios),
      );

      if (defaultTargetPlatform == TargetPlatform.android) {
        final androidPlugin =
            _plugin.resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();
        await androidPlugin?.requestNotificationsPermission();
      }

      _available = true;
    } catch (e, st) {
      debugPrint('Notifications unavailable: $e\n$st');
      _available = false;
    }
  }

  Future<void> cancelForAccount(int accountId) async {
    if (kIsWeb || !_available) return;
    await initialize();
    await _plugin.cancel(accountId);
  }

  Future<void> rescheduleAll() async {
    if (kIsWeb) return;
    await initialize();
    if (!_available) return;
    await _plugin.cancelAll();

    final settings = await _settingsRepo.get();
    final l10n = lookupAppLocalizations(Locale(settings.localeLanguageCode));

    final accounts = await _accountRepo.watchActive().first;
    for (final account in accounts) {
      if (!account.reminderEnabled) continue;
      final latest = await _accountRepo.latestSnapshot(account.id);
      final base = latest?.recordedAt ?? account.createdAt;
      final due = base.add(Duration(days: account.reminderIntervalDays));
      final when = due.isBefore(DateTime.now())
          ? DateTime.now().add(const Duration(hours: 1))
          : due;
      await _schedule(account, when, l10n, latest);
    }
  }

  Future<void> _schedule(
    Account account,
    DateTime when,
    AppLocalizations l10n,
    BalanceSnapshot? latestSnapshot,
  ) async {
    // Reuse the snapshot already fetched by rescheduleAll instead of querying
    // the database again per account.
    final daysSince = latestSnapshot == null
        ? 999
        : DateTime.now().difference(latestSnapshot.recordedAt).inDays;
    await _plugin.zonedSchedule(
      account.id,
      l10n.notificationTitle,
      l10n.notificationBody(account.name, daysSince),
      tz.TZDateTime.from(when, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          l10n.notificationChannelName,
          channelDescription: l10n.notificationChannelDescription,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: '/accounts/${account.id}',
    );
  }
}
