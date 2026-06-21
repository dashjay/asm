import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;

import '../../data/db/app_database.dart';
import '../../core/providers/providers.dart';
import '../../core/utils/formatters.dart';
import '../../domain/models/enums.dart';
import 'chart_axis.dart';
import 'line_chart_touch.dart';
import '../../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final snapshotsAsync =
        ref.watch(accountSnapshotsProvider(widget.accountId));

    return snapshotsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (snapshots) {
        if (snapshots.isEmpty) {
          return Center(child: Text(l10n.noSnapshots));
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
            final paddedMinY = minY - padding;
            final paddedMaxY = maxY + padding;
            final yInterval = niceInterval(paddedMinY, paddedMaxY);
            final xLabelIndices = visibleLabelIndices(reversed.length);
            final axisLabelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 10,
                );

            return Column(
              children: [
                SegmentedButton<Currency?>(
                  segments: [
                    ButtonSegment(value: null, label: Text(l10n.nativeCurrency)),
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
                      minX: 0,
                      maxX: math.max(spots.length - 1, 0).toDouble(),
                      minY: paddedMinY,
                      maxY: paddedMaxY,
                      gridData: const FlGridData(
                        show: true,
                        drawVerticalLine: false,
                      ),
                      lineTouchData: themedLineTouchData(
                        context,
                        formatValue: (y) =>
                            formatMoney(y, displayCurrency, locale),
                      ),
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
                            reservedSize: 28,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              final i = value.round();
                              if ((value - i).abs() > 0.01 ||
                                  i < 0 ||
                                  i >= reversed.length ||
                                  !xLabelIndices.contains(i)) {
                                return const SizedBox.shrink();
                              }
                              return SideTitleWidget(
                                meta: meta,
                                space: 4,
                                child: Text(
                                  formatShortDate(
                                    reversed[i].recordedAt,
                                    locale,
                                  ),
                                  style: axisLabelStyle,
                                  textAlign: TextAlign.center,
                                ),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 64,
                            minIncluded: false,
                            maxIncluded: false,
                            interval: yInterval,
                            getTitlesWidget: (value, meta) => SideTitleWidget(
                              meta: meta,
                              space: 4,
                              child: Text(
                                formatAxisMoney(
                                  value,
                                  displayCurrency,
                                  locale,
                                ),
                                style: axisLabelStyle,
                              ),
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

