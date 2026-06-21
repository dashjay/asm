import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/providers.dart';
import '../../core/utils/formatters.dart';
import '../../domain/models/enums.dart';
import '../../l10n/app_localizations.dart';
import '../charts/account_trend_chart.dart';

class AccountDetailPage extends ConsumerWidget {
  const AccountDetailPage({super.key, required this.accountId});

  final int accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final accountAsync = ref.watch(accountProvider(accountId));

    return accountAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(body: Center(child: Text(l10n.loadFailed('$e')))),
      data: (account) {
        if (account == null) {
          return Scaffold(body: Center(child: Text(l10n.accountNotFound)));
        }

        final currency = Currency.fromString(account.currency);
        final snapshotsAsync = ref.watch(accountSnapshotsProvider(accountId));

        return Scaffold(
          appBar: AppBar(
            title: Text(account.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => context.push('/accounts/$accountId/edit'),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: AccountTrendChart(
                        accountId: accountId,
                        accountCurrency: currency,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: snapshotsAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('$e')),
                  data: (snapshots) => ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: snapshots.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final snap = snapshots[index];
                      return ListTile(
                        title: Text(formatMoney(snap.amount, currency, locale)),
                        subtitle: Text(formatDateTime(snap.recordedAt, locale)),
                        trailing: snap.deltaPercent != null
                            ? Text(formatPercent(snap.deltaPercent))
                            : null,
                        onTap: snap.changeReason != null
                            ? () {
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) => AlertDialog(
                                    title: Text(l10n.changeReason),
                                    content: Text(
                                      '${ChangeReason.fromString(snap.changeReason).label(l10n)}\n'
                                      '${snap.changeReasonText}',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(dialogContext),
                                        child: Text(l10n.close),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            : null,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
