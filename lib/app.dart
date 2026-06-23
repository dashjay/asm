import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/notifications/notification_scheduler.dart';
import 'core/providers/providers.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'domain/models/app_language.dart';
import 'features/security/app_lock_gate.dart';
import 'l10n/app_localizations.dart';

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
    final scheduler = NotificationScheduler(
      ref.read(accountRepositoryProvider),
      ref.read(settingsRepositoryProvider),
    );
    await scheduler.rescheduleAll();
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final language = settingsAsync.maybeWhen(
      data: (s) => AppLanguage.fromCode(s.localeLanguageCode),
      orElse: () => AppLanguage.fallback,
    );

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: AppTheme.light(),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      locale: Locale(language.code),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) => AppLockGate(child: child ?? const SizedBox()),
    );
  }
}
