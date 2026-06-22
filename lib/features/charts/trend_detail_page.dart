import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/providers.dart';
import '../../domain/models/enums.dart';
import '../../l10n/app_localizations.dart';
import 'family_trend_chart.dart';

/// Lets the user drill into the family net-worth trend by selecting a specific
/// family member and/or asset category. With nothing selected (the default) it
/// shows the same family-total trend as the charts page.
class TrendDetailPage extends ConsumerStatefulWidget {
  const TrendDetailPage({super.key});

  @override
  ConsumerState<TrendDetailPage> createState() => _TrendDetailPageState();
}

class _TrendDetailPageState extends ConsumerState<TrendDetailPage> {
  int? _memberId;
  AccountCategory? _category;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final display = ref.watch(displayCurrencyProvider);
    final membersAsync = ref.watch(membersProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.trendDetailsTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            membersAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (e, _) => Text('$e'),
              data: (members) => Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int?>(
                      initialValue: _memberId,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: l10n.familyMemberLabel,
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem<int?>(
                          value: null,
                          child: Text(l10n.allMembers),
                        ),
                        for (final member in members)
                          DropdownMenuItem<int?>(
                            value: member.id,
                            child: Text(member.name),
                          ),
                      ],
                      onChanged: (value) =>
                          setState(() => _memberId = value),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<AccountCategory?>(
                      initialValue: _category,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: l10n.accountCategoryLabel,
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem<AccountCategory?>(
                          value: null,
                          child: Text(l10n.allCategories),
                        ),
                        for (final category in AccountCategory.values)
                          DropdownMenuItem<AccountCategory?>(
                            value: category,
                            child: Text(category.label(l10n)),
                          ),
                      ],
                      onChanged: (value) =>
                          setState(() => _category = value),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: FamilyTrendChart(
                    displayCurrency: display,
                    showForecast: true,
                    memberId: _memberId,
                    category: _category,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
