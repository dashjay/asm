import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_constants.dart';
import '../../core/notifications/notification_scheduler.dart';
import '../../data/db/app_database.dart';
import '../../core/providers/providers.dart';
import '../../core/utils/formatters.dart';
import '../../domain/currency/currency_converter.dart';
import '../../domain/currency/fx_defaults.dart';
import '../../domain/models/enums.dart';
import '../../domain/net_worth_calculator.dart';
import '../../l10n/app_localizations.dart';
import 'change_reason_sheet.dart';

class SnapshotWizardPage extends ConsumerStatefulWidget {
  const SnapshotWizardPage({super.key});

  @override
  ConsumerState<SnapshotWizardPage> createState() => _SnapshotWizardPageState();
}

class _SnapshotWizardPageState extends ConsumerState<SnapshotWizardPage> {
  int _step = 0;

  /// One `USD -> X` input per non-USD currency, seeded with fallback defaults.
  final Map<Currency, TextEditingController> _rateControllers = {
    for (final c in Currency.values)
      if (c != Currency.usd)
        c: TextEditingController(text: defaultUsdRate(c).toString()),
  };
  final _sourceNoteController = TextEditingController();
  final _amountControllers = <int, TextEditingController>{};
  final _changeMeta = <int, ({ChangeReason reason, String note})>{};
  final Map<int, double> _previousAmounts = {};
  List<Account> _accounts = [];
  bool _loading = true;
  bool _fetchingRates = false;
  bool _fetchFailed = false;
  bool _ratesAutoFilled = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final fxRepo = ref.read(fxRepositoryProvider);
    final latest = await fxRepo.latest();
    if (latest != null) {
      final rates = await fxRepo.ratesForSnapshot(latest.id);
      for (final rate in rates) {
        if (rate.fromCurrency != Currency.usd.name) continue;
        final target =
            Currency.values.where((c) => c.name == rate.toCurrency).firstOrNull;
        if (target != null && _rateControllers.containsKey(target)) {
          _rateControllers[target]!.text = rate.rate.toString();
        }
      }
      _sourceNoteController.text = latest.sourceNote;
    }

    final accounts = await ref.read(accountRepositoryProvider).watchActive().first;
    _accounts = accounts;
    for (final account in accounts) {
      final latestSnap =
          await ref.read(accountRepositoryProvider).latestSnapshot(account.id);
      _amountControllers[account.id] = TextEditingController(
        text: latestSnap?.amount.toString() ?? '0',
      );
      if (latestSnap != null) {
        _previousAmounts[account.id] = latestSnap.amount;
      }
    }

    if (mounted) setState(() => _loading = false);

    // Once the wizard is on screen, try to pull the latest rates online. On
    // failure we keep the values pre-filled above (latest snapshot or defaults)
    // so the user can simply type them in.
    await _fetchLatestRates();
  }

  Future<void> _fetchLatestRates() async {
    if (!mounted) return;
    setState(() {
      _fetchingRates = true;
      _fetchFailed = false;
    });
    try {
      final rates = await ref.read(fxRateServiceProvider).fetchLatest();
      if (!mounted) return;
      final day = rates.date.toIso8601String().substring(0, 10);
      setState(() {
        for (final entry in rates.usdRates.entries) {
          _rateControllers[entry.key]?.text = entry.value.toString();
        }
        _sourceNoteController.text = '$kFxApiSourceLabel · $day';
        _fetchingRates = false;
        _ratesAutoFilled = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _fetchingRates = false;
        _fetchFailed = true;
        _ratesAutoFilled = false;
      });
    }
  }

  @override
  void dispose() {
    for (final c in _rateControllers.values) {
      c.dispose();
    }
    _sourceNoteController.dispose();
    for (final c in _amountControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  /// Parses the entered `USD -> X` rates, falling back to defaults for any
  /// field that is empty or invalid so the converter is always complete.
  Map<Currency, double> get _usdRates => {
        for (final entry in _rateControllers.entries)
          entry.key:
              double.tryParse(entry.value.text.trim()) ?? defaultUsdRate(entry.key),
      };

  CurrencyConverter get _converter => CurrencyConverter.fromUsdRates(_usdRates);

  Future<bool> _validateBalances() async {
    final settings = await ref.read(settingsRepositoryProvider).get();
    final display = Currency.fromString(settings.displayCurrency);
    final thresholdPercent = settings.largeChangeThresholdPercent;
    final thresholdAmount = settings.largeChangeThresholdAmount;

    for (final account in _accounts) {
      final amount = double.tryParse(_amountControllers[account.id]!.text);
      if (amount == null) continue;
      final previous = _previousAmounts[account.id];
      if (previous == null) continue;

      final delta = amount - previous;
      final deltaPercent = previous == 0 ? 0.0 : (delta / previous) * 100;
      final currency = Currency.fromString(account.currency);
      final convertedDelta = _converter.convert(
        amount: delta.abs(),
        from: currency,
        to: display,
      );

      final isLarge = deltaPercent.abs() >= thresholdPercent ||
          convertedDelta >= thresholdAmount;

      if (isLarge && !_changeMeta.containsKey(account.id)) {
        if (!mounted) return false;
        final reason = await showChangeReasonSheet(
          context,
          accountName: account.name,
          previous: previous,
          current: amount,
          currency: currency,
          delta: delta,
          deltaPercent: deltaPercent,
        );
        if (reason == null) return false;
        _changeMeta[account.id] = reason;
      }
    }
    return true;
  }

  Future<void> _submit() async {
    final amounts = <int, double>{};
    for (final account in _accounts) {
      amounts[account.id] =
          double.parse(_amountControllers[account.id]!.text.trim());
    }

    // Derived providers (home summary, trends, latest FX) watch the database
    // directly, so they refresh on their own once this write commits.
    await ref.read(sessionRepositoryProvider).createSession(
          usdRates: _usdRates,
          sourceNote: _sourceNoteController.text.trim(),
          accountAmounts: amounts,
          changeMeta: _changeMeta,
        );

    await NotificationScheduler(
      ref.read(accountRepositoryProvider),
      ref.read(settingsRepositoryProvider),
    ).rescheduleAll();

    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final stepTitles = [
      l10n.wizardStepFx,
      l10n.wizardStepBalances,
      l10n.wizardStepPreview,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(stepTitles[_step]),
      ),
      body: Stepper(
        currentStep: _step,
        onStepContinue: () async {
          if (_step == 0) {
            final allValid = _rateControllers.values.every(
              (c) => (double.tryParse(c.text.trim()) ?? 0) > 0,
            );
            if (!allValid) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.enterValidFxRates)),
              );
              return;
            }
            setState(() => _step = 1);
          } else if (_step == 1) {
            final ok = await _validateBalances();
            if (ok) setState(() => _step = 2);
          } else {
            await _submit();
          }
        },
        onStepCancel: () {
          if (_step > 0) {
            setState(() => _step -= 1);
          } else {
            context.pop();
          }
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              children: [
                FilledButton(
                  onPressed: details.onStepContinue,
                  child: Text(_step == 2 ? l10n.confirmSubmit : l10n.next),
                ),
                const SizedBox(width: 12),
                if (_step > 0)
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: Text(l10n.previous),
                  ),
              ],
            ),
          );
        },
        steps: [
          Step(
            title: Text(l10n.fxSnapshot),
            isActive: _step >= 0,
            state: _step > 0 ? StepState.complete : StepState.indexed,
            content: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _FxFetchStatus(
                    fetching: _fetchingRates,
                    failed: _fetchFailed,
                    autoFilled: _ratesAutoFilled,
                    onRetry: _fetchLatestRates,
                  ),
                  for (final entry in _rateControllers.entries) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: entry.value,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        labelText: l10n.usdToCurrencyLabel(entry.key.code),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  TextField(
                    controller: _sourceNoteController,
                    decoration: InputDecoration(
                      labelText: l10n.sourceNoteLabel,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Step(
            title: Text(l10n.accountBalances),
            isActive: _step >= 1,
            state: _step > 1 ? StepState.complete : StepState.indexed,
            content: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                children: [
                  for (final account in _accounts) ...[
                    _BalanceField(
                      account: account,
                      controller: _amountControllers[account.id]!,
                      converter: _converter,
                      displayCurrency: ref.watch(displayCurrencyProvider),
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ),
          Step(
            title: Text(l10n.preview),
            isActive: _step >= 2,
            content: _PreviewStep(
              accounts: _accounts,
              amounts: {
                for (final a in _accounts)
                  a.id: double.tryParse(_amountControllers[a.id]!.text) ?? 0,
              },
              converter: _converter,
            ),
          ),
        ],
      ),
    );
  }
}

/// Inline banner above the FX inputs that reflects the auto-fetch lifecycle:
/// fetching, success (auto-filled), or failure (with a retry action).
class _FxFetchStatus extends StatelessWidget {
  const _FxFetchStatus({
    required this.fetching,
    required this.failed,
    required this.autoFilled,
    required this.onRetry,
  });

  final bool fetching;
  final bool failed;
  final bool autoFilled;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (fetching) {
      return Row(
        children: [
          const SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(l10n.fetchingFxRates)),
        ],
      );
    }

    if (failed) {
      return Row(
        children: [
          Icon(Icons.cloud_off, size: 18, color: theme.colorScheme.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.fxFetchFailed,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
          TextButton(
            onPressed: onRetry,
            child: Text(l10n.retry),
          ),
        ],
      );
    }

    if (autoFilled) {
      return Row(
        children: [
          Icon(Icons.check_circle_outline,
              size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(l10n.fxRatesAutoFilled)),
          TextButton(
            onPressed: onRetry,
            child: Text(l10n.fetchLatestFxRates),
          ),
        ],
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: onRetry,
        icon: const Icon(Icons.refresh, size: 18),
        label: Text(l10n.fetchLatestFxRates),
      ),
    );
  }
}

class _BalanceField extends StatelessWidget {
  const _BalanceField({
    required this.account,
    required this.controller,
    required this.converter,
    required this.displayCurrency,
  });

  final Account account;
  final TextEditingController controller;
  final CurrencyConverter converter;
  final Currency displayCurrency;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final currency = Currency.fromString(account.currency);
    final amount = double.tryParse(controller.text) ?? 0;
    final converted = converter.convert(
      amount: amount,
      from: currency,
      to: displayCurrency,
    );

    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: l10n.accountBalanceLabel(account.name, currency.symbol),
        suffixText: currency != displayCurrency
            ? l10n.approxAmount(formatMoney(converted, displayCurrency, locale))
            : null,
      ),
    );
  }
}

class _PreviewStep extends ConsumerWidget {
  const _PreviewStep({
    required this.accounts,
    required this.amounts,
    required this.converter,
  });

  final List<Account> accounts;
  final Map<int, double> amounts;
  final CurrencyConverter converter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final balances = accounts.map((a) {
      return AccountBalance(
        accountId: a.id,
        category: AccountCategory.fromString(a.category),
        currency: Currency.fromString(a.currency),
        amount: amounts[a.id] ?? 0,
      );
    }).toList();

    return FutureBuilder(
      future: _compareWithPrevious(ref, balances),
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final currency in Currency.values) ...[
              Text(
                l10n.familyNetWorthCurrency(currency.code),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                formatMoney(
                  NetWorthCalculator.familyNetWorth(
                    balances: balances,
                    converter: converter,
                    displayCurrency: currency,
                  ),
                  currency,
                  locale,
                ),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
            ],
            if (snapshot.hasData) ...[
              const Divider(),
              Text(l10n.compareWithPrevious(snapshot.data!.display.code)),
              Text(
                l10n.balanceChange(
                  formatSignedMoney(
                    snapshot.data!.balanceChange,
                    snapshot.data!.display,
                    locale,
                  ),
                ),
              ),
              Text(
                l10n.fxChange(
                  formatSignedMoney(
                    snapshot.data!.fxChange,
                    snapshot.data!.display,
                    locale,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Future<({Currency display, double balanceChange, double fxChange})?>
      _compareWithPrevious(WidgetRef ref, List<AccountBalance> balances) async {
    final settings = await ref.read(settingsRepositoryProvider).get();
    final display = Currency.fromString(settings.displayCurrency);
    final sessionRepo = ref.read(sessionRepositoryProvider);
    final fxRepo = ref.read(fxRepositoryProvider);
    final latest = await sessionRepo.latest();
    if (latest == null) return null;

    final prevBalances = await sessionRepo.balancesAsOfSession(latest);
    final prevFx = await fxRepo.converterForSnapshot(latest.fxSnapshotId);
    final attr = NetWorthCalculator.attributeChange(
      previousBalances: prevBalances,
      currentBalances: balances,
      previousFx: prevFx,
      currentFx: converter,
      displayCurrency: display,
    );
    return (
      display: display,
      balanceChange: attr.balanceChange,
      fxChange: attr.fxChange,
    );
  }
}
