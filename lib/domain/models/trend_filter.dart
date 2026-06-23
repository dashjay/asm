import 'enums.dart';

/// Immutable selection used to scope the family net-worth trend to one or more
/// family members and/or one or more asset categories.
///
/// An empty [memberIds] means "all members"; an empty [categories] means "all
/// categories". The two dimensions combine with AND (a member's account must
/// also match a selected category to be counted).
///
/// This is a value object: two filters with the same contents are equal, which
/// is required so a Riverpod `family` provider keyed on it caches correctly and
/// does not rebuild on every widget build.
class TrendFilter {
  const TrendFilter({
    this.memberIds = const {},
    this.categories = const {},
  });

  final Set<int> memberIds;
  final Set<AccountCategory> categories;

  bool get isEmpty => memberIds.isEmpty && categories.isEmpty;

  TrendFilter copyWith({
    Set<int>? memberIds,
    Set<AccountCategory>? categories,
  }) =>
      TrendFilter(
        memberIds: memberIds ?? this.memberIds,
        categories: categories ?? this.categories,
      );

  @override
  bool operator ==(Object other) =>
      other is TrendFilter &&
      _setEquals(memberIds, other.memberIds) &&
      _setEquals(categories, other.categories);

  @override
  int get hashCode => Object.hash(
        Object.hashAllUnordered(memberIds),
        Object.hashAllUnordered(categories),
      );
}

bool _setEquals<T>(Set<T> a, Set<T> b) {
  if (identical(a, b)) return true;
  if (a.length != b.length) return false;
  return a.containsAll(b);
}
