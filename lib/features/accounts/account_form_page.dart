import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/notifications/notification_scheduler.dart';
import '../../core/providers/providers.dart';
import '../../domain/models/enums.dart';
import '../../l10n/app_localizations.dart';

class AccountFormPage extends ConsumerStatefulWidget {
  const AccountFormPage({super.key, this.accountId});

  final int? accountId;

  @override
  ConsumerState<AccountFormPage> createState() => _AccountFormPageState();
}

class _AccountFormPageState extends ConsumerState<AccountFormPage> {
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  AccountCategory _category = AccountCategory.current;
  Currency _currency = Currency.cny;
  int? _memberId;
  bool _reminderEnabled = true;
  int _reminderDays = 30;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (widget.accountId != null) {
      final account =
          await ref.read(accountRepositoryProvider).getById(widget.accountId!);
      if (account != null) {
        _nameController.text = account.name;
        _category = AccountCategory.fromString(account.category);
        _currency = Currency.fromString(account.currency);
        _memberId = account.memberId;
        _reminderEnabled = account.reminderEnabled;
        _reminderDays = account.reminderIntervalDays;
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final repo = ref.read(accountRepositoryProvider);
    if (_memberId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.selectMemberFirst)),
      );
      return;
    }

    if (widget.accountId == null) {
      final initial = double.tryParse(_balanceController.text);
      await repo.create(
        memberId: _memberId!,
        name: _nameController.text.trim(),
        category: _category,
        currency: _currency,
        reminderIntervalDays: _reminderDays,
        initialBalance: initial,
      );
    } else {
      await repo.update(
        id: widget.accountId!,
        name: _nameController.text.trim(),
        category: _category,
        currency: _currency,
        reminderEnabled: _reminderEnabled,
        reminderIntervalDays: _reminderDays,
      );
    }

    if (mounted) context.pop();
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAccountTitle),
        content: Text(l10n.deleteAccountWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.deleteAccountConfirm,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final accountId = widget.accountId!;
    await ref.read(accountRepositoryProvider).delete(accountId);
    await NotificationScheduler(
      ref.read(accountRepositoryProvider),
      ref.read(settingsRepositoryProvider),
    ).cancelForAccount(accountId);

    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final membersAsync = ref.watch(membersProvider);

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.accountId == null ? l10n.newAccount : l10n.editAccount,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: l10n.accountNameLabel),
          ),
          const SizedBox(height: 16),
          membersAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('$e'),
            data: (members) {
              _memberId ??= members.isNotEmpty ? members.first.id : null;
              return DropdownButtonFormField<int>(
                initialValue: _memberId,
                decoration: InputDecoration(labelText: l10n.familyMemberLabel),
                items: members
                    .map((m) => DropdownMenuItem(value: m.id, child: Text(m.name)))
                    .toList(),
                onChanged: (v) => setState(() => _memberId = v),
              );
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<AccountCategory>(
            initialValue: _category,
            decoration: InputDecoration(labelText: l10n.accountCategoryLabel),
            items: AccountCategory.values
                .map((c) => DropdownMenuItem(
                      value: c,
                      child: Text(c.label(l10n)),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _category = v!),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<Currency>(
            initialValue: _currency,
            decoration: InputDecoration(labelText: l10n.currencyLabel),
            items: Currency.values
                .map((c) => DropdownMenuItem(value: c, child: Text(c.code)))
                .toList(),
            onChanged: widget.accountId == null
                ? (v) => setState(() => _currency = v!)
                : null,
          ),
          if (widget.accountId == null) ...[
            const SizedBox(height: 16),
            TextField(
              controller: _balanceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: l10n.initialBalanceOptional(_currency.code),
              ),
            ),
          ],
          const SizedBox(height: 16),
          SwitchListTile(
            title: Text(l10n.enableUpdateReminder),
            value: _reminderEnabled,
            onChanged: (v) => setState(() => _reminderEnabled = v),
          ),
          DropdownButtonFormField<int>(
            initialValue: _reminderDays,
            decoration: InputDecoration(labelText: l10n.reminderIntervalLabel),
            items: const [7, 30, 90]
                .map((d) => DropdownMenuItem(
                      value: d,
                      child: Text(l10n.reminderDays(d)),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _reminderDays = v!),
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: _save, child: Text(l10n.save)),
          if (widget.accountId != null) ...[
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: _delete,
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
                side: BorderSide(color: Theme.of(context).colorScheme.error),
              ),
              child: Text(l10n.delete),
            ),
          ],
        ],
      ),
    );
  }
}
