import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/providers.dart';
import '../../l10n/app_localizations.dart';

class MembersPage extends ConsumerWidget {
  const MembersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final membersAsync = ref.watch(membersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.familyMembers),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showMemberDialog(context, ref),
          ),
        ],
      ),
      body: membersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (members) => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: members.length,
          separatorBuilder: (_, _) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final member = members[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(member.avatarColor),
                  child: Text(member.name.characters.first),
                ),
                title: Text(member.name),
                trailing: IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _showMemberDialog(
                    context,
                    ref,
                    id: member.id,
                    initialName: member.name,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _showMemberDialog(
    BuildContext context,
    WidgetRef ref, {
    int? id,
    String initialName = '',
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: initialName);
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(id == null ? l10n.addMember : l10n.editMember),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: l10n.nameLabel),
        ),
        actions: [
          if (id != null)
            TextButton(
              onPressed: () async {
                await ref.read(memberRepositoryProvider).delete(id);
                if (context.mounted) Navigator.pop(context, false);
              },
              child: Text(l10n.delete, style: const TextStyle(color: Colors.red)),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.save),
          ),
        ],
      ),
    );

    if (result == true) {
      final name = controller.text.trim();
      if (name.isEmpty) return;
      final repo = ref.read(memberRepositoryProvider);
      if (id == null) {
        await repo.create(name);
      } else {
        await repo.update(id, name);
      }
    }
    controller.dispose();
  }
}
