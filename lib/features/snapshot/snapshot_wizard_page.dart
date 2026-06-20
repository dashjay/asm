import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/notifications/notification_scheduler.dart';
import '../../data/db/app_database.dart';
import '../../core/providers/providers.dart';
import '../../core/utils/formatters.dart';
import '../../domain/currency/currency_converter.dart';
import '../../domain/models/enums.dart';
import '../../domain/net_worth_calculator.dart';
import 'change_reason_sheet.dart';

class SnapshotWizardPage extends ConsumerStatefulWidget {
  const SnapshotWizardPage({super.key});

  @override
  ConsumerState<SnapshotWizardPage> createState() => _SnapshotWizardPageState();
}

class _SnapshotWizardPageState extends ConsumerState<SnapshotWizardPage> {
  int _step = 0;
  final _usdToCnyController = TextEditingController(text: '7.25');
  final _usdToSgdController = TextEditingController(text: '1.35');
  final _sourceNoteController = TextEditingController();
  final _amountControllers = <int, TextEditingController>{};
  final _changeMeta = <int, ({ChangeReason reason, String note})>{};
  Map<int, double> _previousAmounts = {};
  List<Account> _accounts = [];
  bool _loading = true;

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
        if (rate.fromCurrency == Currency.usd.name &&
            rate.toCurrency == Currency.cny.name) {
          _usdToCnyController.text = rate.rate.toString();
        }
        if (rate.fromCurrency == Currency.usd.name &&
            rate.toCurrency == Currency.sgd.name) {
          _usdToSgdController.text = rate.rate.toString();
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
  }

  @override
  void dispose() {
    _usdToCnyController.dispose();
    _usdToSgdController.dispose();
    _sourceNoteController.dispose();
    for (final c in _amountControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  CurrencyConverter get _converter => CurrencyConverter.fromUsdRates(
        usdToCny: double.parse(_usdToCnyController.text),
        usdToSgd: double.parse(_usdToSgdController.text),
      );

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
    final settings = await ref.read(settingsRepositoryProvider).get();
    final display = Currency.fromString(settings.displayCurrency);
    final previousFx = await ref.read(fxRepositoryProvider).latestConverter();

    final amounts = <int, double>{};
    for (final account in _accounts) {
      amounts[account.id] =
          double.parse(_amountControllers[account.id]!.text.trim());
    }

    await ref.read(sessionRepositoryProvider).createSession(
          usdToCny: double.parse(_usdToCnyController.text),
          usdToSgd: double.parse(_usdToSgdController.text),
          sourceNote: _sourceNoteController.text.trim(),
          accountAmounts: amounts,
          changeMeta: _changeMeta,
          thresholdPercent: settings.largeChangeThresholdPercent,
          thresholdAmount: settings.largeChangeThresholdAmount,
          displayCurrency: display,
          previousFx: previousFx,
        );

    await NotificationScheduler(ref.read(accountRepositoryProvider))
        .rescheduleAll();

    ref.invalidate(homeSummaryProvider);
    ref.invalidate(familyTrendProvider);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(['录入汇率', '录入余额', '预览确认'][_step]),
      ),
      body: Stepper(
        currentStep: _step,
        onStepContinue: () async {
          if (_step == 0) {
            if (double.tryParse(_usdToCnyController.text) == null ||
                double.tryParse(_usdToSgdController.text) == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('请输入有效汇率')),
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
                  child: Text(_step == 2 ? '确认提交' : '下一步'),
                ),
                const SizedBox(width: 12),
                if (_step > 0)
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('上一步'),
                  ),
              ],
            ),
          );
        },
        steps: [
          Step(
            title: const Text('汇率快照'),
            isActive: _step >= 0,
            state: _step > 0 ? StepState.complete : StepState.indexed,
            content: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                children: [
                  TextField(
                    controller: _usdToCnyController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: '1 USD = ? CNY',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _usdToSgdController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: '1 USD = ? SGD',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _sourceNoteController,
                    decoration: const InputDecoration(
                      labelText: '来源备注（如：中国银行 App）',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Step(
            title: const Text('账户余额'),
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
                      displayCurrency: ref.watch(settingsProvider).value != null
                          ? Currency.fromString(
                              ref.watch(settingsProvider).value!.displayCurrency,
                            )
                          : Currency.cny,
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ),
          Step(
            title: const Text('预览'),
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
        labelText: '${account.name} (${currency.symbol})',
        suffixText: currency != displayCurrency
            ? '≈ ${formatMoney(converted, displayCurrency)}'
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
                '${currency.code} 家庭净值',
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
                ),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
            ],
            if (snapshot.hasData) ...[
              const Divider(),
              Text('与上次对比（${snapshot.data!.display.code}）'),
              Text(
                '余额变动: ${formatSignedMoney(snapshot.data!.balanceChange, snapshot.data!.display)}',
              ),
              Text(
                '汇率变动: ${formatSignedMoney(snapshot.data!.fxChange, snapshot.data!.display)}',
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

    final prevBalances = await sessionRepo.balancesForSession(latest.id);
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
