import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/models/enums.dart';

class FxRateFetchException implements Exception {
  FxRateFetchException(this.message);

  final String message;

  @override
  String toString() => 'FxRateFetchException: $message';
}

/// Latest USD-based FX rates fetched from a remote provider.
class FetchedFxRates {
  const FetchedFxRates({
    required this.usdRates,
    required this.date,
  });

  /// `USD -> X` rates keyed by [Currency]. Only currencies the upstream
  /// provider returned are present; callers fill any gaps from defaults.
  final Map<Currency, double> usdRates;

  /// The day the upstream provider published these rates.
  final DateTime date;
}

/// Comma-separated list of every supported non-USD currency code, used to build
/// the upstream request (e.g. `CNY,SGD,EUR,...`).
final String _supportedTargetCodes = Currency.values
    .where((c) => c != Currency.usd)
    .map((c) => c.code)
    .join(',');

/// Fetches the latest `USD -> X` rates for every supported currency from a
/// free, key-less endpoint (frankfurter.app, backed by ECB reference rates).
///
/// On any network/parse failure it retries a few times with exponential
/// backoff and then throws [FxRateFetchException] so the caller can fall back
/// to manual entry.
class FxRateService {
  FxRateService({
    http.Client? client,
    Uri? endpoint,
    this.maxAttempts = 3,
    this.timeout = const Duration(seconds: 8),
    this.baseBackoff = const Duration(milliseconds: 500),
  })  : _client = client ?? http.Client(),
        _endpoint = endpoint ??
            Uri.parse(
              'https://api.frankfurter.app/latest'
              '?from=USD&to=$_supportedTargetCodes',
            );

  final http.Client _client;
  final Uri _endpoint;
  final int maxAttempts;
  final Duration timeout;
  final Duration baseBackoff;

  Future<FetchedFxRates> fetchLatest() async {
    Object? lastError;
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      if (attempt > 0 && baseBackoff > Duration.zero) {
        // Exponential backoff: base, 2x, 4x, ...
        await Future<void>.delayed(baseBackoff * (1 << (attempt - 1)));
      }
      try {
        final response = await _client.get(_endpoint).timeout(timeout);
        if (response.statusCode < 200 || response.statusCode >= 300) {
          throw FxRateFetchException('HTTP ${response.statusCode}');
        }
        return parseResponse(response.body);
      } catch (e) {
        lastError = e;
      }
    }
    throw FxRateFetchException(
      'Failed to fetch FX rates after $maxAttempts attempts: $lastError',
    );
  }

  /// Parses a frankfurter.app `/latest` JSON body into [FetchedFxRates].
  ///
  /// Kept separate from the network call so it is trivially unit-testable.
  /// Picks up every supported currency present in the response and ignores
  /// extras; throws only when the payload is malformed or yields no usable
  /// rates at all (so a provider dropping one currency does not block updates).
  static FetchedFxRates parseResponse(String body) {
    final Object? decoded;
    try {
      decoded = jsonDecode(body);
    } on FormatException catch (e) {
      throw FxRateFetchException('Invalid JSON: ${e.message}');
    }
    if (decoded is! Map<String, dynamic>) {
      throw FxRateFetchException('Unexpected response shape');
    }
    final rates = decoded['rates'];
    if (rates is! Map<String, dynamic>) {
      throw FxRateFetchException('Response is missing the "rates" object');
    }

    final usdRates = <Currency, double>{};
    for (final currency in Currency.values) {
      if (currency == Currency.usd) continue;
      final value = rates[currency.code];
      if (value is num) {
        usdRates[currency] = value.toDouble();
      }
    }
    if (usdRates.isEmpty) {
      throw FxRateFetchException('Response contained no supported rates');
    }

    final rawDate = decoded['date'];
    final date = rawDate is String
        ? DateTime.tryParse(rawDate) ?? DateTime.now()
        : DateTime.now();
    return FetchedFxRates(usdRates: usdRates, date: date);
  }
}
