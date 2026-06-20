import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/notifications/notification_scheduler.dart';
import 'core/providers/providers.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class AsmApp extends ConsumerStatefulWidget {
  const AsmApp({super.key});

  @override
  ConsumerState<AsmApp> createState() => _AsmAppState();
}

class _AsmAppState extends ConsumerState<AsmApp> {
  late final GoRouter _router = createRouter();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    final db = ref.read(databaseProvider);
    await db.seedIfEmpty();
    final scheduler = NotificationScheduler(ref.read(accountRepositoryProvider));
    await scheduler.rescheduleAll();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: '家庭资产',
      theme: AppTheme.light(),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
