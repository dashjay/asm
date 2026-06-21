import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

class S3UploadException implements Exception {
  S3UploadException(this.statusCode, this.body);

  final int statusCode;
  final String body;

  @override
  String toString() => 'S3 upload failed ($statusCode): $body';
}

/// Path-style S3 PUT with AWS Signature Version 4 (MinIO / compatible endpoints).
class S3Client {
  S3Client({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  static const _region = 'us-east-1';
  static const _service = 's3';

  Future<void> putObject({
    required String endpoint,
    required String bucket,
    required String accessKey,
    required String secretKey,
    required String objectKey,
    required String localFilePath,
  }) async {
    final body = await File(localFilePath).readAsBytes();
    final payloadHash = _hashHex(body);

    final base = endpoint.trim().replaceAll(RegExp(r'/+$'), '');
    final parsedBase = Uri.parse(base);
    final encodedKey = _encodePath(objectKey);
    final path = '/${_encodePath(bucket)}/$encodedKey';
    final host = _hostHeader(parsedBase);
    final uri = parsedBase.replace(path: path);

    final now = DateTime.now().toUtc();
    final amzDate = _amzDate(now);
    final dateStamp = amzDate.substring(0, 8);

    final headers = <String, String>{
      'host': host,
      'x-amz-content-sha256': payloadHash,
      'x-amz-date': amzDate,
      'content-type': 'application/octet-stream',
      'content-length': body.length.toString(),
    };

    final signedHeaderNames = headers.keys.map((k) => k.toLowerCase()).toList()
      ..sort();
    final signedHeadersStr = signedHeaderNames.join(';');
    final canonicalHeaders = signedHeaderNames
        .map((k) => '$k:${headers[_headerKey(headers, k)]!.trim()}\n')
        .join();

    final canonicalRequest = [
      'PUT',
      path,
      '',
      canonicalHeaders,
      signedHeadersStr,
      payloadHash,
    ].join('\n');

    final credentialScope = '$dateStamp/$_region/$_service/aws4_request';
    final stringToSign = [
      'AWS4-HMAC-SHA256',
      amzDate,
      credentialScope,
      _hashHex(utf8.encode(canonicalRequest)),
    ].join('\n');

    final signingKey = _signingKey(secretKey, dateStamp);
    final signature =
        Hmac(sha256, signingKey).convert(utf8.encode(stringToSign)).toString();

    final authorization =
        'AWS4-HMAC-SHA256 Credential=$accessKey/$credentialScope, '
        'SignedHeaders=$signedHeadersStr, Signature=$signature';

    final response = await _client.put(
      uri,
      headers: {
        ...headers,
        'Authorization': authorization,
      },
      body: body,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw S3UploadException(response.statusCode, response.body);
    }
  }

  static String _hostHeader(Uri uri) {
    if (uri.hasPort && uri.port != 80 && uri.port != 443) {
      return '${uri.host}:${uri.port}';
    }
    return uri.host;
  }

  static String _headerKey(Map<String, String> headers, String lowerKey) {
    for (final entry in headers.entries) {
      if (entry.key.toLowerCase() == lowerKey) return entry.key;
    }
    return lowerKey;
  }

  static String _encodePath(String path) {
    return path.split('/').map(Uri.encodeComponent).join('/');
  }

  static String _hashHex(List<int> data) => sha256.convert(data).toString();

  static String _amzDate(DateTime utc) {
    return '${utc.year.toString().padLeft(4, '0')}'
        '${utc.month.toString().padLeft(2, '0')}'
        '${utc.day.toString().padLeft(2, '0')}T'
        '${utc.hour.toString().padLeft(2, '0')}'
        '${utc.minute.toString().padLeft(2, '0')}'
        '${utc.second.toString().padLeft(2, '0')}Z';
  }

  static List<int> _signingKey(String secretKey, String dateStamp) {
    final kDate = Hmac(sha256, utf8.encode('AWS4$secretKey'))
        .convert(utf8.encode(dateStamp))
        .bytes;
    final kRegion = Hmac(sha256, kDate).convert(utf8.encode(_region)).bytes;
    final kService = Hmac(sha256, kRegion).convert(utf8.encode(_service)).bytes;
    return Hmac(sha256, kService).convert(utf8.encode('aws4_request')).bytes;
  }
}
