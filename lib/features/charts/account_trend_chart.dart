import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/app_database.dart';
import '../../core/providers/providers.dart';
import '../../core/utils/formatters.dart';
import '../../domain/models/enums.dart';

class AccountTrendChart extends ConsumerStatefulWidget {
  const AccountTrendChart({
    super.key,
    required this.accountId,
    required this.accountCurrency,
    this.convertTo,
  });

  final int accountId;
  final Currency accountCurrency;
  final Currency? convertTo;

  @override
  ConsumerState<AccountTrendChart> createState() => _AccountTrendChartState();
}

class _AccountTrendChartState extends ConsumerState<AccountTrendChart> {
  Currency? _convertTo;
  List<BalanceSnapshot>? _cachedSnapshots;
  Currency? _cachedDisplayCurrency;
  Future<List<double>>? _amountsFuture;

  @override
  void initState() {
    super.initState();
    _convertTo = widget.convertTo;
  }

  @override
  Widget build(BuildContext context) {
    final snapshotsAsync =
        ref.watch(accountSnapshotsProvider(widget.accountId));

    return snapshotsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (snapshots) {
        if (snapshots.isEmpty) {
          return const Center(child: Text('暂无快照'));
        }

        final displayCurrency = _convertTo ?? widget.accountCurrency;
        final reversed = snapshots.reversed.toList();

        if (_cachedSnapshots != snapshots ||
            _cachedDisplayCurrency != displayCurrency) {
          _cachedSnapshots = snapshots;
          _cachedDisplayCurrency = displayCurrency;
          _amountsFuture = _convertAmounts(reversed, displayCurrency);
        }

        return FutureBuilder<List<double>>(
          future: _amountsFuture,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('${snapshot.error}'));
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final values = snapshot.data!;
            final spots = values
                .asMap()
                .entries
                .map((e) => FlSpot(e.key.toDouble(), e.value))
                .toList();

            final minY = values.reduce((a, b) => a < b ? a : b);
            final maxY = values.reduce((a, b) => a > b ? a : b);
            final padding = (maxY - minY) * 0.1 + 1;

            return Column(
              children: [
                SegmentedButton<Currency?>(
                  segments: [
                    const ButtonSegment(value: null, label: Text('原币')),
                    ...Currency.values.map(
                      (c) => ButtonSegment(value: c, label: Text(c.code)),
                    ),
                  ],
                  selected: {_convertTo},
                  onSelectionChanged: (set) =>
                      setState(() => _convertTo = set.first),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      minY: minY - padding,
                      maxY: maxY + padding,
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: Theme.of(context).colorScheme.secondary,
                          barWidth: 3,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, bar, index) {
                              final snap = reversed[index];
                              final isLarge = snap.deltaPercent != null &&
                                  snap.deltaPercent!.abs() >= 10;
                              return FlDotCirclePainter(
                                radius: isLarge ? 6 : 4,
                                color: isLarge
                                    ? Theme.of(context).colorScheme.error
                                    : Theme.of(context).colorScheme.secondary,
                              );
                            },
                          ),
                        ),
                      ],
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final i = value.toInt();
                              if (i < 0 || i >= reversed.length) {
                                return const SizedBox.shrink();
                              }
                              return Text(
                                formatDate(reversed[i].recordedAt),
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 48,
                            getTitlesWidget: (value, meta) => Text(
                              formatMoney(value, displayCurrency),
                              style: const TextStyle(fontSize: 10),
                            ),
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<List<double>> _convertAmounts(
    List<BalanceSnapshot> snapshots,
    Currency target,
  ) async {
    if (target == widget.accountCurrency) {
      return snapshots.map((s) => s.amount).toList();
    }

    final fxRepo = ref.read(fxRepositoryProvider);
    final db = ref.read(databaseProvider);
    final result = <double>[];

    for (final snap in snapshots) {
      final session = await (db.select(db.updateSessions)
            ..where((t) => t.id.equals(snap.updateSessionId)))
          .getSingle();
      final converter = await fxRepo.converterForSnapshot(session.fxSnapshotId);
      result.add(
        converter.convert(
          amount: snap.amount,
          from: widget.accountCurrency,
          to: target,
        ),
      );
    }
    return result;
  }
}
