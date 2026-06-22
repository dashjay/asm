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
      memberId: kevinId,
    );
    expect(kevinOnly.single.netWorth, 400_000);

    final investmentOnly = await sessionRepo.familyTrend(
      displayCurrency: Currency.cny,
      category: AccountCategory.investment,
    );
    expect(investmentOnly.single.netWorth, 1_000_000);

    final kevinInvestment = await sessionRepo.familyTrend(
      displayCurrency: Currency.cny,
      memberId: kevinId,
      category: AccountCategory.investment,
    );
    expect(kevinInvestment.single.netWorth, 300_000);
  });
}
