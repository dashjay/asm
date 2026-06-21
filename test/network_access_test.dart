import 'package:asm/core/backup/network_access.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('endpointHost', () {
    test('parses https endpoint', () {
      expect(
        endpointHost(
          'https://3c805adae86a6b85aab750c4e2411a04.r2.cloudflarestorage.com',
        ),
        '3c805adae86a6b85aab750c4e2411a04.r2.cloudflarestorage.com',
      );
    });

    test('adds https scheme when missing', () {
      expect(
        endpointHost('example.r2.cloudflarestorage.com'),
        'example.r2.cloudflarestorage.com',
      );
    });

    test('trims trailing slashes from endpoint', () {
      expect(
        endpointHost('https://example.r2.cloudflarestorage.com/'),
        'example.r2.cloudflarestorage.com',
      );
    });

    test('returns null for empty endpoint', () {
      expect(endpointHost(''), isNull);
      expect(endpointHost('   '), isNull);
    });

    test('returns null for invalid endpoint', () {
      expect(endpointHost('not a url'), isNull);
    });
  });
}
