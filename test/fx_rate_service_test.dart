import 'package:asm/data/fx/fx_rate_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('FxRateService.parseResponse', () {
    test('parses CNY and SGD rates plus date', () {
      final result = FxRateService.parseResponse(
        '{"amount":1.0,"base":"USD","date":"2024-06-20",'
        '"rates":{"CNY":7.18,"SGD":1.34}}',
      );
      expect(result.usdToCny, 7.18);
      expect(result.usdToSgd, 1.34);
      expect(result.date, DateTime(2024, 6, 20));
    });

    test('coerces integer rates to double', () {
      final result = FxRateService.parseResponse(
        '{"date":"2024-06-20","rates":{"CNY":7,"SGD":1}}',
      );
      expect(result.usdToCny, 7.0);
      expect(result.usdToSgd, 1.0);
    });

    test('throws when a required rate is missing', () {
      expect(
        () => FxRateService.parseResponse('{"rates":{"CNY":7.18}}'),
        throwsA(isA<FxRateFetchException>()),
      );
    });

    test('throws on malformed JSON', () {
      expect(
        () => FxRateService.parseResponse('not json'),
        throwsA(isA<FxRateFetchException>()),
      );
    });
  });

  group('FxRateService.fetchLatest', () {
    test('returns parsed rates on a 200 response', () async {
      final service = FxRateService(
        baseBackoff: Duration.zero,
        client: MockClient(
          (_) async => http.Response(
            '{"date":"2024-06-20","rates":{"CNY":7.0,"SGD":1.3}}',
            200,
          ),
        ),
      );
      final rates = await service.fetchLatest();
      expect(rates.usdToCny, 7.0);
      expect(rates.usdToSgd, 1.3);
    });

    test('retries then throws on persistent server errors', () async {
      var calls = 0;
      final service = FxRateService(
        maxAttempts: 3,
        baseBackoff: Duration.zero,
        client: MockClient((_) async {
          calls++;
          return http.Response('boom', 500);
        }),
      );
      await expectLater(
        service.fetchLatest(),
        throwsA(isA<FxRateFetchException>()),
      );
      expect(calls, 3);
    });

    test('recovers when a later attempt succeeds', () async {
      var calls = 0;
      final service = FxRateService(
        maxAttempts: 3,
        baseBackoff: Duration.zero,
        client: MockClient((_) async {
          calls++;
          if (calls < 2) return http.Response('boom', 503);
          return http.Response(
            '{"date":"2024-06-20","rates":{"CNY":6.9,"SGD":1.31}}',
            200,
          );
        }),
      );
      final rates = await service.fetchLatest();
      expect(rates.usdToCny, 6.9);
      expect(calls, 2);
    });
  });
}
