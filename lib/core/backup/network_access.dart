import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

/// Hostname extracted from an S3-compatible endpoint URL.
String? endpointHost(String endpoint) {
  final trimmed = endpoint.trim();
  if (trimmed.isEmpty || trimmed.contains(' ')) return null;

  final withScheme =
      trimmed.contains('://') ? trimmed : 'https://$trimmed';
  final host = Uri.tryParse(withScheme)?.host;
  if (host == null || host.isEmpty) return null;
  return host;
}

/// Verifies outbound network access before S3 backup (DNS lookup to endpoint).
Future<void> ensureNetworkAccess(String endpoint) async {
  if (kIsWeb) return;

  final host = endpointHost(endpoint);
  if (host == null) {
    throw StateError('invalid_endpoint');
  }

  try {
    final result = await InternetAddress.lookup(host).timeout(
      const Duration(seconds: 10),
    );
    if (result.isEmpty) {
      throw StateError('network_access_denied');
    }
  } on TimeoutException {
    throw StateError('network_access_denied');
  } on SocketException {
    throw StateError('network_access_denied');
  }
}
