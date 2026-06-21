import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/providers.dart';
import '../../core/utils/formatters.dart';
import '../../domain/forecast/linear_forecast.dart';
import '../../domain/models/enums.dart';
import '../../l10n/app_localizations.dart';
import '../charts/family_trend_chart.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final summaryAsync = ref.watch(homeSummaryProvider);
    final display = ref.watch(displayCurrencyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.group_outlined),
            onPressed: () => context.push('/members'),
          ),
        ],
      ),
      body: summaryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.loadFailed('$e'))),
        data: (summary) {
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
                        title: Text(l10n.fxMayBeStale),
                        subtitle: Text(
                          l10n.fxLastRecordedDaysAgo(summary.daysSinceFxUpdate!),
                        ),
                        trailing: TextButton(
                          onPressed: () => context.push('/snapshot'),
                          child: Text(l10n.goUpdate),
                        ),
                      ),
                    ),
                  ),
                if (summary.forecast != null) ...[
                  const SizedBox(height: 12),
                  _ForecastCard(
                    forecast: summary.forecast!,
                    display: display,
                    locale: locale,
                  ),
                ],
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.familyTrend,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
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
                  Text(
                    l10n.accountsToUpdate,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ...summary.overdueAccounts.map(
                    (account) => Card(
                      child: ListTile(
                        title: Text(account.name),
                        subtitle: Text(
                          l10n.overdueDays(account.reminderIntervalDays),
                        ),
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
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final display = ref.watch(displayCurrencyProvider);
    final netWorth = summary.netWorthByCurrency[display] ?? 0;
    final changeFromPrevious = summary.changeFromPreviousByCurrency[display];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.familyNetWorth, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Text(
              formatMoney(netWorth, display, locale),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (changeFromPrevious != null) ...[
              const SizedBox(height: 4),
              Text(
                l10n.changeSinceLast(
                  formatSignedMoney(changeFromPrevious, display, locale),
                ),
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
                label: Text(l10n.daysSinceUpdate(summary.daysSinceUpdate!)),
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
                      '${c.code}: ${formatMoney(summary.netWorthByCurrency[c] ?? 0, c, locale)}',
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
  const _ForecastCard({
    required this.forecast,
    required this.display,
    required this.locale,
  });

  final LinearForecastResult forecast;
  final Currency display;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (forecast.projections.isEmpty) return const SizedBox.shrink();

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
            Text(
              l10n.trendForecast,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.forecastDescription(
                formatMoney(in90.value, display, locale),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.forecastDisclaimer,
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
