import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/notifications/notification_scheduler.dart';
import '../../core/providers/providers.dart';
import '../../domain/models/enums.dart';
import '../../l10n/app_localizations.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final _percentController = TextEditingController();
  final _amountController = TextEditingController();
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final settings = await ref.read(settingsRepositoryProvider).get();
    _percentController.text = settings.largeChangeThresholdPercent.toString();
    _amountController.text = settings.largeChangeThresholdAmount.toString();
    if (mounted) setState(() => _loaded = true);
  }

  @override
  void dispose() {
    _percentController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _saveThresholds() async {
    final l10n = AppLocalizations.of(context)!;
    await ref.read(settingsRepositoryProvider).updateThresholds(
          percent: double.parse(_percentController.text),
          amount: double.parse(_amountController.text),
        );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.thresholdsSaved)),
      );
    }
  }

  Future<void> _updateLocale(String languageCode) async {
    await ref.read(settingsRepositoryProvider).updateLocale(languageCode);
    await NotificationScheduler(
      ref.read(accountRepositoryProvider),
      ref.read(settingsRepositoryProvider),
    ).rescheduleAll();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (!_loaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.language, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          settingsAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('$e'),
            data: (settings) {
              final locale = settings.localeLanguageCode;
              return SegmentedButton<String>(
                segments: [
                  ButtonSegment(value: 'en', label: Text(l10n.languageEnglish)),
                  ButtonSegment(value: 'zh', label: Text(l10n.languageChinese)),
                ],
                selected: {locale},
                onSelectionChanged: (set) => _updateLocale(set.first),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(l10n.displaySettings, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          settingsAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('$e'),
            data: (settings) {
              final display = Currency.fromString(settings.displayCurrency);
              return SegmentedButton<Currency>(
                segments: Currency.values
                    .map((c) => ButtonSegment(value: c, label: Text(c.code)))
                    .toList(),
                selected: {display},
                onSelectionChanged: (set) async {
                  await ref
                      .read(settingsRepositoryProvider)
                      .updateDisplayCurrency(set.first);
                },
              );
            },
          ),
          const SizedBox(height: 24),
          Text(l10n.largeChangeThresholds, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _percentController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: l10n.changePercentLabel),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(labelText: l10n.changeAmountLabel),
          ),
          const SizedBox(height: 12),
          FilledButton(onPressed: _saveThresholds, child: Text(l10n.saveThresholds)),
          const SizedBox(height: 24),
          ListTile(
            title: Text(l10n.dataBackup),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/settings/backup'),
          ),
          const SizedBox(height: 64),
        ],
      ),
    );
  }
}
