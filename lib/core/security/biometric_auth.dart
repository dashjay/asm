import 'package:local_auth/local_auth.dart';

/// Thin wrapper around [LocalAuthentication] so the rest of the app depends on a
/// small, mockable surface rather than the plugin directly.
class BiometricAuthService {
  BiometricAuthService([LocalAuthentication? auth])
      : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  /// Whether this device can authenticate the user — either via enrolled
  /// biometrics (fingerprint/face) or a device credential (PIN/pattern).
  Future<bool> isAvailable() async {
    try {
      // `isDeviceSupported` already covers device-credential fallback, so a
      // device with a secure lock screen counts even without enrolled biometrics.
      return await _auth.isDeviceSupported();
    } on Exception {
      return false;
    }
  }

  /// Prompts the user to authenticate. Returns true only on success.
  ///
  /// Device-credential fallback is allowed (biometricOnly: false) so the user
  /// can still get in with their PIN/pattern if a fingerprint won't read,
  /// avoiding a hard lock-out.
  Future<bool> authenticate(String localizedReason) async {
    try {
      return await _auth.authenticate(
        localizedReason: localizedReason,
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
    } on Exception {
      return false;
    }
  }
}
