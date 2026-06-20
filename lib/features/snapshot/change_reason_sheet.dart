import 'package:flutter/material.dart';

import '../../core/utils/formatters.dart';
import '../../domain/models/enums.dart';

Future<({ChangeReason reason, String note})?> showChangeReasonSheet(
  BuildContext context, {
  required String accountName,
  required double previous,
  required double current,
  required Currency currency,
  required double delta,
  required double deltaPercent,
}) {
  ChangeReason selected = ChangeReason.other;
  final noteController = TextEditingController();

  return showModalBottomSheet<({ChangeReason reason, String note})>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '大额变动 - $accountName',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '${formatMoney(previous, currency)} → ${formatMoney(current, currency)} '
                  '(${formatSignedMoney(delta, currency)}, ${formatPercent(deltaPercent)})',
                ),
                const SizedBox(height: 16),
                Text('变动原因', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: ChangeReason.values.map((reason) {
                    return ChoiceChip(
                      label: Text(reason.label),
                      selected: selected == reason,
                      onSelected: (_) => setState(() => selected = reason),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(labelText: '备注（可选）'),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(
                      context,
                      (reason: selected, note: noteController.text.trim()),
                    ),
                    child: const Text('确认'),
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
