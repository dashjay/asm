import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/accounts/account_detail_page.dart';
import '../../features/accounts/account_form_page.dart';
import '../../features/accounts/accounts_page.dart';
import '../../features/charts/charts_page.dart';
import '../../features/fx/fx_history_page.dart';
import '../../features/home/home_page.dart';
import '../../features/members/members_page.dart';
import '../../features/settings/settings_page.dart';
import '../../features/snapshot/snapshot_wizard_page.dart';
import 'shell_page.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter() {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) => ShellPage(child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomePage()),
          ),
          GoRoute(
            path: '/accounts',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AccountsPage()),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => AccountDetailPage(
                  accountId: int.parse(state.pathParameters['id']!),
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/charts',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ChartsPage()),
          ),
          GoRoute(
            path: '/fx',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: FxHistoryPage()),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SettingsPage()),
          ),
        ],
      ),
      GoRoute(
        path: '/snapshot',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const SnapshotWizardPage(),
      ),
      GoRoute(
        path: '/members',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const MembersPage(),
      ),
      GoRoute(
        path: '/accounts/new',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const AccountFormPage(),
      ),
      GoRoute(
        path: '/accounts/:id/edit',
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => AccountFormPage(
          accountId: int.parse(state.pathParameters['id']!),
        ),
      ),
    ],
  );
}
