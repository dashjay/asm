import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

LineTouchData themedLineTouchData(
  BuildContext context, {
  required String Function(double y) formatValue,
  int? tooltipBarIndex = 0,
}) {
  final colorScheme = Theme.of(context).colorScheme;

  return LineTouchData(
    touchTooltipData: LineTouchTooltipData(
      tooltipRoundedRadius: 8,
      tooltipBorder: BorderSide(color: colorScheme.outlineVariant),
      getTooltipColor: (_) => colorScheme.inverseSurface,
      getTooltipItems: (touchedSpots) {
        return touchedSpots.map((spot) {
          if (tooltipBarIndex != null && spot.barIndex != tooltipBarIndex) {
            return null;
          }
          return LineTooltipItem(
            formatValue(spot.y),
            TextStyle(
              color: colorScheme.onInverseSurface,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          );
        }).toList();
      },
    ),
  );
}
