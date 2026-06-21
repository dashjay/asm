import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/app_database.dart';
import '../../core/providers/providers.dart';
import '../../core/utils/formatters.dart';
import '../../domain/models/enums.dart';
import '../charts/line_chart_touch.dart';
import '../../l10n/app_localizations.dart';

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

          return FutureBuilder<List<({DateTime date, double cny, double sgd})>>(
            future: _loadRates(ref, snapshots.cast<FxSnapshot>()),
            builder: (context, rateSnap) {
              if (!rateSnap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final rates = rateSnap.data!;
              final cnySpots = rates
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value.cny))
                  .toList();
              final sgdSpots = rates
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value.sgd))
                  .toList();

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
                            lineBarsData: [
                              LineChartBarData(
                                spots: cnySpots,
                                color: Colors.red,
                                barWidth: 2,
                                dotData: const FlDotData(show: true),
                              ),
                              LineChartBarData(
                                spots: sgdSpots,
                                color: Colors.blue,
                                barWidth: 2,
                                dotData: const FlDotData(show: true),
                              ),
                            ],
                            titlesData: const FlTitlesData(show: false),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    children: [
                      _Legend(color: Colors.red, label: 'USD/CNY'),
                      SizedBox(width: 16),
                      _Legend(color: Colors.blue, label: 'USD/SGD'),
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
                        final cny = rows
                            .where((r) =>
                                r.fromCurrency == Currency.usd.name &&
                                r.toCurrency == Currency.cny.name)
                            .map((r) => r.rate)
                            .firstOrNull;
                        final sgd = rows
                            .where((r) =>
                                r.fromCurrency == Currency.usd.name &&
                                r.toCurrency == Currency.sgd.name)
                            .map((r) => r.rate)
                            .firstOrNull;
                        return Card(
                          child: ListTile(
                            title: Text(formatDateTime(snap.recordedAt, locale)),
                            subtitle: Text(
                              'USD/CNY: ${cny?.toStringAsFixed(4) ?? '-'} · '
                              'USD/SGD: ${sgd?.toStringAsFixed(4) ?? '-'}',
                            ),
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

  Future<List<({DateTime date, double cny, double sgd})>> _loadRates(
    WidgetRef ref,
    List<FxSnapshot> snapshots,
  ) async {
    final fxRepo = ref.read(fxRepositoryProvider);
    final result = <({DateTime date, double cny, double sgd})>[];
    for (final snap in snapshots.reversed) {
      final rates = await fxRepo.ratesForSnapshot(snap.id);
      final cny = rates
          .firstWhere(
            (r) =>
                r.fromCurrency == Currency.usd.name &&
                r.toCurrency == Currency.cny.name,
          )
          .rate;
      final sgd = rates
          .firstWhere(
            (r) =>
                r.fromCurrency == Currency.usd.name &&
                r.toCurrency == Currency.sgd.name,
          )
          .rate;
      result.add((date: snap.recordedAt, cny: cny, sgd: sgd));
    }
    return result;
  }
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
