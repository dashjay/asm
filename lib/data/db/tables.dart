import 'package:drift/drift.dart';

class FamilyMembers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get avatarColor => integer().withDefault(const Constant(0xFF6750A4))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get memberId => integer().references(FamilyMembers, #id)();
  TextColumn get name => text()();
  TextColumn get category => text()();
  TextColumn get currency => text()();
  BoolColumn get reminderEnabled => boolean().withDefault(const Constant(true))();
  IntColumn get reminderIntervalDays =>
      integer().withDefault(const Constant(30))();
  DateTimeColumn get lastReminderAt => dateTime().nullable()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class FxSnapshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get recordedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get sourceNote => text().withDefault(const Constant(''))();
}

class FxRates extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get fxSnapshotId => integer().references(FxSnapshots, #id)();
  TextColumn get fromCurrency => text()();
  TextColumn get toCurrency => text()();
  RealColumn get rate => real()();
}

class UpdateSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get recordedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get fxSnapshotId => integer().references(FxSnapshots, #id)();
  TextColumn get note => text().withDefault(const Constant(''))();
}

class BalanceSnapshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get accountId => integer().references(Accounts, #id)();
  IntColumn get updateSessionId =>
      integer().references(UpdateSessions, #id)();
  RealColumn get amount => real()();
  DateTimeColumn get recordedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get note => text().withDefault(const Constant(''))();
  TextColumn get changeReason => text().nullable()();
  TextColumn get changeReasonText => text().withDefault(const Constant(''))();
  RealColumn get deltaFromPrevious => real().nullable()();
  RealColumn get deltaPercent => real().nullable()();
}

class AppSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get displayCurrency => text().withDefault(const Constant('cny'))();
  RealColumn get largeChangeThresholdPercent =>
      real().withDefault(const Constant(10))();
  RealColumn get largeChangeThresholdAmount =>
      real().withDefault(const Constant(5000))();
  TextColumn get s3Endpoint => text().withDefault(const Constant(''))();
  TextColumn get s3Bucket => text().withDefault(const Constant(''))();
  TextColumn get s3AccessKey => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}
