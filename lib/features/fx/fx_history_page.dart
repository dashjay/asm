import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/app_database.dart';
import '../../core/providers/providers.dart';
import '../../core/utils/formatters.dart';
import '../../domain/models/enums.dart';
import '../charts/line_chart_touch.dart';
import '../../l10n/app_localizations.dart';

/// `USD -> X` rates recorded at one point in time, keyed by [Currency].
typedef _RatePoint = ({DateTime date, Map<Currency, double> usdRates});

/// Distinct line colors for the non-USD currencies, applied in enum order.
const List<Color> _seriesColors = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.teal,
  Colors.brown,
  Colors.pink,
  Colors.indigo,
];

List<Currency> get _trackedCurrencies =>
    Currency.values.where((c) => c != Currency.usd).toList();

Color _colorFor(int index) => _seriesColors[index % _seriesColors.length];

class FxHistoryPage extends ConsumerWidget {
  const FxHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final fxAsync = ref.watch(fxHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.fxHistory)),
      body: fxAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (snapshots) {
          if (snapshots.isEmpty) {
            return Center(child: Text(l10n.noFxRecords));
          }

          return FutureBuilder<List<_RatePoint>>(
            future: _loadRates(ref, snapshots.cast<FxSnapshot>()),
            builder: (context, rateSnap) {
              if (!rateSnap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final points = rateSnap.data!;
              final currencies = _trackedCurrencies;

              final lineBars = <LineChartBarData>[];
              for (var i = 0; i < currencies.length; i++) {
                final currency = currencies[i];
                final spots = points
                    .asMap()
                    .entries
                    .where((e) => e.value.usdRates.containsKey(currency))
                    .map((e) =>
                        FlSpot(e.key.toDouble(), e.value.usdRates[currency]!))
                    .toList();
                if (spots.isEmpty) continue;
                lineBars.add(
                  LineChartBarData(
                    spots: spots,
                    color: _colorFor(i),
                    barWidth: 2,
                    dotData: const FlDotData(show: true),
                  ),
                );
              }

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            lineTouchData: themedLineTouchData(
                              context,
                              formatValue: (y) => y.toStringAsFixed(4),
                              tooltipBarIndex: null,
                            ),
                            lineBarsData: lineBars,
                            titlesData: const FlTitlesData(show: false),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      for (var i = 0; i < currencies.length; i++)
                        _Legend(
                          color: _colorFor(i),
                          label: 'USD/${currencies[i].code}',
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...snapshots.map((snap) {
                    return FutureBuilder<List<FxRate>>(
                      future: ref
                          .read(fxRepositoryProvider)
                          .ratesForSnapshot(snap.id),
                      builder: (context, s) {
                        final rows = s.data ?? <FxRate>[];
                        final byCurrency = _usdRatesFromRows(rows);
                        final subtitle = _trackedCurrencies
                            .where(byCurrency.containsKey)
                            .map((c) =>
                                'USD/${c.code}: ${byCurrency[c]!.toStringAsFixed(4)}')
                            .join(' · ');
                        return Card(
                          child: ListTile(
                            title: Text(formatDateTime(snap.recordedAt, locale)),
                            subtitle: Text(subtitle),
                            trailing: snap.sourceNote.isNotEmpty
                                ? Text(snap.sourceNote,
                                    style:
                                        Theme.of(context).textTheme.bodySmall)
                                : null,
                          ),
                        );
                      },
                    );
                  }),
                  const SizedBox(height: 64),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Future<List<_RatePoint>> _loadRates(
    WidgetRef ref,
    List<FxSnapshot> snapshots,
  ) async {
    final fxRepo = ref.read(fxRepositoryProvider);
    final result = <_RatePoint>[];
    for (final snap in snapshots.reversed) {
      final rows = await fxRepo.ratesForSnapshot(snap.id);
      result.add((date: snap.recordedAt, usdRates: _usdRatesFromRows(rows)));
    }
    return result;
  }
}

/// Extracts the `USD -> X` rate per supported currency from stored rate rows.
Map<Currency, double> _usdRatesFromRows(List<FxRate> rows) {
  final result = <Currency, double>{};
  for (final row in rows) {
    if (row.fromCurrency != Currency.usd.name) continue;
    final target =
        Currency.values.where((c) => c.name == row.toCurrency).firstOrNull;
    if (target != null && target != Currency.usd) {
      result[target] = row.rate;
    }
  }
  return result;
}

class _Legend extends StatelessWidget {
  const _Legend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, color: color),
        const SizedBox(width: 4),
        Text(label),
      ],
    );
  }
}
