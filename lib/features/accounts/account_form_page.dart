import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/providers.dart';
import '../../domain/models/enums.dart';

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
    final repo = ref.read(accountRepositoryProvider);
    if (_memberId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择成员')),
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

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(membersProvider);

    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.accountId == null ? '新建账户' : '编辑账户'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: '账户名称'),
          ),
          const SizedBox(height: 16),
          membersAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('$e'),
            data: (members) {
              _memberId ??= members.isNotEmpty ? members.first.id : null;
              return DropdownButtonFormField<int>(
                value: _memberId,
                decoration: const InputDecoration(labelText: '家庭成员'),
                items: members
                    .map((m) => DropdownMenuItem(value: m.id, child: Text(m.name)))
                    .toList(),
                onChanged: (v) => setState(() => _memberId = v),
              );
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<AccountCategory>(
            value: _category,
            decoration: const InputDecoration(labelText: '账户类别'),
            items: AccountCategory.values
                .map((c) => DropdownMenuItem(value: c, child: Text(c.label)))
                .toList(),
            onChanged: (v) => setState(() => _category = v!),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<Currency>(
            value: _currency,
            decoration: const InputDecoration(labelText: '币种'),
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
                labelText: '初始余额（${_currency.code}，可选）',
              ),
            ),
          ],
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('启用更新提醒'),
            value: _reminderEnabled,
            onChanged: (v) => setState(() => _reminderEnabled = v),
          ),
          DropdownButtonFormField<int>(
            value: _reminderDays,
            decoration: const InputDecoration(labelText: '提醒周期'),
            items: const [7, 30, 90]
                .map((d) => DropdownMenuItem(value: d, child: Text('$d 天')))
                .toList(),
            onChanged: (v) => setState(() => _reminderDays = v!),
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: _save, child: const Text('保存')),
        ],
      ),
    );
  }
}
