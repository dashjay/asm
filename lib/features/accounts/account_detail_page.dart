import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/providers.dart';
import '../../core/utils/formatters.dart';
import '../../domain/models/enums.dart';
import '../charts/account_trend_chart.dart';

class AccountDetailPage extends ConsumerWidget {
  const AccountDetailPage({super.key, required this.accountId});

  final int accountId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountAsync = ref.watch(accountProvider(accountId));

    return accountAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(body: Center(child: Text('加载失败: $e'))),
      data: (account) {
        if (account == null) {
          return const Scaffold(body: Center(child: Text('账户不存在')));
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
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final snap = snapshots[index];
                      return ListTile(
                        title: Text(formatMoney(snap.amount, currency)),
                        subtitle: Text(formatDateTime(snap.recordedAt)),
                        trailing: snap.deltaPercent != null
                            ? Text(formatPercent(snap.deltaPercent))
                            : null,
                        onTap: snap.changeReason != null
                            ? () {
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) => AlertDialog(
                                    title: const Text('变动原因'),
                                    content: Text(
                                      '${ChangeReason.fromString(snap.changeReason).label}\n'
                                      '${snap.changeReasonText}',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(dialogContext),
                                        child: const Text('关闭'),
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
