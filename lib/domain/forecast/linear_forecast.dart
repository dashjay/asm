class ForecastPoint {
  ForecastPoint({required this.date, required this.value});

  final DateTime date;
  final double value;
}

class LinearForecastResult {
  LinearForecastResult({
    required this.slope,
    required this.intercept,
    required this.projections,
  });

  final double slope;
  final double intercept;
  final List<ForecastPoint> projections;

  double valueAt(DateTime date) {
    return slope * date.millisecondsSinceEpoch + intercept;
  }
}

class LinearForecast {
  static LinearForecastResult? compute({
    required List<({DateTime date, double value})> history,
    required List<int> forwardDays,
    int maxPoints = 12,
  }) {
    if (history.length < 3) return null;

    final points = history.length > maxPoints
        ? history.sublist(history.length - maxPoints)
        : history;

    final xs = points.map((p) => p.date.millisecondsSinceEpoch.toDouble()).toList();
    final ys = points.map((p) => p.value).toList();

    final n = xs.length;
    final sumX = xs.fold(0.0, (a, b) => a + b);
    final sumY = ys.fold(0.0, (a, b) => a + b);
    final sumXY = List.generate(n, (i) => xs[i] * ys[i]).fold(0.0, (a, b) => a + b);
    final sumX2 = xs.map((x) => x * x).fold(0.0, (a, b) => a + b);

    final denom = n * sumX2 - sumX * sumX;
    if (denom == 0) return null;

    final slope = (n * sumXY - sumX * sumY) / denom;
    final intercept = (sumY - slope * sumX) / n;

    final lastDate = points.last.date;
    final projections = forwardDays
        .map(
          (days) => ForecastPoint(
            date: lastDate.add(Duration(days: days)),
            value: slope * lastDate.add(Duration(days: days)).millisecondsSinceEpoch +
                intercept,
          ),
        )
        .toList();

    return LinearForecastResult(
      slope: slope,
      intercept: intercept,
      projections: projections,
    );
  }
}
