import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../data/db/app_database.dart';
import '../../data/repositories/repositories.dart';

class NotificationScheduler {
  NotificationScheduler(this._accountRepo);

  final AccountRepository _accountRepo;
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const _channelId = 'account_reminders';
  static const _channelName = '账户更新提醒';

  Future<void> initialize() async {
    if (kIsWeb || _initialized) return;
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

    _initialized = true;
  }

  Future<void> rescheduleAll() async {
    if (kIsWeb) return;
    await initialize();
    await _plugin.cancelAll();

    final accounts = await _accountRepo.watchActive().first;
    for (final account in accounts) {
      if (!account.reminderEnabled) continue;
      final latest = await _accountRepo.latestSnapshot(account.id);
      final base = latest?.recordedAt ?? account.createdAt;
      final due = base.add(Duration(days: account.reminderIntervalDays));
      if (due.isBefore(DateTime.now())) {
        await _schedule(account, DateTime.now().add(const Duration(hours: 1)));
      } else {
        await _schedule(account, due);
      }
    }
  }

  Future<void> _schedule(Account account, DateTime when) async {
    final daysSince = await _daysSinceUpdate(account.id);
    await _plugin.zonedSchedule(
      account.id,
      '账户更新提醒',
      '该更新【${account.name}】余额了（上次更新 $daysSince 天前）',
      tz.TZDateTime.from(when, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: '周期提醒更新账户余额',
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: '/accounts/${account.id}',
    );
  }

  Future<int> _daysSinceUpdate(int accountId) async {
    final latest = await _accountRepo.latestSnapshot(accountId);
    if (latest == null) return 999;
    return DateTime.now().difference(latest.recordedAt).inDays;
  }
}
