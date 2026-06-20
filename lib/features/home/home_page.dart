import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/providers.dart';
import '../../core/utils/formatters.dart';
import '../../domain/models/enums.dart';
import '../charts/family_trend_chart.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(homeSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('家庭资产'),
        actions: [
          IconButton(
            icon: const Icon(Icons.group_outlined),
            onPressed: () => context.push('/members'),
          ),
        ],
      ),
      body: summaryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败: $e')),
        data: (summary) {
          final display = summary.displayCurrency;

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(homeSummaryProvider);
              await ref.read(homeSummaryProvider.future);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _NetWorthCard(
                  summary: summary,
                  onCurrencyChanged: (currency) async {
                    await ref
                        .read(settingsRepositoryProvider)
                        .updateDisplayCurrency(currency);
                  },
                ),
                if (summary.daysSinceFxUpdate != null &&
                    summary.daysSinceFxUpdate! > 7)
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Card(
                      color: Theme.of(context).colorScheme.errorContainer,
                      child: ListTile(
                        leading: const Icon(Icons.warning_amber),
                        title: const Text('汇率可能已过期'),
                        subtitle: Text('上次录入 ${summary.daysSinceFxUpdate} 天前，建议更新'),
                        trailing: TextButton(
                          onPressed: () => context.push('/snapshot'),
                          child: const Text('去更新'),
                        ),
                      ),
                    ),
                  ),
                if (summary.forecast != null) ...[
                  const SizedBox(height: 12),
                  _ForecastCard(summary: summary, display: display),
                ],
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('家庭走势', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 180,
                          child: FamilyTrendChart(
                            displayCurrency: display,
                            showForecast: true,
                            compact: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (summary.overdueAccounts.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text('待更新账户', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ...summary.overdueAccounts.map(
                    (account) => Card(
                      child: ListTile(
                        title: Text(account.name),
                        subtitle: Text('已超过 ${account.reminderIntervalDays} 天周期'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push('/snapshot'),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NetWorthCard extends ConsumerWidget {
  const _NetWorthCard({
    required this.summary,
    required this.onCurrencyChanged,
  });

  final HomeSummary summary;
  final ValueChanged<Currency> onCurrencyChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final display = ref.watch(settingsProvider).when(
          data: (settings) => Currency.fromString(settings.displayCurrency),
          loading: () => summary.displayCurrency,
          error: (_, __) => summary.displayCurrency,
        );
    final netWorth = summary.netWorthByCurrency[display] ?? 0;
    final changeFromPrevious = summary.changeFromPreviousByCurrency[display];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('家庭净值', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Text(
              formatMoney(netWorth, display),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (changeFromPrevious != null) ...[
              const SizedBox(height: 4),
              Text(
                '较上次 ${formatSignedMoney(changeFromPrevious, display)}',
                style: TextStyle(
                  color: changeFromPrevious >= 0
                      ? Colors.green.shade700
                      : Colors.red.shade700,
                ),
              ),
            ],
            if (summary.daysSinceUpdate != null) ...[
              const SizedBox(height: 8),
              Chip(
                label: Text('距上次更新 ${summary.daysSinceUpdate} 天'),
                visualDensity: VisualDensity.compact,
              ),
            ],
            const SizedBox(height: 16),
            SegmentedButton<Currency>(
              segments: Currency.values
                  .map((c) => ButtonSegment(value: c, label: Text(c.code)))
                  .toList(),
              selected: {display},
              onSelectionChanged: (set) => onCurrencyChanged(set.first),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: Currency.values
                  .where((c) => c != display)
                  .map(
                    (c) => Text(
                      '${c.code}: ${formatMoney(summary.netWorthByCurrency[c] ?? 0, c)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ForecastCard extends StatelessWidget {
  const _ForecastCard({required this.summary, required this.display});

  final HomeSummary summary;
  final Currency display;

  @override
  Widget build(BuildContext context) {
    final forecast = summary.forecast!;
    final in90 = forecast.projections.lastWhere(
      (p) => p.date.difference(DateTime.now()).inDays >= 80,
      orElse: () => forecast.projections.last,
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('趋势预测', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              '按近 ${forecast.projections.isNotEmpty ? '6' : '0'} 个月趋势，'
              '预计约 3 个月后家庭净值约 ${formatMoney(in90.value, display)}',
            ),
            const SizedBox(height: 4),
            Text(
              '仅供参考，不构成投资建议',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
