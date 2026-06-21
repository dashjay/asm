import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/providers.dart';
import '../../core/utils/formatters.dart';
import 'chart_axis.dart';
import 'line_chart_touch.dart';
import '../../domain/forecast/linear_forecast.dart';
import '../../domain/models/enums.dart';
import '../../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final trendAsync = ref.watch(familyTrendProvider(_range));

    return trendAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
      skipLoadingOnReload: true,
      data: (points) {
        if (points.isEmpty) {
          return Center(child: Text(l10n.noDataUpdateFirst));
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
        final paddedMinY = minY - padding;
        final paddedMaxY = maxY + padding;
        final yInterval = niceInterval(paddedMinY, paddedMaxY);

        // X is the point index; keep the data line at one dot per record and
        // only subsample the axis labels so they never overlap.
        final labelIndices = visibleLabelIndices(points.length);
        final maxX = forecastSpots.isNotEmpty
            ? forecastSpots.last.x
            : (points.length - 1).toDouble();
        final spanDays = points.last.session.recordedAt
            .difference(points.first.session.recordedAt)
            .inDays;
        final useMonthYear = spanDays > 62;
        final axisLabelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 10,
            );

        return Column(
          children: [
            if (!widget.compact)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SegmentedButton<ChartRange>(
                  segments: ChartRange.values
                      .map((r) => ButtonSegment(
                            value: r,
                            label: Text(r.label(l10n)),
                          ))
                      .toList(),
                  selected: {_range},
                  onSelectionChanged: (set) => setState(() => _range = set.first),
                ),
              ),
            Expanded(
              child: LineChart(
                LineChartData(
                  minX: 0,
                  maxX: maxX,
                  minY: paddedMinY,
                  maxY: paddedMaxY,
                  lineTouchData: themedLineTouchData(
                    context,
                    formatValue: (y) =>
                        formatMoney(y, widget.displayCurrency, locale),
                    tooltipBarIndex: 0,
                  ),
                  gridData: const FlGridData(show: true, drawVerticalLine: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: !widget.compact,
                        reservedSize: 48,
                        minIncluded: false,
                        maxIncluded: false,
                        interval: yInterval,
                        getTitlesWidget: (value, meta) => SideTitleWidget(
                          meta: meta,
                          space: 4,
                          child: Text(
                            formatAxisMoney(value, widget.displayCurrency, locale),
                            style: axisLabelStyle,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: !widget.compact,
                        reservedSize: 28,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final i = value.round();
                          if ((value - i).abs() > 0.01 ||
                              i < 0 ||
                              i >= points.length ||
                              !labelIndices.contains(i)) {
                            return const SizedBox.shrink();
                          }
                          final date = points[i].session.recordedAt;
                          return SideTitleWidget(
                            meta: meta,
                            space: 4,
                            child: Text(
                              useMonthYear
                                  ? formatMonthYear(date, locale)
                                  : formatShortDate(date, locale),
                              style: axisLabelStyle,
                              textAlign: TextAlign.center,
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
