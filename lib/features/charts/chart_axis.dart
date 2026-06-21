import 'dart:math' as math;

/// Returns the subset of x-axis point indices that should render a label so a
/// chart never crowds more than [maxLabels] labels onto one screen. The first
/// and last points are always kept; the rest are evenly sampled.
Set<int> visibleLabelIndices(int total, {int maxLabels = 5}) {
  if (total <= maxLabels) {
    return {for (var i = 0; i < total; i++) i};
  }
  final indices = <int>{0, total - 1};
  final step = (total - 1) / (maxLabels - 1);
  for (var i = 1; i < maxLabels - 1; i++) {
    indices.add((step * i).round());
  }
  return indices;
}

/// Picks a "nice" rounded interval (1, 2 or 5 × 10ⁿ) for a value axis spanning
/// [min, max] so labels land on readable round numbers.
double niceInterval(double min, double max, {int targetCount = 4}) {
  final range = max - min;
  if (range <= 0) return 1;
  final rough = range / targetCount;
  final exponent = (math.log(rough) / math.ln10).floor();
  final magnitude = math.pow(10, exponent).toDouble();
  final normalized = rough / magnitude;
  final niceNormalized = normalized <= 1
      ? 1
      : normalized <= 2
          ? 2
          : normalized <= 5
              ? 5
              : 10;
  return niceNormalized * magnitude;
}
