import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/providers.dart';
import '../../l10n/app_localizations.dart';

/// Wraps the app and, when the biometric lock is enabled in settings, hides the
/// content behind a lock screen until the user authenticates.
///
/// The app re-locks whenever it is sent to the background, so returning to it
/// requires authenticating again.
class AppLockGate extends ConsumerStatefulWidget {
  const AppLockGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate>
    with WidgetsBindingObserver {
  bool _unlocked = false;
  bool _authenticating = false;
  bool _promptedSinceLock = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Ignore lifecycle churn caused by the system auth dialog itself.
    if (_authenticating) return;
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      final enabled =
          ref.read(settingsProvider).valueOrNull?.biometricLockEnabled ?? false;
      if (enabled && _unlocked) {
        setState(() {
          _unlocked = false;
          _promptedSinceLock = false;
        });
      }
    }
  }

  Future<void> _authenticate() async {
    if (_authenticating) return;
    setState(() => _authenticating = true);
    final reason = AppLocalizations.of(context)!.biometricUnlockReason;
    final ok = await ref.read(biometricAuthProvider).authenticate(reason);
    if (!mounted) return;
    setState(() {
      _authenticating = false;
      if (ok) _unlocked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final enabled = settingsAsync.valueOrNull?.biometricLockEnabled ?? false;

    if (!enabled || _unlocked) {
      return widget.child;
    }

    // Auto-prompt once each time we enter the locked state; if the user cancels
    // they can retry with the on-screen button (avoids a re-prompt loop).
    if (!_authenticating && !_promptedSinceLock) {
      _promptedSinceLock = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _authenticate();
      });
    }

    return _LockScreen(
      authenticating: _authenticating,
      onUnlock: _authenticate,
    );
  }
}

class _LockScreen extends StatelessWidget {
  const _LockScreen({required this.authenticating, required this.onUnlock});

  final bool authenticating;
  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.fingerprint,
                size: 72,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                l10n.appTitle,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.appLockedMessage,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: authenticating ? null : onUnlock,
                icon: authenticating
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.lock_open),
                label: Text(l10n.unlock),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
