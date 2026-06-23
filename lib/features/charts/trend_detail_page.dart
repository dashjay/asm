import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/providers.dart';
import '../../domain/models/enums.dart';
import '../../domain/models/trend_filter.dart';
import '../../l10n/app_localizations.dart';
import 'family_trend_chart.dart';

/// Lets the user drill into the family net-worth trend by selecting any number
/// of family members and/or asset categories. Selecting nothing (the default)
/// shows the same family-total trend as the charts page.
///
/// Multi-select matters because a single account or category in isolation can
/// swing wildly (e.g. cash dropping when a house is bought) while the combined
/// view of the affected categories stays meaningful.
class TrendDetailPage extends ConsumerStatefulWidget {
  const TrendDetailPage({super.key});

  @override
  ConsumerState<TrendDetailPage> createState() => _TrendDetailPageState();
}

class _TrendDetailPageState extends ConsumerState<TrendDetailPage> {
  final Set<int> _memberIds = {};
  final Set<AccountCategory> _categories = {};

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
            Text(
              l10n.trendFilterHint,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 12),
            membersAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (e, _) => Text('$e'),
              data: (members) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FilterSection(
                    label: l10n.familyMemberLabel,
                    children: [
                      _AllChip(
                        label: l10n.allMembers,
                        selected: _memberIds.isEmpty,
                        onSelected: () => setState(_memberIds.clear),
                      ),
                      for (final member in members)
                        FilterChip(
                          label: Text(member.name),
                          selected: _memberIds.contains(member.id),
                          onSelected: (on) => setState(() {
                            if (on) {
                              _memberIds.add(member.id);
                            } else {
                              _memberIds.remove(member.id);
                            }
                          }),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _FilterSection(
                    label: l10n.accountCategoryLabel,
                    children: [
                      _AllChip(
                        label: l10n.allCategories,
                        selected: _categories.isEmpty,
                        onSelected: () => setState(_categories.clear),
                      ),
                      for (final category in AccountCategory.values)
                        FilterChip(
                          label: Text(category.label(l10n)),
                          selected: _categories.contains(category),
                          onSelected: (on) => setState(() {
                            if (on) {
                              _categories.add(category);
                            } else {
                              _categories.remove(category);
                            }
                          }),
                        ),
                    ],
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
                    // Snapshot the mutable selection sets so the provider's
                    // cache key keeps its own copy and re-fetches on change.
                    filter: TrendFilter(
                      memberIds: Set.of(_memberIds),
                      categories: Set.of(_categories),
                    ),
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

class _FilterSection extends StatelessWidget {
  const _FilterSection({required this.label, required this.children});

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: children),
      ],
    );
  }
}

class _AllChip extends StatelessWidget {
  const _AllChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: selected ? (_) {} : (_) => onSelected(),
    );
  }
}
