import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:asm/data/db/app_database.dart';
import 'package:asm/data/repositories/repositories.dart';
import 'package:asm/domain/models/enums.dart';
import 'package:asm/domain/net_worth_calculator.dart';

void main() {
  late AppDatabase db;
  late MemberRepository memberRepo;
  late AccountRepository accountRepo;
  late SessionRepository sessionRepo;
  late FxRepository fxRepo;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    memberRepo = MemberRepository(db);
    accountRepo = AccountRepository(db);
    sessionRepo = SessionRepository(db);
    fxRepo = FxRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('balancesLatest includes all accounts across sessions', () async {
    final memberId = await memberRepo.create('Test');
    await accountRepo.create(
      memberId: memberId,
      name: 'Savings',
      category: AccountCategory.current,
      currency: Currency.cny,
      initialBalance: 1_000_000,
    );
    await accountRepo.create(
      memberId: memberId,
      name: 'Mortgage',
      category: AccountCategory.liability,
      currency: Currency.cny,
      initialBalance: 200_000,
    );

    final latestSession = await sessionRepo.latest();
    expect(latestSession, isNotNull);

    final sessionBalances =
        await sessionRepo.balancesForSession(latestSession!.id);
    expect(sessionBalances, hasLength(1));

    final latestBalances = await sessionRepo.balancesLatest();
    expect(latestBalances, hasLength(2));

    final converter = await fxRepo.latestConverter();
    final netWorth = NetWorthCalculator.familyNetWorth(
      balances: latestBalances,
      converter: converter,
      displayCurrency: Currency.cny,
    );
    expect(netWorth, 800_000);
  });

  test(
      'balancesAsOfSession keeps earlier accounts when a new account is added '
      'in its own session', () async {
    final memberId = await memberRepo.create('Test');
    await accountRepo.create(
      memberId: memberId,
      name: 'Savings',
      category: AccountCategory.current,
      currency: Currency.cny,
      initialBalance: 1_000_000,
    );

    // Adding a second account creates its own single-account session, the same
    // way the UI does when an account is created with an opening balance.
    await accountRepo.create(
      memberId: memberId,
      name: 'SGD Pocket',
      category: AccountCategory.current,
      currency: Currency.sgd,
      initialBalance: 700,
    );

    // Two single-account sessions exist; the first one (smallest id) is the
    // "previous" session the home delta compares against.
    final sessions = await sessionRepo.watchAll().first;
    expect(sessions, hasLength(2));
    final previous = sessions.reduce((a, b) => a.id < b.id ? a : b);

    // The previous session itself only snapshotted the first account...
    final sessionBalances =
        await sessionRepo.balancesForSession(previous.id);
    expect(sessionBalances, hasLength(1));

    // ...but the cumulative view as of that session still sees it, so the
    // "change since last" delta is only the new account's converted value
    // rather than the entire family total.
    final prevCumulative = await sessionRepo.balancesAsOfSession(previous);
    expect(prevCumulative, hasLength(1));

    final converter = await fxRepo.latestConverter();
    final currentNet = NetWorthCalculator.familyNetWorth(
      balances: await sessionRepo.balancesLatest(),
      converter: converter,
      displayCurrency: Currency.cny,
    );
    final prevNet = NetWorthCalculator.familyNetWorth(
      balances: prevCumulative,
      converter: converter,
      displayCurrency: Currency.cny,
    );
    final newAccountInCny = converter.convert(
      amount: 700,
      from: Currency.sgd,
      to: Currency.cny,
    );

    expect(currentNet - prevNet, closeTo(newAccountInCny, 0.01));
  });

  test('balancesLatest excludes archived accounts', () async {
    final memberId = await memberRepo.create('Test');
    final activeId = await accountRepo.create(
      memberId: memberId,
      name: 'Savings',
      category: AccountCategory.current,
      currency: Currency.cny,
      initialBalance: 100,
    );
    final archivedId = await accountRepo.create(
      memberId: memberId,
      name: 'Old Loan',
      category: AccountCategory.liability,
      currency: Currency.cny,
      initialBalance: 50,
    );
    await accountRepo.archive(archivedId);

    final balances = await sessionRepo.balancesLatest();
    expect(balances, hasLength(1));
    expect(balances.single.accountId, activeId);
  });

  test('familyTrend downsamples same-day sessions to one cumulative point', () async {
    final memberId = await memberRepo.create('Test');
    await accountRepo.create(
      memberId: memberId,
      name: 'Savings',
      category: AccountCategory.current,
      currency: Currency.cny,
      initialBalance: 1_000_000,
    );
    await accountRepo.create(
      memberId: memberId,
      name: 'Brokerage',
      category: AccountCategory.investment,
      currency: Currency.cny,
      initialBalance: 500_000,
    );
    await accountRepo.create(
      memberId: memberId,
      name: 'Mortgage',
      category: AccountCategory.liability,
      currency: Currency.cny,
      initialBalance: 200_000,
    );

    final allSessions = await sessionRepo.watchAll().first;
    expect(allSessions, hasLength(3));

    final trend = await sessionRepo.familyTrend(displayCurrency: Currency.cny);
    expect(trend, hasLength(1));
    expect(trend.single.netWorth, 1_300_000);
  });

  test('familyTrend filters by member and category', () async {
    final kevinId = await memberRepo.create('Kevin');
    final aliceId = await memberRepo.create('Alice');

    await accountRepo.create(
      memberId: kevinId,
      name: 'Kevin Savings',
      category: AccountCategory.current,
      currency: Currency.cny,
      initialBalance: 100_000,
    );
    await accountRepo.create(
      memberId: kevinId,
      name: 'Kevin Brokerage',
      category: AccountCategory.investment,
      currency: Currency.cny,
      initialBalance: 300_000,
    );
    await accountRepo.create(
      memberId: aliceId,
      name: 'Alice Brokerage',
      category: AccountCategory.investment,
      currency: Currency.cny,
      initialBalance: 700_000,
    );

    final all = await sessionRepo.familyTrend(displayCurrency: Currency.cny);
    expect(all.single.netWorth, 1_100_000);

    final kevinOnly = await sessionRepo.familyTrend(
      displayCurrency: Currency.cny,
      memberIds: {kevinId},
    );
    expect(kevinOnly.single.netWorth, 400_000);

    final investmentOnly = await sessionRepo.familyTrend(
      displayCurrency: Currency.cny,
      categories: {AccountCategory.investment},
    );
    expect(investmentOnly.single.netWorth, 1_000_000);

    final kevinInvestment = await sessionRepo.familyTrend(
      displayCurrency: Currency.cny,
      memberIds: {kevinId},
      categories: {AccountCategory.investment},
    );
    expect(kevinInvestment.single.netWorth, 300_000);

    // Multi-select: both members, both asset categories.
    final bothMembers = await sessionRepo.familyTrend(
      displayCurrency: Currency.cny,
      memberIds: {kevinId, aliceId},
    );
    expect(bothMembers.single.netWorth, 1_100_000);

    final currentAndInvestment = await sessionRepo.familyTrend(
      displayCurrency: Currency.cny,
      categories: {AccountCategory.current, AccountCategory.investment},
    );
    expect(currentAndInvestment.single.netWorth, 1_100_000);

    // Multi-member combined with a single category.
    final allInvestments = await sessionRepo.familyTrend(
      displayCurrency: Currency.cny,
      memberIds: {kevinId, aliceId},
      categories: {AccountCategory.investment},
    );
    expect(allInvestments.single.netWorth, 1_000_000);
  });
}
