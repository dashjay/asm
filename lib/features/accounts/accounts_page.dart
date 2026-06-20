import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/db/app_database.dart';
import '../../core/providers/providers.dart';
import '../../core/utils/formatters.dart';
import '../../domain/currency/currency_converter.dart';
import '../../domain/models/enums.dart';

class AccountsPage extends ConsumerWidget {
  const AccountsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsProvider);
    final membersAsync = ref.watch(membersProvider);
    final converterAsync = ref.watch(latestConverterProvider);
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('账户'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/accounts/new'),
          ),
        ],
      ),
      body: accountsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (accounts) {
          if (accounts.isEmpty) {
            return const Center(child: Text('暂无账户，点击 + 添加'));
          }

          return membersAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('$e')),
            data: (members) {
              final memberMap = {for (final m in members) m.id: m};
              final grouped = <int, List<Account>>{};
              for (final account in accounts) {
                grouped.putIfAbsent(account.memberId, () => []).add(account);
              }

              return converterAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('$e')),
                data: (converter) {
                  final display = settingsAsync.hasValue
                      ? Currency.fromString(settingsAsync.value!.displayCurrency)
                      : Currency.cny;

                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      for (final entry in grouped.entries) ...[
                        Text(
                          memberMap[entry.key]?.name ?? '未知成员',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        ...entry.value.map((account) => _AccountTile(
                              account: account,
                              converter: converter,
                              displayCurrency: display,
                              ref: ref,
                            )),
                        const SizedBox(height: 16),
                      ],
                      const SizedBox(height: 64),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _AccountTile extends ConsumerWidget {
  const _AccountTile({
    required this.account,
    required this.converter,
    required this.displayCurrency,
    required this.ref,
  });

  final Account account;
  final CurrencyConverter converter;
  final Currency displayCurrency;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(accountRepositoryProvider).latestSnapshot(account.id),
      builder: (context, snapshot) {
        final latest = snapshot.data;
        final currency = Currency.fromString(account.currency);
        final category = AccountCategory.fromString(account.category);
        final amount = latest?.amount ?? 0;
        final converted = converter.convert(
          amount: amount,
          from: currency,
          to: displayCurrency,
        );

        return Card(
          child: ListTile(
            title: Text(account.name),
            subtitle: Text('${category.label} · ${currency.code}'),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(formatMoney(amount, currency)),
                if (currency != displayCurrency)
                  Text(
                    '≈ ${formatMoney(converted, displayCurrency)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
            onTap: () => context.push('/accounts/${account.id}'),
          ),
        );
      },
    );
  }
}
