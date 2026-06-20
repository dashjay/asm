import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/providers.dart';
import '../../core/utils/formatters.dart';
import '../../domain/forecast/linear_forecast.dart';
import '../../domain/models/enums.dart';

class FamilyTrendChart extends ConsumerStatefulWidget {
  const FamilyTrendChart({
    super.key,
    required this.displayCurrency,
    this.range = ChartRange.all,
    this.showForecast = false,
    this.compact = false,
  });

  final Currency displayCurrency;
  final ChartRange range;
  final bool showForecast;
  final bool compact;

  @override
  ConsumerState<FamilyTrendChart> createState() => _FamilyTrendChartState();
}

class _FamilyTrendChartState extends ConsumerState<FamilyTrendChart> {
  ChartRange _range = ChartRange.all;

  @override
  void initState() {
    super.initState();
    _range = widget.range;
  }

  @override
  Widget build(BuildContext context) {
    final trendAsync = ref.watch(familyTrendProvider(_range));

    return trendAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      data: (points) {
        if (points.isEmpty) {
          return const Center(child: Text('暂无数据，请先更新余额'));
        }

        final spots = points
            .asMap()
            .entries
            .map((e) => FlSpot(e.key.toDouble(), e.value.netWorth))
            .toList();

        LinearForecastResult? forecast;
        if (widget.showForecast && points.length >= 3) {
          forecast = LinearForecast.compute(
            history: points
                .map((p) => (date: p.session.recordedAt, value: p.netWorth))
                .toList(),
            forwardDays: const [30, 90],
          );
        }

        final forecastSpots = <FlSpot>[];
        if (forecast != null && forecast.projections.isNotEmpty) {
          final lastX = spots.last.x;
          for (var i = 0; i < forecast.projections.length; i++) {
            forecastSpots.add(FlSpot(lastX + i + 1, forecast.projections[i].value));
          }
        }

        final allY = [
          ...spots.map((s) => s.y),
          ...forecastSpots.map((s) => s.y),
        ];
        final minY = allY.reduce((a, b) => a < b ? a : b);
        final maxY = allY.reduce((a, b) => a > b ? a : b);
        final padding = (maxY - minY) * 0.1 + 1;

        return Column(
          children: [
            if (!widget.compact)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SegmentedButton<ChartRange>(
                  segments: ChartRange.values
                      .map((r) => ButtonSegment(value: r, label: Text(r.label)))
                      .toList(),
                  selected: {_range},
                  onSelectionChanged: (set) => setState(() => _range = set.first),
                ),
              ),
            Expanded(
              child: LineChart(
                LineChartData(
                  minY: minY - padding,
                  maxY: maxY + padding,
                  gridData: const FlGridData(show: true, drawVerticalLine: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: !widget.compact,
                        reservedSize: 56,
                        getTitlesWidget: (value, meta) => Text(
                          formatMoney(value, widget.displayCurrency),
                          style: const TextStyle(fontSize: 10),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: !widget.compact,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= points.length) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              formatDate(points[index].session.recordedAt),
                              style: const TextStyle(fontSize: 10),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 3,
                      dotData: const FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.15),
                      ),
                    ),
                    if (forecastSpots.isNotEmpty)
                      LineChartBarData(
                        spots: [spots.last, ...forecastSpots],
                        isCurved: false,
                        color: Theme.of(context).colorScheme.outline,
                        barWidth: 2,
                        dashArray: [6, 4],
                        dotData: const FlDotData(show: false),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
