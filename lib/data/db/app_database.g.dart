// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FamilyMembersTable extends FamilyMembers
    with TableInfo<$FamilyMembersTable, FamilyMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FamilyMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarColorMeta = const VerificationMeta(
    'avatarColor',
  );
  @override
  late final GeneratedColumn<int> avatarColor = GeneratedColumn<int>(
    'avatar_color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0xFF6750A4),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    avatarColor,
    sortOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'family_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<FamilyMember> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('avatar_color')) {
      context.handle(
        _avatarColorMeta,
        avatarColor.isAcceptableOrUnknown(
          data['avatar_color']!,
          _avatarColorMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FamilyMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FamilyMember(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      avatarColor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}avatar_color'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FamilyMembersTable createAlias(String alias) {
    return $FamilyMembersTable(attachedDatabase, alias);
  }
}

class FamilyMember extends DataClass implements Insertable<FamilyMember> {
  final int id;
  final String name;
  final int avatarColor;
  final int sortOrder;
  final DateTime createdAt;
  const FamilyMember({
    required this.id,
    required this.name,
    required this.avatarColor,
    required this.sortOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['avatar_color'] = Variable<int>(avatarColor);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FamilyMembersCompanion toCompanion(bool nullToAbsent) {
    return FamilyMembersCompanion(
      id: Value(id),
      name: Value(name),
      avatarColor: Value(avatarColor),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
    );
  }

  factory FamilyMember.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FamilyMember(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      avatarColor: serializer.fromJson<int>(json['avatarColor']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'avatarColor': serializer.toJson<int>(avatarColor),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FamilyMember copyWith({
    int? id,
    String? name,
    int? avatarColor,
    int? sortOrder,
    DateTime? createdAt,
  }) => FamilyMember(
    id: id ?? this.id,
    name: name ?? this.name,
    avatarColor: avatarColor ?? this.avatarColor,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  FamilyMember copyWithCompanion(FamilyMembersCompanion data) {
    return FamilyMember(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      avatarColor: data.avatarColor.present
          ? data.avatarColor.value
          : this.avatarColor,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FamilyMember(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatarColor: $avatarColor, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, avatarColor, sortOrder, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FamilyMember &&
          other.id == this.id &&
          other.name == this.name &&
          other.avatarColor == this.avatarColor &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt);
}

class FamilyMembersCompanion extends UpdateCompanion<FamilyMember> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> avatarColor;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  const FamilyMembersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.avatarColor = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  FamilyMembersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.avatarColor = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<FamilyMember> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? avatarColor,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (avatarColor != null) 'avatar_color': avatarColor,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  FamilyMembersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? avatarColor,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
  }) {
    return FamilyMembersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarColor: avatarColor ?? this.avatarColor,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (avatarColor.present) {
      map['avatar_color'] = Variable<int>(avatarColor.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FamilyMembersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('avatarColor: $avatarColor, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<int> memberId = GeneratedColumn<int>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES family_members (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reminderEnabledMeta = const VerificationMeta(
    'reminderEnabled',
  );
  @override
  late final GeneratedColumn<bool> reminderEnabled = GeneratedColumn<bool>(
    'reminder_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminder_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _reminderIntervalDaysMeta =
      const VerificationMeta('reminderIntervalDays');
  @override
  late final GeneratedColumn<int> reminderIntervalDays = GeneratedColumn<int>(
    'reminder_interval_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(30),
  );
  static const VerificationMeta _lastReminderAtMeta = const VerificationMeta(
    'lastReminderAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastReminderAt =
      GeneratedColumn<DateTime>(
        'last_reminder_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    memberId,
    name,
    category,
    currency,
    reminderEnabled,
    reminderIntervalDays,
    lastReminderAt,
    isArchived,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Account> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('reminder_enabled')) {
      context.handle(
        _reminderEnabledMeta,
        reminderEnabled.isAcceptableOrUnknown(
          data['reminder_enabled']!,
          _reminderEnabledMeta,
        ),
      );
    }
    if (data.containsKey('reminder_interval_days')) {
      context.handle(
        _reminderIntervalDaysMeta,
        reminderIntervalDays.isAcceptableOrUnknown(
          data['reminder_interval_days']!,
          _reminderIntervalDaysMeta,
        ),
      );
    }
    if (data.containsKey('last_reminder_at')) {
      context.handle(
        _lastReminderAtMeta,
        lastReminderAt.isAcceptableOrUnknown(
          data['last_reminder_at']!,
          _lastReminderAtMeta,
        ),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}member_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      reminderEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminder_enabled'],
      )!,
      reminderIntervalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_interval_days'],
      )!,
      lastReminderAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_reminder_at'],
      ),
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class Account extends DataClass implements Insertable<Account> {
  final int id;
  final int memberId;
  final String name;
  final String category;
  final String currency;
  final bool reminderEnabled;
  final int reminderIntervalDays;
  final DateTime? lastReminderAt;
  final bool isArchived;
  final DateTime createdAt;
  const Account({
    required this.id,
    required this.memberId,
    required this.name,
    required this.category,
    required this.currency,
    required this.reminderEnabled,
    required this.reminderIntervalDays,
    this.lastReminderAt,
    required this.isArchived,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['member_id'] = Variable<int>(memberId);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['currency'] = Variable<String>(currency);
    map['reminder_enabled'] = Variable<bool>(reminderEnabled);
    map['reminder_interval_days'] = Variable<int>(reminderIntervalDays);
    if (!nullToAbsent || lastReminderAt != null) {
      map['last_reminder_at'] = Variable<DateTime>(lastReminderAt);
    }
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      memberId: Value(memberId),
      name: Value(name),
      category: Value(category),
      currency: Value(currency),
      reminderEnabled: Value(reminderEnabled),
      reminderIntervalDays: Value(reminderIntervalDays),
      lastReminderAt: lastReminderAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReminderAt),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
    );
  }

  factory Account.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<int>(json['id']),
      memberId: serializer.fromJson<int>(json['memberId']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      currency: serializer.fromJson<String>(json['currency']),
      reminderEnabled: serializer.fromJson<bool>(json['reminderEnabled']),
      reminderIntervalDays: serializer.fromJson<int>(
        json['reminderIntervalDays'],
      ),
      lastReminderAt: serializer.fromJson<DateTime?>(json['lastReminderAt']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'memberId': serializer.toJson<int>(memberId),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'currency': serializer.toJson<String>(currency),
      'reminderEnabled': serializer.toJson<bool>(reminderEnabled),
      'reminderIntervalDays': serializer.toJson<int>(reminderIntervalDays),
      'lastReminderAt': serializer.toJson<DateTime?>(lastReminderAt),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Account copyWith({
    int? id,
    int? memberId,
    String? name,
    String? category,
    String? currency,
    bool? reminderEnabled,
    int? reminderIntervalDays,
    Value<DateTime?> lastReminderAt = const Value.absent(),
    bool? isArchived,
    DateTime? createdAt,
  }) => Account(
    id: id ?? this.id,
    memberId: memberId ?? this.memberId,
    name: name ?? this.name,
    category: category ?? this.category,
    currency: currency ?? this.currency,
    reminderEnabled: reminderEnabled ?? this.reminderEnabled,
    reminderIntervalDays: reminderIntervalDays ?? this.reminderIntervalDays,
    lastReminderAt: lastReminderAt.present
        ? lastReminderAt.value
        : this.lastReminderAt,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
  );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      currency: data.currency.present ? data.currency.value : this.currency,
      reminderEnabled: data.reminderEnabled.present
          ? data.reminderEnabled.value
          : this.reminderEnabled,
      reminderIntervalDays: data.reminderIntervalDays.present
          ? data.reminderIntervalDays.value
          : this.reminderIntervalDays,
      lastReminderAt: data.lastReminderAt.present
          ? data.lastReminderAt.value
          : this.lastReminderAt,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('memberId: $memberId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('currency: $currency, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderIntervalDays: $reminderIntervalDays, ')
          ..write('lastReminderAt: $lastReminderAt, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    memberId,
    name,
    category,
    currency,
    reminderEnabled,
    reminderIntervalDays,
    lastReminderAt,
    isArchived,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.memberId == this.memberId &&
          other.name == this.name &&
          other.category == this.category &&
          other.currency == this.currency &&
          other.reminderEnabled == this.reminderEnabled &&
          other.reminderIntervalDays == this.reminderIntervalDays &&
          other.lastReminderAt == this.lastReminderAt &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<int> id;
  final Value<int> memberId;
  final Value<String> name;
  final Value<String> category;
  final Value<String> currency;
  final Value<bool> reminderEnabled;
  final Value<int> reminderIntervalDays;
  final Value<DateTime?> lastReminderAt;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.memberId = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.currency = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderIntervalDays = const Value.absent(),
    this.lastReminderAt = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AccountsCompanion.insert({
    this.id = const Value.absent(),
    required int memberId,
    required String name,
    required String category,
    required String currency,
    this.reminderEnabled = const Value.absent(),
    this.reminderIntervalDays = const Value.absent(),
    this.lastReminderAt = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : memberId = Value(memberId),
       name = Value(name),
       category = Value(category),
       currency = Value(currency);
  static Insertable<Account> custom({
    Expression<int>? id,
    Expression<int>? memberId,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? currency,
    Expression<bool>? reminderEnabled,
    Expression<int>? reminderIntervalDays,
    Expression<DateTime>? lastReminderAt,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (memberId != null) 'member_id': memberId,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (currency != null) 'currency': currency,
      if (reminderEnabled != null) 'reminder_enabled': reminderEnabled,
      if (reminderIntervalDays != null)
        'reminder_interval_days': reminderIntervalDays,
      if (lastReminderAt != null) 'last_reminder_at': lastReminderAt,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AccountsCompanion copyWith({
    Value<int>? id,
    Value<int>? memberId,
    Value<String>? name,
    Value<String>? category,
    Value<String>? currency,
    Value<bool>? reminderEnabled,
    Value<int>? reminderIntervalDays,
    Value<DateTime?>? lastReminderAt,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      memberId: memberId ?? this.memberId,
      name: name ?? this.name,
      category: category ?? this.category,
      currency: currency ?? this.currency,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderIntervalDays: reminderIntervalDays ?? this.reminderIntervalDays,
      lastReminderAt: lastReminderAt ?? this.lastReminderAt,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<int>(memberId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (reminderEnabled.present) {
      map['reminder_enabled'] = Variable<bool>(reminderEnabled.value);
    }
    if (reminderIntervalDays.present) {
      map['reminder_interval_days'] = Variable<int>(reminderIntervalDays.value);
    }
    if (lastReminderAt.present) {
      map['last_reminder_at'] = Variable<DateTime>(lastReminderAt.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('memberId: $memberId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('currency: $currency, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderIntervalDays: $reminderIntervalDays, ')
          ..write('lastReminderAt: $lastReminderAt, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FxSnapshotsTable extends FxSnapshots
    with TableInfo<$FxSnapshotsTable, FxSnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FxSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _sourceNoteMeta = const VerificationMeta(
    'sourceNote',
  );
  @override
  late final GeneratedColumn<String> sourceNote = GeneratedColumn<String>(
    'source_note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [id, recordedAt, sourceNote];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fx_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<FxSnapshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    }
    if (data.containsKey('source_note')) {
      context.handle(
        _sourceNoteMeta,
        sourceNote.isAcceptableOrUnknown(data['source_note']!, _sourceNoteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FxSnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FxSnapshot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
      sourceNote: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_note'],
      )!,
    );
  }

  @override
  $FxSnapshotsTable createAlias(String alias) {
    return $FxSnapshotsTable(attachedDatabase, alias);
  }
}

class FxSnapshot extends DataClass implements Insertable<FxSnapshot> {
  final int id;
  final DateTime recordedAt;
  final String sourceNote;
  const FxSnapshot({
    required this.id,
    required this.recordedAt,
    required this.sourceNote,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['source_note'] = Variable<String>(sourceNote);
    return map;
  }

  FxSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return FxSnapshotsCompanion(
      id: Value(id),
      recordedAt: Value(recordedAt),
      sourceNote: Value(sourceNote),
    );
  }

  factory FxSnapshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FxSnapshot(
      id: serializer.fromJson<int>(json['id']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      sourceNote: serializer.fromJson<String>(json['sourceNote']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'sourceNote': serializer.toJson<String>(sourceNote),
    };
  }

  FxSnapshot copyWith({int? id, DateTime? recordedAt, String? sourceNote}) =>
      FxSnapshot(
        id: id ?? this.id,
        recordedAt: recordedAt ?? this.recordedAt,
        sourceNote: sourceNote ?? this.sourceNote,
      );
  FxSnapshot copyWithCompanion(FxSnapshotsCompanion data) {
    return FxSnapshot(
      id: data.id.present ? data.id.value : this.id,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      sourceNote: data.sourceNote.present
          ? data.sourceNote.value
          : this.sourceNote,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FxSnapshot(')
          ..write('id: $id, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('sourceNote: $sourceNote')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recordedAt, sourceNote);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FxSnapshot &&
          other.id == this.id &&
          other.recordedAt == this.recordedAt &&
          other.sourceNote == this.sourceNote);
}

class FxSnapshotsCompanion extends UpdateCompanion<FxSnapshot> {
  final Value<int> id;
  final Value<DateTime> recordedAt;
  final Value<String> sourceNote;
  const FxSnapshotsCompanion({
    this.id = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.sourceNote = const Value.absent(),
  });
  FxSnapshotsCompanion.insert({
    this.id = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.sourceNote = const Value.absent(),
  });
  static Insertable<FxSnapshot> custom({
    Expression<int>? id,
    Expression<DateTime>? recordedAt,
    Expression<String>? sourceNote,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (sourceNote != null) 'source_note': sourceNote,
    });
  }

  FxSnapshotsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? recordedAt,
    Value<String>? sourceNote,
  }) {
    return FxSnapshotsCompanion(
      id: id ?? this.id,
      recordedAt: recordedAt ?? this.recordedAt,
      sourceNote: sourceNote ?? this.sourceNote,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (sourceNote.present) {
      map['source_note'] = Variable<String>(sourceNote.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FxSnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('sourceNote: $sourceNote')
          ..write(')'))
        .toString();
  }
}

class $FxRatesTable extends FxRates with TableInfo<$FxRatesTable, FxRate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FxRatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _fxSnapshotIdMeta = const VerificationMeta(
    'fxSnapshotId',
  );
  @override
  late final GeneratedColumn<int> fxSnapshotId = GeneratedColumn<int>(
    'fx_snapshot_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES fx_snapshots (id)',
    ),
  );
  static const VerificationMeta _fromCurrencyMeta = const VerificationMeta(
    'fromCurrency',
  );
  @override
  late final GeneratedColumn<String> fromCurrency = GeneratedColumn<String>(
    'from_currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _toCurrencyMeta = const VerificationMeta(
    'toCurrency',
  );
  @override
  late final GeneratedColumn<String> toCurrency = GeneratedColumn<String>(
    'to_currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rateMeta = const VerificationMeta('rate');
  @override
  late final GeneratedColumn<double> rate = GeneratedColumn<double>(
    'rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    fxSnapshotId,
    fromCurrency,
    toCurrency,
    rate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'fx_rates';
  @override
  VerificationContext validateIntegrity(
    Insertable<FxRate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('fx_snapshot_id')) {
      context.handle(
        _fxSnapshotIdMeta,
        fxSnapshotId.isAcceptableOrUnknown(
          data['fx_snapshot_id']!,
          _fxSnapshotIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fxSnapshotIdMeta);
    }
    if (data.containsKey('from_currency')) {
      context.handle(
        _fromCurrencyMeta,
        fromCurrency.isAcceptableOrUnknown(
          data['from_currency']!,
          _fromCurrencyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fromCurrencyMeta);
    }
    if (data.containsKey('to_currency')) {
      context.handle(
        _toCurrencyMeta,
        toCurrency.isAcceptableOrUnknown(data['to_currency']!, _toCurrencyMeta),
      );
    } else if (isInserting) {
      context.missing(_toCurrencyMeta);
    }
    if (data.containsKey('rate')) {
      context.handle(
        _rateMeta,
        rate.isAcceptableOrUnknown(data['rate']!, _rateMeta),
      );
    } else if (isInserting) {
      context.missing(_rateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FxRate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FxRate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      fxSnapshotId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fx_snapshot_id'],
      )!,
      fromCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_currency'],
      )!,
      toCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_currency'],
      )!,
      rate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rate'],
      )!,
    );
  }

  @override
  $FxRatesTable createAlias(String alias) {
    return $FxRatesTable(attachedDatabase, alias);
  }
}

class FxRate extends DataClass implements Insertable<FxRate> {
  final int id;
  final int fxSnapshotId;
  final String fromCurrency;
  final String toCurrency;
  final double rate;
  const FxRate({
    required this.id,
    required this.fxSnapshotId,
    required this.fromCurrency,
    required this.toCurrency,
    required this.rate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['fx_snapshot_id'] = Variable<int>(fxSnapshotId);
    map['from_currency'] = Variable<String>(fromCurrency);
    map['to_currency'] = Variable<String>(toCurrency);
    map['rate'] = Variable<double>(rate);
    return map;
  }

  FxRatesCompanion toCompanion(bool nullToAbsent) {
    return FxRatesCompanion(
      id: Value(id),
      fxSnapshotId: Value(fxSnapshotId),
      fromCurrency: Value(fromCurrency),
      toCurrency: Value(toCurrency),
      rate: Value(rate),
    );
  }

  factory FxRate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FxRate(
      id: serializer.fromJson<int>(json['id']),
      fxSnapshotId: serializer.fromJson<int>(json['fxSnapshotId']),
      fromCurrency: serializer.fromJson<String>(json['fromCurrency']),
      toCurrency: serializer.fromJson<String>(json['toCurrency']),
      rate: serializer.fromJson<double>(json['rate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fxSnapshotId': serializer.toJson<int>(fxSnapshotId),
      'fromCurrency': serializer.toJson<String>(fromCurrency),
      'toCurrency': serializer.toJson<String>(toCurrency),
      'rate': serializer.toJson<double>(rate),
    };
  }

  FxRate copyWith({
    int? id,
    int? fxSnapshotId,
    String? fromCurrency,
    String? toCurrency,
    double? rate,
  }) => FxRate(
    id: id ?? this.id,
    fxSnapshotId: fxSnapshotId ?? this.fxSnapshotId,
    fromCurrency: fromCurrency ?? this.fromCurrency,
    toCurrency: toCurrency ?? this.toCurrency,
    rate: rate ?? this.rate,
  );
  FxRate copyWithCompanion(FxRatesCompanion data) {
    return FxRate(
      id: data.id.present ? data.id.value : this.id,
      fxSnapshotId: data.fxSnapshotId.present
          ? data.fxSnapshotId.value
          : this.fxSnapshotId,
      fromCurrency: data.fromCurrency.present
          ? data.fromCurrency.value
          : this.fromCurrency,
      toCurrency: data.toCurrency.present
          ? data.toCurrency.value
          : this.toCurrency,
      rate: data.rate.present ? data.rate.value : this.rate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FxRate(')
          ..write('id: $id, ')
          ..write('fxSnapshotId: $fxSnapshotId, ')
          ..write('fromCurrency: $fromCurrency, ')
          ..write('toCurrency: $toCurrency, ')
          ..write('rate: $rate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, fxSnapshotId, fromCurrency, toCurrency, rate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FxRate &&
          other.id == this.id &&
          other.fxSnapshotId == this.fxSnapshotId &&
          other.fromCurrency == this.fromCurrency &&
          other.toCurrency == this.toCurrency &&
          other.rate == this.rate);
}

class FxRatesCompanion extends UpdateCompanion<FxRate> {
  final Value<int> id;
  final Value<int> fxSnapshotId;
  final Value<String> fromCurrency;
  final Value<String> toCurrency;
  final Value<double> rate;
  const FxRatesCompanion({
    this.id = const Value.absent(),
    this.fxSnapshotId = const Value.absent(),
    this.fromCurrency = const Value.absent(),
    this.toCurrency = const Value.absent(),
    this.rate = const Value.absent(),
  });
  FxRatesCompanion.insert({
    this.id = const Value.absent(),
    required int fxSnapshotId,
    required String fromCurrency,
    required String toCurrency,
    required double rate,
  }) : fxSnapshotId = Value(fxSnapshotId),
       fromCurrency = Value(fromCurrency),
       toCurrency = Value(toCurrency),
       rate = Value(rate);
  static Insertable<FxRate> custom({
    Expression<int>? id,
    Expression<int>? fxSnapshotId,
    Expression<String>? fromCurrency,
    Expression<String>? toCurrency,
    Expression<double>? rate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fxSnapshotId != null) 'fx_snapshot_id': fxSnapshotId,
      if (fromCurrency != null) 'from_currency': fromCurrency,
      if (toCurrency != null) 'to_currency': toCurrency,
      if (rate != null) 'rate': rate,
    });
  }

  FxRatesCompanion copyWith({
    Value<int>? id,
    Value<int>? fxSnapshotId,
    Value<String>? fromCurrency,
    Value<String>? toCurrency,
    Value<double>? rate,
  }) {
    return FxRatesCompanion(
      id: id ?? this.id,
      fxSnapshotId: fxSnapshotId ?? this.fxSnapshotId,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      rate: rate ?? this.rate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fxSnapshotId.present) {
      map['fx_snapshot_id'] = Variable<int>(fxSnapshotId.value);
    }
    if (fromCurrency.present) {
      map['from_currency'] = Variable<String>(fromCurrency.value);
    }
    if (toCurrency.present) {
      map['to_currency'] = Variable<String>(toCurrency.value);
    }
    if (rate.present) {
      map['rate'] = Variable<double>(rate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FxRatesCompanion(')
          ..write('id: $id, ')
          ..write('fxSnapshotId: $fxSnapshotId, ')
          ..write('fromCurrency: $fromCurrency, ')
          ..write('toCurrency: $toCurrency, ')
          ..write('rate: $rate')
          ..write(')'))
        .toString();
  }
}

class $UpdateSessionsTable extends UpdateSessions
    with TableInfo<$UpdateSessionsTable, UpdateSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UpdateSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _fxSnapshotIdMeta = const VerificationMeta(
    'fxSnapshotId',
  );
  @override
  late final GeneratedColumn<int> fxSnapshotId = GeneratedColumn<int>(
    'fx_snapshot_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES fx_snapshots (id)',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [id, recordedAt, fxSnapshotId, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'update_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<UpdateSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    }
    if (data.containsKey('fx_snapshot_id')) {
      context.handle(
        _fxSnapshotIdMeta,
        fxSnapshotId.isAcceptableOrUnknown(
          data['fx_snapshot_id']!,
          _fxSnapshotIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fxSnapshotIdMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UpdateSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UpdateSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
      fxSnapshotId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fx_snapshot_id'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
    );
  }

  @override
  $UpdateSessionsTable createAlias(String alias) {
    return $UpdateSessionsTable(attachedDatabase, alias);
  }
}

class UpdateSession extends DataClass implements Insertable<UpdateSession> {
  final int id;
  final DateTime recordedAt;
  final int fxSnapshotId;
  final String note;
  const UpdateSession({
    required this.id,
    required this.recordedAt,
    required this.fxSnapshotId,
    required this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['fx_snapshot_id'] = Variable<int>(fxSnapshotId);
    map['note'] = Variable<String>(note);
    return map;
  }

  UpdateSessionsCompanion toCompanion(bool nullToAbsent) {
    return UpdateSessionsCompanion(
      id: Value(id),
      recordedAt: Value(recordedAt),
      fxSnapshotId: Value(fxSnapshotId),
      note: Value(note),
    );
  }

  factory UpdateSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UpdateSession(
      id: serializer.fromJson<int>(json['id']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      fxSnapshotId: serializer.fromJson<int>(json['fxSnapshotId']),
      note: serializer.fromJson<String>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'fxSnapshotId': serializer.toJson<int>(fxSnapshotId),
      'note': serializer.toJson<String>(note),
    };
  }

  UpdateSession copyWith({
    int? id,
    DateTime? recordedAt,
    int? fxSnapshotId,
    String? note,
  }) => UpdateSession(
    id: id ?? this.id,
    recordedAt: recordedAt ?? this.recordedAt,
    fxSnapshotId: fxSnapshotId ?? this.fxSnapshotId,
    note: note ?? this.note,
  );
  UpdateSession copyWithCompanion(UpdateSessionsCompanion data) {
    return UpdateSession(
      id: data.id.present ? data.id.value : this.id,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      fxSnapshotId: data.fxSnapshotId.present
          ? data.fxSnapshotId.value
          : this.fxSnapshotId,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UpdateSession(')
          ..write('id: $id, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('fxSnapshotId: $fxSnapshotId, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, recordedAt, fxSnapshotId, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UpdateSession &&
          other.id == this.id &&
          other.recordedAt == this.recordedAt &&
          other.fxSnapshotId == this.fxSnapshotId &&
          other.note == this.note);
}

class UpdateSessionsCompanion extends UpdateCompanion<UpdateSession> {
  final Value<int> id;
  final Value<DateTime> recordedAt;
  final Value<int> fxSnapshotId;
  final Value<String> note;
  const UpdateSessionsCompanion({
    this.id = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.fxSnapshotId = const Value.absent(),
    this.note = const Value.absent(),
  });
  UpdateSessionsCompanion.insert({
    this.id = const Value.absent(),
    this.recordedAt = const Value.absent(),
    required int fxSnapshotId,
    this.note = const Value.absent(),
  }) : fxSnapshotId = Value(fxSnapshotId);
  static Insertable<UpdateSession> custom({
    Expression<int>? id,
    Expression<DateTime>? recordedAt,
    Expression<int>? fxSnapshotId,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (fxSnapshotId != null) 'fx_snapshot_id': fxSnapshotId,
      if (note != null) 'note': note,
    });
  }

  UpdateSessionsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? recordedAt,
    Value<int>? fxSnapshotId,
    Value<String>? note,
  }) {
    return UpdateSessionsCompanion(
      id: id ?? this.id,
      recordedAt: recordedAt ?? this.recordedAt,
      fxSnapshotId: fxSnapshotId ?? this.fxSnapshotId,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (fxSnapshotId.present) {
      map['fx_snapshot_id'] = Variable<int>(fxSnapshotId.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UpdateSessionsCompanion(')
          ..write('id: $id, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('fxSnapshotId: $fxSnapshotId, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $BalanceSnapshotsTable extends BalanceSnapshots
    with TableInfo<$BalanceSnapshotsTable, BalanceSnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BalanceSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<int> accountId = GeneratedColumn<int>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id)',
    ),
  );
  static const VerificationMeta _updateSessionIdMeta = const VerificationMeta(
    'updateSessionId',
  );
  @override
  late final GeneratedColumn<int> updateSessionId = GeneratedColumn<int>(
    'update_session_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES update_sessions (id)',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _changeReasonMeta = const VerificationMeta(
    'changeReason',
  );
  @override
  late final GeneratedColumn<String> changeReason = GeneratedColumn<String>(
    'change_reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _changeReasonTextMeta = const VerificationMeta(
    'changeReasonText',
  );
  @override
  late final GeneratedColumn<String> changeReasonText = GeneratedColumn<String>(
    'change_reason_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _deltaFromPreviousMeta = const VerificationMeta(
    'deltaFromPrevious',
  );
  @override
  late final GeneratedColumn<double> deltaFromPrevious =
      GeneratedColumn<double>(
        'delta_from_previous',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _deltaPercentMeta = const VerificationMeta(
    'deltaPercent',
  );
  @override
  late final GeneratedColumn<double> deltaPercent = GeneratedColumn<double>(
    'delta_percent',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    updateSessionId,
    amount,
    recordedAt,
    note,
    changeReason,
    changeReasonText,
    deltaFromPrevious,
    deltaPercent,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'balance_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<BalanceSnapshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('update_session_id')) {
      context.handle(
        _updateSessionIdMeta,
        updateSessionId.isAcceptableOrUnknown(
          data['update_session_id']!,
          _updateSessionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_updateSessionIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('change_reason')) {
      context.handle(
        _changeReasonMeta,
        changeReason.isAcceptableOrUnknown(
          data['change_reason']!,
          _changeReasonMeta,
        ),
      );
    }
    if (data.containsKey('change_reason_text')) {
      context.handle(
        _changeReasonTextMeta,
        changeReasonText.isAcceptableOrUnknown(
          data['change_reason_text']!,
          _changeReasonTextMeta,
        ),
      );
    }
    if (data.containsKey('delta_from_previous')) {
      context.handle(
        _deltaFromPreviousMeta,
        deltaFromPrevious.isAcceptableOrUnknown(
          data['delta_from_previous']!,
          _deltaFromPreviousMeta,
        ),
      );
    }
    if (data.containsKey('delta_percent')) {
      context.handle(
        _deltaPercentMeta,
        deltaPercent.isAcceptableOrUnknown(
          data['delta_percent']!,
          _deltaPercentMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BalanceSnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BalanceSnapshot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}account_id'],
      )!,
      updateSessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}update_session_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      changeReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}change_reason'],
      ),
      changeReasonText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}change_reason_text'],
      )!,
      deltaFromPrevious: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}delta_from_previous'],
      ),
      deltaPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}delta_percent'],
      ),
    );
  }

  @override
  $BalanceSnapshotsTable createAlias(String alias) {
    return $BalanceSnapshotsTable(attachedDatabase, alias);
  }
}

class BalanceSnapshot extends DataClass implements Insertable<BalanceSnapshot> {
  final int id;
  final int accountId;
  final int updateSessionId;
  final double amount;
  final DateTime recordedAt;
  final String note;
  final String? changeReason;
  final String changeReasonText;
  final double? deltaFromPrevious;
  final double? deltaPercent;
  const BalanceSnapshot({
    required this.id,
    required this.accountId,
    required this.updateSessionId,
    required this.amount,
    required this.recordedAt,
    required this.note,
    this.changeReason,
    required this.changeReasonText,
    this.deltaFromPrevious,
    this.deltaPercent,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['account_id'] = Variable<int>(accountId);
    map['update_session_id'] = Variable<int>(updateSessionId);
    map['amount'] = Variable<double>(amount);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    map['note'] = Variable<String>(note);
    if (!nullToAbsent || changeReason != null) {
      map['change_reason'] = Variable<String>(changeReason);
    }
    map['change_reason_text'] = Variable<String>(changeReasonText);
    if (!nullToAbsent || deltaFromPrevious != null) {
      map['delta_from_previous'] = Variable<double>(deltaFromPrevious);
    }
    if (!nullToAbsent || deltaPercent != null) {
      map['delta_percent'] = Variable<double>(deltaPercent);
    }
    return map;
  }

  BalanceSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return BalanceSnapshotsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      updateSessionId: Value(updateSessionId),
      amount: Value(amount),
      recordedAt: Value(recordedAt),
      note: Value(note),
      changeReason: changeReason == null && nullToAbsent
          ? const Value.absent()
          : Value(changeReason),
      changeReasonText: Value(changeReasonText),
      deltaFromPrevious: deltaFromPrevious == null && nullToAbsent
          ? const Value.absent()
          : Value(deltaFromPrevious),
      deltaPercent: deltaPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(deltaPercent),
    );
  }

  factory BalanceSnapshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BalanceSnapshot(
      id: serializer.fromJson<int>(json['id']),
      accountId: serializer.fromJson<int>(json['accountId']),
      updateSessionId: serializer.fromJson<int>(json['updateSessionId']),
      amount: serializer.fromJson<double>(json['amount']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      note: serializer.fromJson<String>(json['note']),
      changeReason: serializer.fromJson<String?>(json['changeReason']),
      changeReasonText: serializer.fromJson<String>(json['changeReasonText']),
      deltaFromPrevious: serializer.fromJson<double?>(
        json['deltaFromPrevious'],
      ),
      deltaPercent: serializer.fromJson<double?>(json['deltaPercent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'accountId': serializer.toJson<int>(accountId),
      'updateSessionId': serializer.toJson<int>(updateSessionId),
      'amount': serializer.toJson<double>(amount),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'note': serializer.toJson<String>(note),
      'changeReason': serializer.toJson<String?>(changeReason),
      'changeReasonText': serializer.toJson<String>(changeReasonText),
      'deltaFromPrevious': serializer.toJson<double?>(deltaFromPrevious),
      'deltaPercent': serializer.toJson<double?>(deltaPercent),
    };
  }

  BalanceSnapshot copyWith({
    int? id,
    int? accountId,
    int? updateSessionId,
    double? amount,
    DateTime? recordedAt,
    String? note,
    Value<String?> changeReason = const Value.absent(),
    String? changeReasonText,
    Value<double?> deltaFromPrevious = const Value.absent(),
    Value<double?> deltaPercent = const Value.absent(),
  }) => BalanceSnapshot(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    updateSessionId: updateSessionId ?? this.updateSessionId,
    amount: amount ?? this.amount,
    recordedAt: recordedAt ?? this.recordedAt,
    note: note ?? this.note,
    changeReason: changeReason.present ? changeReason.value : this.changeReason,
    changeReasonText: changeReasonText ?? this.changeReasonText,
    deltaFromPrevious: deltaFromPrevious.present
        ? deltaFromPrevious.value
        : this.deltaFromPrevious,
    deltaPercent: deltaPercent.present ? deltaPercent.value : this.deltaPercent,
  );
  BalanceSnapshot copyWithCompanion(BalanceSnapshotsCompanion data) {
    return BalanceSnapshot(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      updateSessionId: data.updateSessionId.present
          ? data.updateSessionId.value
          : this.updateSessionId,
      amount: data.amount.present ? data.amount.value : this.amount,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      note: data.note.present ? data.note.value : this.note,
      changeReason: data.changeReason.present
          ? data.changeReason.value
          : this.changeReason,
      changeReasonText: data.changeReasonText.present
          ? data.changeReasonText.value
          : this.changeReasonText,
      deltaFromPrevious: data.deltaFromPrevious.present
          ? data.deltaFromPrevious.value
          : this.deltaFromPrevious,
      deltaPercent: data.deltaPercent.present
          ? data.deltaPercent.value
          : this.deltaPercent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BalanceSnapshot(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('updateSessionId: $updateSessionId, ')
          ..write('amount: $amount, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('note: $note, ')
          ..write('changeReason: $changeReason, ')
          ..write('changeReasonText: $changeReasonText, ')
          ..write('deltaFromPrevious: $deltaFromPrevious, ')
          ..write('deltaPercent: $deltaPercent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    updateSessionId,
    amount,
    recordedAt,
    note,
    changeReason,
    changeReasonText,
    deltaFromPrevious,
    deltaPercent,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BalanceSnapshot &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.updateSessionId == this.updateSessionId &&
          other.amount == this.amount &&
          other.recordedAt == this.recordedAt &&
          other.note == this.note &&
          other.changeReason == this.changeReason &&
          other.changeReasonText == this.changeReasonText &&
          other.deltaFromPrevious == this.deltaFromPrevious &&
          other.deltaPercent == this.deltaPercent);
}

class BalanceSnapshotsCompanion extends UpdateCompanion<BalanceSnapshot> {
  final Value<int> id;
  final Value<int> accountId;
  final Value<int> updateSessionId;
  final Value<double> amount;
  final Value<DateTime> recordedAt;
  final Value<String> note;
  final Value<String?> changeReason;
  final Value<String> changeReasonText;
  final Value<double?> deltaFromPrevious;
  final Value<double?> deltaPercent;
  const BalanceSnapshotsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.updateSessionId = const Value.absent(),
    this.amount = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.note = const Value.absent(),
    this.changeReason = const Value.absent(),
    this.changeReasonText = const Value.absent(),
    this.deltaFromPrevious = const Value.absent(),
    this.deltaPercent = const Value.absent(),
  });
  BalanceSnapshotsCompanion.insert({
    this.id = const Value.absent(),
    required int accountId,
    required int updateSessionId,
    required double amount,
    this.recordedAt = const Value.absent(),
    this.note = const Value.absent(),
    this.changeReason = const Value.absent(),
    this.changeReasonText = const Value.absent(),
    this.deltaFromPrevious = const Value.absent(),
    this.deltaPercent = const Value.absent(),
  }) : accountId = Value(accountId),
       updateSessionId = Value(updateSessionId),
       amount = Value(amount);
  static Insertable<BalanceSnapshot> custom({
    Expression<int>? id,
    Expression<int>? accountId,
    Expression<int>? updateSessionId,
    Expression<double>? amount,
    Expression<DateTime>? recordedAt,
    Expression<String>? note,
    Expression<String>? changeReason,
    Expression<String>? changeReasonText,
    Expression<double>? deltaFromPrevious,
    Expression<double>? deltaPercent,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (updateSessionId != null) 'update_session_id': updateSessionId,
      if (amount != null) 'amount': amount,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (note != null) 'note': note,
      if (changeReason != null) 'change_reason': changeReason,
      if (changeReasonText != null) 'change_reason_text': changeReasonText,
      if (deltaFromPrevious != null) 'delta_from_previous': deltaFromPrevious,
      if (deltaPercent != null) 'delta_percent': deltaPercent,
    });
  }

  BalanceSnapshotsCompanion copyWith({
    Value<int>? id,
    Value<int>? accountId,
    Value<int>? updateSessionId,
    Value<double>? amount,
    Value<DateTime>? recordedAt,
    Value<String>? note,
    Value<String?>? changeReason,
    Value<String>? changeReasonText,
    Value<double?>? deltaFromPrevious,
    Value<double?>? deltaPercent,
  }) {
    return BalanceSnapshotsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      updateSessionId: updateSessionId ?? this.updateSessionId,
      amount: amount ?? this.amount,
      recordedAt: recordedAt ?? this.recordedAt,
      note: note ?? this.note,
      changeReason: changeReason ?? this.changeReason,
      changeReasonText: changeReasonText ?? this.changeReasonText,
      deltaFromPrevious: deltaFromPrevious ?? this.deltaFromPrevious,
      deltaPercent: deltaPercent ?? this.deltaPercent,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<int>(accountId.value);
    }
    if (updateSessionId.present) {
      map['update_session_id'] = Variable<int>(updateSessionId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (changeReason.present) {
      map['change_reason'] = Variable<String>(changeReason.value);
    }
    if (changeReasonText.present) {
      map['change_reason_text'] = Variable<String>(changeReasonText.value);
    }
    if (deltaFromPrevious.present) {
      map['delta_from_previous'] = Variable<double>(deltaFromPrevious.value);
    }
    if (deltaPercent.present) {
      map['delta_percent'] = Variable<double>(deltaPercent.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BalanceSnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('updateSessionId: $updateSessionId, ')
          ..write('amount: $amount, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('note: $note, ')
          ..write('changeReason: $changeReason, ')
          ..write('changeReasonText: $changeReasonText, ')
          ..write('deltaFromPrevious: $deltaFromPrevious, ')
          ..write('deltaPercent: $deltaPercent')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _displayCurrencyMeta = const VerificationMeta(
    'displayCurrency',
  );
  @override
  late final GeneratedColumn<String> displayCurrency = GeneratedColumn<String>(
    'display_currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('cny'),
  );
  static const VerificationMeta _largeChangeThresholdPercentMeta =
      const VerificationMeta('largeChangeThresholdPercent');
  @override
  late final GeneratedColumn<double> largeChangeThresholdPercent =
      GeneratedColumn<double>(
        'large_change_threshold_percent',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(10),
      );
  static const VerificationMeta _largeChangeThresholdAmountMeta =
      const VerificationMeta('largeChangeThresholdAmount');
  @override
  late final GeneratedColumn<double> largeChangeThresholdAmount =
      GeneratedColumn<double>(
        'large_change_threshold_amount',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(5000),
      );
  static const VerificationMeta _s3EndpointMeta = const VerificationMeta(
    's3Endpoint',
  );
  @override
  late final GeneratedColumn<String> s3Endpoint = GeneratedColumn<String>(
    's3_endpoint',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _s3BucketMeta = const VerificationMeta(
    's3Bucket',
  );
  @override
  late final GeneratedColumn<String> s3Bucket = GeneratedColumn<String>(
    's3_bucket',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _s3AccessKeyMeta = const VerificationMeta(
    's3AccessKey',
  );
  @override
  late final GeneratedColumn<String> s3AccessKey = GeneratedColumn<String>(
    's3_access_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _s3PrefixMeta = const VerificationMeta(
    's3Prefix',
  );
  @override
  late final GeneratedColumn<String> s3Prefix = GeneratedColumn<String>(
    's3_prefix',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _localeLanguageCodeMeta =
      const VerificationMeta('localeLanguageCode');
  @override
  late final GeneratedColumn<String> localeLanguageCode =
      GeneratedColumn<String>(
        'locale_language_code',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('en'),
      );
  static const VerificationMeta _biometricLockEnabledMeta =
      const VerificationMeta('biometricLockEnabled');
  @override
  late final GeneratedColumn<bool> biometricLockEnabled = GeneratedColumn<bool>(
    'biometric_lock_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("biometric_lock_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    displayCurrency,
    largeChangeThresholdPercent,
    largeChangeThresholdAmount,
    s3Endpoint,
    s3Bucket,
    s3AccessKey,
    s3Prefix,
    localeLanguageCode,
    biometricLockEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('display_currency')) {
      context.handle(
        _displayCurrencyMeta,
        displayCurrency.isAcceptableOrUnknown(
          data['display_currency']!,
          _displayCurrencyMeta,
        ),
      );
    }
    if (data.containsKey('large_change_threshold_percent')) {
      context.handle(
        _largeChangeThresholdPercentMeta,
        largeChangeThresholdPercent.isAcceptableOrUnknown(
          data['large_change_threshold_percent']!,
          _largeChangeThresholdPercentMeta,
        ),
      );
    }
    if (data.containsKey('large_change_threshold_amount')) {
      context.handle(
        _largeChangeThresholdAmountMeta,
        largeChangeThresholdAmount.isAcceptableOrUnknown(
          data['large_change_threshold_amount']!,
          _largeChangeThresholdAmountMeta,
        ),
      );
    }
    if (data.containsKey('s3_endpoint')) {
      context.handle(
        _s3EndpointMeta,
        s3Endpoint.isAcceptableOrUnknown(data['s3_endpoint']!, _s3EndpointMeta),
      );
    }
    if (data.containsKey('s3_bucket')) {
      context.handle(
        _s3BucketMeta,
        s3Bucket.isAcceptableOrUnknown(data['s3_bucket']!, _s3BucketMeta),
      );
    }
    if (data.containsKey('s3_access_key')) {
      context.handle(
        _s3AccessKeyMeta,
        s3AccessKey.isAcceptableOrUnknown(
          data['s3_access_key']!,
          _s3AccessKeyMeta,
        ),
      );
    }
    if (data.containsKey('s3_prefix')) {
      context.handle(
        _s3PrefixMeta,
        s3Prefix.isAcceptableOrUnknown(data['s3_prefix']!, _s3PrefixMeta),
      );
    }
    if (data.containsKey('locale_language_code')) {
      context.handle(
        _localeLanguageCodeMeta,
        localeLanguageCode.isAcceptableOrUnknown(
          data['locale_language_code']!,
          _localeLanguageCodeMeta,
        ),
      );
    }
    if (data.containsKey('biometric_lock_enabled')) {
      context.handle(
        _biometricLockEnabledMeta,
        biometricLockEnabled.isAcceptableOrUnknown(
          data['biometric_lock_enabled']!,
          _biometricLockEnabledMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      displayCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_currency'],
      )!,
      largeChangeThresholdPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}large_change_threshold_percent'],
      )!,
      largeChangeThresholdAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}large_change_threshold_amount'],
      )!,
      s3Endpoint: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}s3_endpoint'],
      )!,
      s3Bucket: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}s3_bucket'],
      )!,
      s3AccessKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}s3_access_key'],
      )!,
      s3Prefix: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}s3_prefix'],
      )!,
      localeLanguageCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale_language_code'],
      )!,
      biometricLockEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}biometric_lock_enabled'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final int id;
  final String displayCurrency;
  final double largeChangeThresholdPercent;
  final double largeChangeThresholdAmount;
  final String s3Endpoint;
  final String s3Bucket;
  final String s3AccessKey;
  final String s3Prefix;
  final String localeLanguageCode;
  final bool biometricLockEnabled;
  const AppSetting({
    required this.id,
    required this.displayCurrency,
    required this.largeChangeThresholdPercent,
    required this.largeChangeThresholdAmount,
    required this.s3Endpoint,
    required this.s3Bucket,
    required this.s3AccessKey,
    required this.s3Prefix,
    required this.localeLanguageCode,
    required this.biometricLockEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['display_currency'] = Variable<String>(displayCurrency);
    map['large_change_threshold_percent'] = Variable<double>(
      largeChangeThresholdPercent,
    );
    map['large_change_threshold_amount'] = Variable<double>(
      largeChangeThresholdAmount,
    );
    map['s3_endpoint'] = Variable<String>(s3Endpoint);
    map['s3_bucket'] = Variable<String>(s3Bucket);
    map['s3_access_key'] = Variable<String>(s3AccessKey);
    map['s3_prefix'] = Variable<String>(s3Prefix);
    map['locale_language_code'] = Variable<String>(localeLanguageCode);
    map['biometric_lock_enabled'] = Variable<bool>(biometricLockEnabled);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      id: Value(id),
      displayCurrency: Value(displayCurrency),
      largeChangeThresholdPercent: Value(largeChangeThresholdPercent),
      largeChangeThresholdAmount: Value(largeChangeThresholdAmount),
      s3Endpoint: Value(s3Endpoint),
      s3Bucket: Value(s3Bucket),
      s3AccessKey: Value(s3AccessKey),
      s3Prefix: Value(s3Prefix),
      localeLanguageCode: Value(localeLanguageCode),
      biometricLockEnabled: Value(biometricLockEnabled),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      id: serializer.fromJson<int>(json['id']),
      displayCurrency: serializer.fromJson<String>(json['displayCurrency']),
      largeChangeThresholdPercent: serializer.fromJson<double>(
        json['largeChangeThresholdPercent'],
      ),
      largeChangeThresholdAmount: serializer.fromJson<double>(
        json['largeChangeThresholdAmount'],
      ),
      s3Endpoint: serializer.fromJson<String>(json['s3Endpoint']),
      s3Bucket: serializer.fromJson<String>(json['s3Bucket']),
      s3AccessKey: serializer.fromJson<String>(json['s3AccessKey']),
      s3Prefix: serializer.fromJson<String>(json['s3Prefix']),
      localeLanguageCode: serializer.fromJson<String>(
        json['localeLanguageCode'],
      ),
      biometricLockEnabled: serializer.fromJson<bool>(
        json['biometricLockEnabled'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'displayCurrency': serializer.toJson<String>(displayCurrency),
      'largeChangeThresholdPercent': serializer.toJson<double>(
        largeChangeThresholdPercent,
      ),
      'largeChangeThresholdAmount': serializer.toJson<double>(
        largeChangeThresholdAmount,
      ),
      's3Endpoint': serializer.toJson<String>(s3Endpoint),
      's3Bucket': serializer.toJson<String>(s3Bucket),
      's3AccessKey': serializer.toJson<String>(s3AccessKey),
      's3Prefix': serializer.toJson<String>(s3Prefix),
      'localeLanguageCode': serializer.toJson<String>(localeLanguageCode),
      'biometricLockEnabled': serializer.toJson<bool>(biometricLockEnabled),
    };
  }

  AppSetting copyWith({
    int? id,
    String? displayCurrency,
    double? largeChangeThresholdPercent,
    double? largeChangeThresholdAmount,
    String? s3Endpoint,
    String? s3Bucket,
    String? s3AccessKey,
    String? s3Prefix,
    String? localeLanguageCode,
    bool? biometricLockEnabled,
  }) => AppSetting(
    id: id ?? this.id,
    displayCurrency: displayCurrency ?? this.displayCurrency,
    largeChangeThresholdPercent:
        largeChangeThresholdPercent ?? this.largeChangeThresholdPercent,
    largeChangeThresholdAmount:
        largeChangeThresholdAmount ?? this.largeChangeThresholdAmount,
    s3Endpoint: s3Endpoint ?? this.s3Endpoint,
    s3Bucket: s3Bucket ?? this.s3Bucket,
    s3AccessKey: s3AccessKey ?? this.s3AccessKey,
    s3Prefix: s3Prefix ?? this.s3Prefix,
    localeLanguageCode: localeLanguageCode ?? this.localeLanguageCode,
    biometricLockEnabled: biometricLockEnabled ?? this.biometricLockEnabled,
  );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      id: data.id.present ? data.id.value : this.id,
      displayCurrency: data.displayCurrency.present
          ? data.displayCurrency.value
          : this.displayCurrency,
      largeChangeThresholdPercent: data.largeChangeThresholdPercent.present
          ? data.largeChangeThresholdPercent.value
          : this.largeChangeThresholdPercent,
      largeChangeThresholdAmount: data.largeChangeThresholdAmount.present
          ? data.largeChangeThresholdAmount.value
          : this.largeChangeThresholdAmount,
      s3Endpoint: data.s3Endpoint.present
          ? data.s3Endpoint.value
          : this.s3Endpoint,
      s3Bucket: data.s3Bucket.present ? data.s3Bucket.value : this.s3Bucket,
      s3AccessKey: data.s3AccessKey.present
          ? data.s3AccessKey.value
          : this.s3AccessKey,
      s3Prefix: data.s3Prefix.present ? data.s3Prefix.value : this.s3Prefix,
      localeLanguageCode: data.localeLanguageCode.present
          ? data.localeLanguageCode.value
          : this.localeLanguageCode,
      biometricLockEnabled: data.biometricLockEnabled.present
          ? data.biometricLockEnabled.value
          : this.biometricLockEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('id: $id, ')
          ..write('displayCurrency: $displayCurrency, ')
          ..write('largeChangeThresholdPercent: $largeChangeThresholdPercent, ')
          ..write('largeChangeThresholdAmount: $largeChangeThresholdAmount, ')
          ..write('s3Endpoint: $s3Endpoint, ')
          ..write('s3Bucket: $s3Bucket, ')
          ..write('s3AccessKey: $s3AccessKey, ')
          ..write('s3Prefix: $s3Prefix, ')
          ..write('localeLanguageCode: $localeLanguageCode, ')
          ..write('biometricLockEnabled: $biometricLockEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    displayCurrency,
    largeChangeThresholdPercent,
    largeChangeThresholdAmount,
    s3Endpoint,
    s3Bucket,
    s3AccessKey,
    s3Prefix,
    localeLanguageCode,
    biometricLockEnabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.id == this.id &&
          other.displayCurrency == this.displayCurrency &&
          other.largeChangeThresholdPercent ==
              this.largeChangeThresholdPercent &&
          other.largeChangeThresholdAmount == this.largeChangeThresholdAmount &&
          other.s3Endpoint == this.s3Endpoint &&
          other.s3Bucket == this.s3Bucket &&
          other.s3AccessKey == this.s3AccessKey &&
          other.s3Prefix == this.s3Prefix &&
          other.localeLanguageCode == this.localeLanguageCode &&
          other.biometricLockEnabled == this.biometricLockEnabled);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<int> id;
  final Value<String> displayCurrency;
  final Value<double> largeChangeThresholdPercent;
  final Value<double> largeChangeThresholdAmount;
  final Value<String> s3Endpoint;
  final Value<String> s3Bucket;
  final Value<String> s3AccessKey;
  final Value<String> s3Prefix;
  final Value<String> localeLanguageCode;
  final Value<bool> biometricLockEnabled;
  const AppSettingsCompanion({
    this.id = const Value.absent(),
    this.displayCurrency = const Value.absent(),
    this.largeChangeThresholdPercent = const Value.absent(),
    this.largeChangeThresholdAmount = const Value.absent(),
    this.s3Endpoint = const Value.absent(),
    this.s3Bucket = const Value.absent(),
    this.s3AccessKey = const Value.absent(),
    this.s3Prefix = const Value.absent(),
    this.localeLanguageCode = const Value.absent(),
    this.biometricLockEnabled = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.displayCurrency = const Value.absent(),
    this.largeChangeThresholdPercent = const Value.absent(),
    this.largeChangeThresholdAmount = const Value.absent(),
    this.s3Endpoint = const Value.absent(),
    this.s3Bucket = const Value.absent(),
    this.s3AccessKey = const Value.absent(),
    this.s3Prefix = const Value.absent(),
    this.localeLanguageCode = const Value.absent(),
    this.biometricLockEnabled = const Value.absent(),
  });
  static Insertable<AppSetting> custom({
    Expression<int>? id,
    Expression<String>? displayCurrency,
    Expression<double>? largeChangeThresholdPercent,
    Expression<double>? largeChangeThresholdAmount,
    Expression<String>? s3Endpoint,
    Expression<String>? s3Bucket,
    Expression<String>? s3AccessKey,
    Expression<String>? s3Prefix,
    Expression<String>? localeLanguageCode,
    Expression<bool>? biometricLockEnabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayCurrency != null) 'display_currency': displayCurrency,
      if (largeChangeThresholdPercent != null)
        'large_change_threshold_percent': largeChangeThresholdPercent,
      if (largeChangeThresholdAmount != null)
        'large_change_threshold_amount': largeChangeThresholdAmount,
      if (s3Endpoint != null) 's3_endpoint': s3Endpoint,
      if (s3Bucket != null) 's3_bucket': s3Bucket,
      if (s3AccessKey != null) 's3_access_key': s3AccessKey,
      if (s3Prefix != null) 's3_prefix': s3Prefix,
      if (localeLanguageCode != null)
        'locale_language_code': localeLanguageCode,
      if (biometricLockEnabled != null)
        'biometric_lock_enabled': biometricLockEnabled,
    });
  }

  AppSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? displayCurrency,
    Value<double>? largeChangeThresholdPercent,
    Value<double>? largeChangeThresholdAmount,
    Value<String>? s3Endpoint,
    Value<String>? s3Bucket,
    Value<String>? s3AccessKey,
    Value<String>? s3Prefix,
    Value<String>? localeLanguageCode,
    Value<bool>? biometricLockEnabled,
  }) {
    return AppSettingsCompanion(
      id: id ?? this.id,
      displayCurrency: displayCurrency ?? this.displayCurrency,
      largeChangeThresholdPercent:
          largeChangeThresholdPercent ?? this.largeChangeThresholdPercent,
      largeChangeThresholdAmount:
          largeChangeThresholdAmount ?? this.largeChangeThresholdAmount,
      s3Endpoint: s3Endpoint ?? this.s3Endpoint,
      s3Bucket: s3Bucket ?? this.s3Bucket,
      s3AccessKey: s3AccessKey ?? this.s3AccessKey,
      s3Prefix: s3Prefix ?? this.s3Prefix,
      localeLanguageCode: localeLanguageCode ?? this.localeLanguageCode,
      biometricLockEnabled: biometricLockEnabled ?? this.biometricLockEnabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (displayCurrency.present) {
      map['display_currency'] = Variable<String>(displayCurrency.value);
    }
    if (largeChangeThresholdPercent.present) {
      map['large_change_threshold_percent'] = Variable<double>(
        largeChangeThresholdPercent.value,
      );
    }
    if (largeChangeThresholdAmount.present) {
      map['large_change_threshold_amount'] = Variable<double>(
        largeChangeThresholdAmount.value,
      );
    }
    if (s3Endpoint.present) {
      map['s3_endpoint'] = Variable<String>(s3Endpoint.value);
    }
    if (s3Bucket.present) {
      map['s3_bucket'] = Variable<String>(s3Bucket.value);
    }
    if (s3AccessKey.present) {
      map['s3_access_key'] = Variable<String>(s3AccessKey.value);
    }
    if (s3Prefix.present) {
      map['s3_prefix'] = Variable<String>(s3Prefix.value);
    }
    if (localeLanguageCode.present) {
      map['locale_language_code'] = Variable<String>(localeLanguageCode.value);
    }
    if (biometricLockEnabled.present) {
      map['biometric_lock_enabled'] = Variable<bool>(
        biometricLockEnabled.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('id: $id, ')
          ..write('displayCurrency: $displayCurrency, ')
          ..write('largeChangeThresholdPercent: $largeChangeThresholdPercent, ')
          ..write('largeChangeThresholdAmount: $largeChangeThresholdAmount, ')
          ..write('s3Endpoint: $s3Endpoint, ')
          ..write('s3Bucket: $s3Bucket, ')
          ..write('s3AccessKey: $s3AccessKey, ')
          ..write('s3Prefix: $s3Prefix, ')
          ..write('localeLanguageCode: $localeLanguageCode, ')
          ..write('biometricLockEnabled: $biometricLockEnabled')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FamilyMembersTable familyMembers = $FamilyMembersTable(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $FxSnapshotsTable fxSnapshots = $FxSnapshotsTable(this);
  late final $FxRatesTable fxRates = $FxRatesTable(this);
  late final $UpdateSessionsTable updateSessions = $UpdateSessionsTable(this);
  late final $BalanceSnapshotsTable balanceSnapshots = $BalanceSnapshotsTable(
    this,
  );
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    familyMembers,
    accounts,
    fxSnapshots,
    fxRates,
    updateSessions,
    balanceSnapshots,
    appSettings,
  ];
}

typedef $$FamilyMembersTableCreateCompanionBuilder =
    FamilyMembersCompanion Function({
      Value<int> id,
      required String name,
      Value<int> avatarColor,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
    });
typedef $$FamilyMembersTableUpdateCompanionBuilder =
    FamilyMembersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> avatarColor,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
    });

final class $$FamilyMembersTableReferences
    extends BaseReferences<_$AppDatabase, $FamilyMembersTable, FamilyMember> {
  $$FamilyMembersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$AccountsTable, List<Account>> _accountsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.accounts,
    aliasName: 'family_members__id__accounts__member_id',
  );

  $$AccountsTableProcessedTableManager get accountsRefs {
    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.memberId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_accountsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FamilyMembersTableFilterComposer
    extends Composer<_$AppDatabase, $FamilyMembersTable> {
  $$FamilyMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get avatarColor => $composableBuilder(
    column: $table.avatarColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> accountsRefs(
    Expression<bool> Function($$AccountsTableFilterComposer f) f,
  ) {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FamilyMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $FamilyMembersTable> {
  $$FamilyMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get avatarColor => $composableBuilder(
    column: $table.avatarColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FamilyMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $FamilyMembersTable> {
  $$FamilyMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get avatarColor => $composableBuilder(
    column: $table.avatarColor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> accountsRefs<T extends Object>(
    Expression<T> Function($$AccountsTableAnnotationComposer a) f,
  ) {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FamilyMembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FamilyMembersTable,
          FamilyMember,
          $$FamilyMembersTableFilterComposer,
          $$FamilyMembersTableOrderingComposer,
          $$FamilyMembersTableAnnotationComposer,
          $$FamilyMembersTableCreateCompanionBuilder,
          $$FamilyMembersTableUpdateCompanionBuilder,
          (FamilyMember, $$FamilyMembersTableReferences),
          FamilyMember,
          PrefetchHooks Function({bool accountsRefs})
        > {
  $$FamilyMembersTableTableManager(_$AppDatabase db, $FamilyMembersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FamilyMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FamilyMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FamilyMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> avatarColor = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => FamilyMembersCompanion(
                id: id,
                name: name,
                avatarColor: avatarColor,
                sortOrder: sortOrder,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int> avatarColor = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => FamilyMembersCompanion.insert(
                id: id,
                name: name,
                avatarColor: avatarColor,
                sortOrder: sortOrder,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FamilyMembersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (accountsRefs) db.accounts],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (accountsRefs)
                    await $_getPrefetchedData<
                      FamilyMember,
                      $FamilyMembersTable,
                      Account
                    >(
                      currentTable: table,
                      referencedTable: $$FamilyMembersTableReferences
                          ._accountsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$FamilyMembersTableReferences(
                            db,
                            table,
                            p0,
                          ).accountsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.memberId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$FamilyMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FamilyMembersTable,
      FamilyMember,
      $$FamilyMembersTableFilterComposer,
      $$FamilyMembersTableOrderingComposer,
      $$FamilyMembersTableAnnotationComposer,
      $$FamilyMembersTableCreateCompanionBuilder,
      $$FamilyMembersTableUpdateCompanionBuilder,
      (FamilyMember, $$FamilyMembersTableReferences),
      FamilyMember,
      PrefetchHooks Function({bool accountsRefs})
    >;
typedef $$AccountsTableCreateCompanionBuilder =
    AccountsCompanion Function({
      Value<int> id,
      required int memberId,
      required String name,
      required String category,
      required String currency,
      Value<bool> reminderEnabled,
      Value<int> reminderIntervalDays,
      Value<DateTime?> lastReminderAt,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
    });
typedef $$AccountsTableUpdateCompanionBuilder =
    AccountsCompanion Function({
      Value<int> id,
      Value<int> memberId,
      Value<String> name,
      Value<String> category,
      Value<String> currency,
      Value<bool> reminderEnabled,
      Value<int> reminderIntervalDays,
      Value<DateTime?> lastReminderAt,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
    });

final class $$AccountsTableReferences
    extends BaseReferences<_$AppDatabase, $AccountsTable, Account> {
  $$AccountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FamilyMembersTable _memberIdTable(_$AppDatabase db) =>
      db.familyMembers.createAlias('accounts__member_id__family_members__id');

  $$FamilyMembersTableProcessedTableManager get memberId {
    final $_column = $_itemColumn<int>('member_id')!;

    final manager = $$FamilyMembersTableTableManager(
      $_db,
      $_db.familyMembers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$BalanceSnapshotsTable, List<BalanceSnapshot>>
  _balanceSnapshotsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.balanceSnapshots,
    aliasName: 'accounts__id__balance_snapshots__account_id',
  );

  $$BalanceSnapshotsTableProcessedTableManager get balanceSnapshotsRefs {
    final manager = $$BalanceSnapshotsTableTableManager(
      $_db,
      $_db.balanceSnapshots,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _balanceSnapshotsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderIntervalDays => $composableBuilder(
    column: $table.reminderIntervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReminderAt => $composableBuilder(
    column: $table.lastReminderAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$FamilyMembersTableFilterComposer get memberId {
    final $$FamilyMembersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.familyMembers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamilyMembersTableFilterComposer(
            $db: $db,
            $table: $db.familyMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> balanceSnapshotsRefs(
    Expression<bool> Function($$BalanceSnapshotsTableFilterComposer f) f,
  ) {
    final $$BalanceSnapshotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.balanceSnapshots,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BalanceSnapshotsTableFilterComposer(
            $db: $db,
            $table: $db.balanceSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderIntervalDays => $composableBuilder(
    column: $table.reminderIntervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReminderAt => $composableBuilder(
    column: $table.lastReminderAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$FamilyMembersTableOrderingComposer get memberId {
    final $$FamilyMembersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.familyMembers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamilyMembersTableOrderingComposer(
            $db: $db,
            $table: $db.familyMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderIntervalDays => $composableBuilder(
    column: $table.reminderIntervalDays,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastReminderAt => $composableBuilder(
    column: $table.lastReminderAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$FamilyMembersTableAnnotationComposer get memberId {
    final $$FamilyMembersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.familyMembers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamilyMembersTableAnnotationComposer(
            $db: $db,
            $table: $db.familyMembers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> balanceSnapshotsRefs<T extends Object>(
    Expression<T> Function($$BalanceSnapshotsTableAnnotationComposer a) f,
  ) {
    final $$BalanceSnapshotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.balanceSnapshots,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BalanceSnapshotsTableAnnotationComposer(
            $db: $db,
            $table: $db.balanceSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTable,
          Account,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (Account, $$AccountsTableReferences),
          Account,
          PrefetchHooks Function({bool memberId, bool balanceSnapshotsRefs})
        > {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> memberId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<bool> reminderEnabled = const Value.absent(),
                Value<int> reminderIntervalDays = const Value.absent(),
                Value<DateTime?> lastReminderAt = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                memberId: memberId,
                name: name,
                category: category,
                currency: currency,
                reminderEnabled: reminderEnabled,
                reminderIntervalDays: reminderIntervalDays,
                lastReminderAt: lastReminderAt,
                isArchived: isArchived,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int memberId,
                required String name,
                required String category,
                required String currency,
                Value<bool> reminderEnabled = const Value.absent(),
                Value<int> reminderIntervalDays = const Value.absent(),
                Value<DateTime?> lastReminderAt = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                memberId: memberId,
                name: name,
                category: category,
                currency: currency,
                reminderEnabled: reminderEnabled,
                reminderIntervalDays: reminderIntervalDays,
                lastReminderAt: lastReminderAt,
                isArchived: isArchived,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({memberId = false, balanceSnapshotsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (balanceSnapshotsRefs) db.balanceSnapshots,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (memberId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.memberId,
                                    referencedTable: $$AccountsTableReferences
                                        ._memberIdTable(db),
                                    referencedColumn: $$AccountsTableReferences
                                        ._memberIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (balanceSnapshotsRefs)
                        await $_getPrefetchedData<
                          Account,
                          $AccountsTable,
                          BalanceSnapshot
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._balanceSnapshotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).balanceSnapshotsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTable,
      Account,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (Account, $$AccountsTableReferences),
      Account,
      PrefetchHooks Function({bool memberId, bool balanceSnapshotsRefs})
    >;
typedef $$FxSnapshotsTableCreateCompanionBuilder =
    FxSnapshotsCompanion Function({
      Value<int> id,
      Value<DateTime> recordedAt,
      Value<String> sourceNote,
    });
typedef $$FxSnapshotsTableUpdateCompanionBuilder =
    FxSnapshotsCompanion Function({
      Value<int> id,
      Value<DateTime> recordedAt,
      Value<String> sourceNote,
    });

final class $$FxSnapshotsTableReferences
    extends BaseReferences<_$AppDatabase, $FxSnapshotsTable, FxSnapshot> {
  $$FxSnapshotsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$FxRatesTable, List<FxRate>> _fxRatesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.fxRates,
    aliasName: 'fx_snapshots__id__fx_rates__fx_snapshot_id',
  );

  $$FxRatesTableProcessedTableManager get fxRatesRefs {
    final manager = $$FxRatesTableTableManager(
      $_db,
      $_db.fxRates,
    ).filter((f) => f.fxSnapshotId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_fxRatesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$UpdateSessionsTable, List<UpdateSession>>
  _updateSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.updateSessions,
    aliasName: 'fx_snapshots__id__update_sessions__fx_snapshot_id',
  );

  $$UpdateSessionsTableProcessedTableManager get updateSessionsRefs {
    final manager = $$UpdateSessionsTableTableManager(
      $_db,
      $_db.updateSessions,
    ).filter((f) => f.fxSnapshotId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_updateSessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FxSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $FxSnapshotsTable> {
  $$FxSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceNote => $composableBuilder(
    column: $table.sourceNote,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> fxRatesRefs(
    Expression<bool> Function($$FxRatesTableFilterComposer f) f,
  ) {
    final $$FxRatesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fxRates,
      getReferencedColumn: (t) => t.fxSnapshotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FxRatesTableFilterComposer(
            $db: $db,
            $table: $db.fxRates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> updateSessionsRefs(
    Expression<bool> Function($$UpdateSessionsTableFilterComposer f) f,
  ) {
    final $$UpdateSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.updateSessions,
      getReferencedColumn: (t) => t.fxSnapshotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UpdateSessionsTableFilterComposer(
            $db: $db,
            $table: $db.updateSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FxSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $FxSnapshotsTable> {
  $$FxSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceNote => $composableBuilder(
    column: $table.sourceNote,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FxSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FxSnapshotsTable> {
  $$FxSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceNote => $composableBuilder(
    column: $table.sourceNote,
    builder: (column) => column,
  );

  Expression<T> fxRatesRefs<T extends Object>(
    Expression<T> Function($$FxRatesTableAnnotationComposer a) f,
  ) {
    final $$FxRatesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.fxRates,
      getReferencedColumn: (t) => t.fxSnapshotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FxRatesTableAnnotationComposer(
            $db: $db,
            $table: $db.fxRates,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> updateSessionsRefs<T extends Object>(
    Expression<T> Function($$UpdateSessionsTableAnnotationComposer a) f,
  ) {
    final $$UpdateSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.updateSessions,
      getReferencedColumn: (t) => t.fxSnapshotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UpdateSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.updateSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FxSnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FxSnapshotsTable,
          FxSnapshot,
          $$FxSnapshotsTableFilterComposer,
          $$FxSnapshotsTableOrderingComposer,
          $$FxSnapshotsTableAnnotationComposer,
          $$FxSnapshotsTableCreateCompanionBuilder,
          $$FxSnapshotsTableUpdateCompanionBuilder,
          (FxSnapshot, $$FxSnapshotsTableReferences),
          FxSnapshot,
          PrefetchHooks Function({bool fxRatesRefs, bool updateSessionsRefs})
        > {
  $$FxSnapshotsTableTableManager(_$AppDatabase db, $FxSnapshotsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FxSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FxSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FxSnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<String> sourceNote = const Value.absent(),
              }) => FxSnapshotsCompanion(
                id: id,
                recordedAt: recordedAt,
                sourceNote: sourceNote,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<String> sourceNote = const Value.absent(),
              }) => FxSnapshotsCompanion.insert(
                id: id,
                recordedAt: recordedAt,
                sourceNote: sourceNote,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FxSnapshotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({fxRatesRefs = false, updateSessionsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (fxRatesRefs) db.fxRates,
                    if (updateSessionsRefs) db.updateSessions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (fxRatesRefs)
                        await $_getPrefetchedData<
                          FxSnapshot,
                          $FxSnapshotsTable,
                          FxRate
                        >(
                          currentTable: table,
                          referencedTable: $$FxSnapshotsTableReferences
                              ._fxRatesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FxSnapshotsTableReferences(
                                db,
                                table,
                                p0,
                              ).fxRatesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.fxSnapshotId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (updateSessionsRefs)
                        await $_getPrefetchedData<
                          FxSnapshot,
                          $FxSnapshotsTable,
                          UpdateSession
                        >(
                          currentTable: table,
                          referencedTable: $$FxSnapshotsTableReferences
                              ._updateSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FxSnapshotsTableReferences(
                                db,
                                table,
                                p0,
                              ).updateSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.fxSnapshotId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$FxSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FxSnapshotsTable,
      FxSnapshot,
      $$FxSnapshotsTableFilterComposer,
      $$FxSnapshotsTableOrderingComposer,
      $$FxSnapshotsTableAnnotationComposer,
      $$FxSnapshotsTableCreateCompanionBuilder,
      $$FxSnapshotsTableUpdateCompanionBuilder,
      (FxSnapshot, $$FxSnapshotsTableReferences),
      FxSnapshot,
      PrefetchHooks Function({bool fxRatesRefs, bool updateSessionsRefs})
    >;
typedef $$FxRatesTableCreateCompanionBuilder =
    FxRatesCompanion Function({
      Value<int> id,
      required int fxSnapshotId,
      required String fromCurrency,
      required String toCurrency,
      required double rate,
    });
typedef $$FxRatesTableUpdateCompanionBuilder =
    FxRatesCompanion Function({
      Value<int> id,
      Value<int> fxSnapshotId,
      Value<String> fromCurrency,
      Value<String> toCurrency,
      Value<double> rate,
    });

final class $$FxRatesTableReferences
    extends BaseReferences<_$AppDatabase, $FxRatesTable, FxRate> {
  $$FxRatesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FxSnapshotsTable _fxSnapshotIdTable(_$AppDatabase db) =>
      db.fxSnapshots.createAlias('fx_rates__fx_snapshot_id__fx_snapshots__id');

  $$FxSnapshotsTableProcessedTableManager get fxSnapshotId {
    final $_column = $_itemColumn<int>('fx_snapshot_id')!;

    final manager = $$FxSnapshotsTableTableManager(
      $_db,
      $_db.fxSnapshots,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fxSnapshotIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FxRatesTableFilterComposer
    extends Composer<_$AppDatabase, $FxRatesTable> {
  $$FxRatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromCurrency => $composableBuilder(
    column: $table.fromCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toCurrency => $composableBuilder(
    column: $table.toCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnFilters(column),
  );

  $$FxSnapshotsTableFilterComposer get fxSnapshotId {
    final $$FxSnapshotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fxSnapshotId,
      referencedTable: $db.fxSnapshots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FxSnapshotsTableFilterComposer(
            $db: $db,
            $table: $db.fxSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FxRatesTableOrderingComposer
    extends Composer<_$AppDatabase, $FxRatesTable> {
  $$FxRatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromCurrency => $composableBuilder(
    column: $table.fromCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toCurrency => $composableBuilder(
    column: $table.toCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rate => $composableBuilder(
    column: $table.rate,
    builder: (column) => ColumnOrderings(column),
  );

  $$FxSnapshotsTableOrderingComposer get fxSnapshotId {
    final $$FxSnapshotsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fxSnapshotId,
      referencedTable: $db.fxSnapshots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FxSnapshotsTableOrderingComposer(
            $db: $db,
            $table: $db.fxSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FxRatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FxRatesTable> {
  $$FxRatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fromCurrency => $composableBuilder(
    column: $table.fromCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get toCurrency => $composableBuilder(
    column: $table.toCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<double> get rate =>
      $composableBuilder(column: $table.rate, builder: (column) => column);

  $$FxSnapshotsTableAnnotationComposer get fxSnapshotId {
    final $$FxSnapshotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fxSnapshotId,
      referencedTable: $db.fxSnapshots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FxSnapshotsTableAnnotationComposer(
            $db: $db,
            $table: $db.fxSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FxRatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FxRatesTable,
          FxRate,
          $$FxRatesTableFilterComposer,
          $$FxRatesTableOrderingComposer,
          $$FxRatesTableAnnotationComposer,
          $$FxRatesTableCreateCompanionBuilder,
          $$FxRatesTableUpdateCompanionBuilder,
          (FxRate, $$FxRatesTableReferences),
          FxRate,
          PrefetchHooks Function({bool fxSnapshotId})
        > {
  $$FxRatesTableTableManager(_$AppDatabase db, $FxRatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FxRatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FxRatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FxRatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> fxSnapshotId = const Value.absent(),
                Value<String> fromCurrency = const Value.absent(),
                Value<String> toCurrency = const Value.absent(),
                Value<double> rate = const Value.absent(),
              }) => FxRatesCompanion(
                id: id,
                fxSnapshotId: fxSnapshotId,
                fromCurrency: fromCurrency,
                toCurrency: toCurrency,
                rate: rate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int fxSnapshotId,
                required String fromCurrency,
                required String toCurrency,
                required double rate,
              }) => FxRatesCompanion.insert(
                id: id,
                fxSnapshotId: fxSnapshotId,
                fromCurrency: fromCurrency,
                toCurrency: toCurrency,
                rate: rate,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FxRatesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({fxSnapshotId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (fxSnapshotId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.fxSnapshotId,
                                referencedTable: $$FxRatesTableReferences
                                    ._fxSnapshotIdTable(db),
                                referencedColumn: $$FxRatesTableReferences
                                    ._fxSnapshotIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FxRatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FxRatesTable,
      FxRate,
      $$FxRatesTableFilterComposer,
      $$FxRatesTableOrderingComposer,
      $$FxRatesTableAnnotationComposer,
      $$FxRatesTableCreateCompanionBuilder,
      $$FxRatesTableUpdateCompanionBuilder,
      (FxRate, $$FxRatesTableReferences),
      FxRate,
      PrefetchHooks Function({bool fxSnapshotId})
    >;
typedef $$UpdateSessionsTableCreateCompanionBuilder =
    UpdateSessionsCompanion Function({
      Value<int> id,
      Value<DateTime> recordedAt,
      required int fxSnapshotId,
      Value<String> note,
    });
typedef $$UpdateSessionsTableUpdateCompanionBuilder =
    UpdateSessionsCompanion Function({
      Value<int> id,
      Value<DateTime> recordedAt,
      Value<int> fxSnapshotId,
      Value<String> note,
    });

final class $$UpdateSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $UpdateSessionsTable, UpdateSession> {
  $$UpdateSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $FxSnapshotsTable _fxSnapshotIdTable(_$AppDatabase db) => db
      .fxSnapshots
      .createAlias('update_sessions__fx_snapshot_id__fx_snapshots__id');

  $$FxSnapshotsTableProcessedTableManager get fxSnapshotId {
    final $_column = $_itemColumn<int>('fx_snapshot_id')!;

    final manager = $$FxSnapshotsTableTableManager(
      $_db,
      $_db.fxSnapshots,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_fxSnapshotIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$BalanceSnapshotsTable, List<BalanceSnapshot>>
  _balanceSnapshotsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.balanceSnapshots,
    aliasName: 'update_sessions__id__balance_snapshots__update_session_id',
  );

  $$BalanceSnapshotsTableProcessedTableManager get balanceSnapshotsRefs {
    final manager = $$BalanceSnapshotsTableTableManager(
      $_db,
      $_db.balanceSnapshots,
    ).filter((f) => f.updateSessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _balanceSnapshotsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UpdateSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $UpdateSessionsTable> {
  $$UpdateSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$FxSnapshotsTableFilterComposer get fxSnapshotId {
    final $$FxSnapshotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fxSnapshotId,
      referencedTable: $db.fxSnapshots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FxSnapshotsTableFilterComposer(
            $db: $db,
            $table: $db.fxSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> balanceSnapshotsRefs(
    Expression<bool> Function($$BalanceSnapshotsTableFilterComposer f) f,
  ) {
    final $$BalanceSnapshotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.balanceSnapshots,
      getReferencedColumn: (t) => t.updateSessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BalanceSnapshotsTableFilterComposer(
            $db: $db,
            $table: $db.balanceSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UpdateSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $UpdateSessionsTable> {
  $$UpdateSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$FxSnapshotsTableOrderingComposer get fxSnapshotId {
    final $$FxSnapshotsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fxSnapshotId,
      referencedTable: $db.fxSnapshots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FxSnapshotsTableOrderingComposer(
            $db: $db,
            $table: $db.fxSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UpdateSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UpdateSessionsTable> {
  $$UpdateSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$FxSnapshotsTableAnnotationComposer get fxSnapshotId {
    final $$FxSnapshotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.fxSnapshotId,
      referencedTable: $db.fxSnapshots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FxSnapshotsTableAnnotationComposer(
            $db: $db,
            $table: $db.fxSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> balanceSnapshotsRefs<T extends Object>(
    Expression<T> Function($$BalanceSnapshotsTableAnnotationComposer a) f,
  ) {
    final $$BalanceSnapshotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.balanceSnapshots,
      getReferencedColumn: (t) => t.updateSessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BalanceSnapshotsTableAnnotationComposer(
            $db: $db,
            $table: $db.balanceSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UpdateSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UpdateSessionsTable,
          UpdateSession,
          $$UpdateSessionsTableFilterComposer,
          $$UpdateSessionsTableOrderingComposer,
          $$UpdateSessionsTableAnnotationComposer,
          $$UpdateSessionsTableCreateCompanionBuilder,
          $$UpdateSessionsTableUpdateCompanionBuilder,
          (UpdateSession, $$UpdateSessionsTableReferences),
          UpdateSession,
          PrefetchHooks Function({bool fxSnapshotId, bool balanceSnapshotsRefs})
        > {
  $$UpdateSessionsTableTableManager(
    _$AppDatabase db,
    $UpdateSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UpdateSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UpdateSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UpdateSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<int> fxSnapshotId = const Value.absent(),
                Value<String> note = const Value.absent(),
              }) => UpdateSessionsCompanion(
                id: id,
                recordedAt: recordedAt,
                fxSnapshotId: fxSnapshotId,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                required int fxSnapshotId,
                Value<String> note = const Value.absent(),
              }) => UpdateSessionsCompanion.insert(
                id: id,
                recordedAt: recordedAt,
                fxSnapshotId: fxSnapshotId,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UpdateSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({fxSnapshotId = false, balanceSnapshotsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (balanceSnapshotsRefs) db.balanceSnapshots,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (fxSnapshotId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.fxSnapshotId,
                                    referencedTable:
                                        $$UpdateSessionsTableReferences
                                            ._fxSnapshotIdTable(db),
                                    referencedColumn:
                                        $$UpdateSessionsTableReferences
                                            ._fxSnapshotIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (balanceSnapshotsRefs)
                        await $_getPrefetchedData<
                          UpdateSession,
                          $UpdateSessionsTable,
                          BalanceSnapshot
                        >(
                          currentTable: table,
                          referencedTable: $$UpdateSessionsTableReferences
                              ._balanceSnapshotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UpdateSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).balanceSnapshotsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.updateSessionId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$UpdateSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UpdateSessionsTable,
      UpdateSession,
      $$UpdateSessionsTableFilterComposer,
      $$UpdateSessionsTableOrderingComposer,
      $$UpdateSessionsTableAnnotationComposer,
      $$UpdateSessionsTableCreateCompanionBuilder,
      $$UpdateSessionsTableUpdateCompanionBuilder,
      (UpdateSession, $$UpdateSessionsTableReferences),
      UpdateSession,
      PrefetchHooks Function({bool fxSnapshotId, bool balanceSnapshotsRefs})
    >;
typedef $$BalanceSnapshotsTableCreateCompanionBuilder =
    BalanceSnapshotsCompanion Function({
      Value<int> id,
      required int accountId,
      required int updateSessionId,
      required double amount,
      Value<DateTime> recordedAt,
      Value<String> note,
      Value<String?> changeReason,
      Value<String> changeReasonText,
      Value<double?> deltaFromPrevious,
      Value<double?> deltaPercent,
    });
typedef $$BalanceSnapshotsTableUpdateCompanionBuilder =
    BalanceSnapshotsCompanion Function({
      Value<int> id,
      Value<int> accountId,
      Value<int> updateSessionId,
      Value<double> amount,
      Value<DateTime> recordedAt,
      Value<String> note,
      Value<String?> changeReason,
      Value<String> changeReasonText,
      Value<double?> deltaFromPrevious,
      Value<double?> deltaPercent,
    });

final class $$BalanceSnapshotsTableReferences
    extends
        BaseReferences<_$AppDatabase, $BalanceSnapshotsTable, BalanceSnapshot> {
  $$BalanceSnapshotsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AccountsTable _accountIdTable(_$AppDatabase db) =>
      db.accounts.createAlias('balance_snapshots__account_id__accounts__id');

  $$AccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<int>('account_id')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UpdateSessionsTable _updateSessionIdTable(_$AppDatabase db) => db
      .updateSessions
      .createAlias('balance_snapshots__update_session_id__update_sessions__id');

  $$UpdateSessionsTableProcessedTableManager get updateSessionId {
    final $_column = $_itemColumn<int>('update_session_id')!;

    final manager = $$UpdateSessionsTableTableManager(
      $_db,
      $_db.updateSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_updateSessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BalanceSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $BalanceSnapshotsTable> {
  $$BalanceSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get changeReason => $composableBuilder(
    column: $table.changeReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get changeReasonText => $composableBuilder(
    column: $table.changeReasonText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get deltaFromPrevious => $composableBuilder(
    column: $table.deltaFromPrevious,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get deltaPercent => $composableBuilder(
    column: $table.deltaPercent,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountId {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UpdateSessionsTableFilterComposer get updateSessionId {
    final $$UpdateSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.updateSessionId,
      referencedTable: $db.updateSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UpdateSessionsTableFilterComposer(
            $db: $db,
            $table: $db.updateSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BalanceSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $BalanceSnapshotsTable> {
  $$BalanceSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get changeReason => $composableBuilder(
    column: $table.changeReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get changeReasonText => $composableBuilder(
    column: $table.changeReasonText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get deltaFromPrevious => $composableBuilder(
    column: $table.deltaFromPrevious,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get deltaPercent => $composableBuilder(
    column: $table.deltaPercent,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountId {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UpdateSessionsTableOrderingComposer get updateSessionId {
    final $$UpdateSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.updateSessionId,
      referencedTable: $db.updateSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UpdateSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.updateSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BalanceSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BalanceSnapshotsTable> {
  $$BalanceSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get changeReason => $composableBuilder(
    column: $table.changeReason,
    builder: (column) => column,
  );

  GeneratedColumn<String> get changeReasonText => $composableBuilder(
    column: $table.changeReasonText,
    builder: (column) => column,
  );

  GeneratedColumn<double> get deltaFromPrevious => $composableBuilder(
    column: $table.deltaFromPrevious,
    builder: (column) => column,
  );

  GeneratedColumn<double> get deltaPercent => $composableBuilder(
    column: $table.deltaPercent,
    builder: (column) => column,
  );

  $$AccountsTableAnnotationComposer get accountId {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UpdateSessionsTableAnnotationComposer get updateSessionId {
    final $$UpdateSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.updateSessionId,
      referencedTable: $db.updateSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UpdateSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.updateSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BalanceSnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BalanceSnapshotsTable,
          BalanceSnapshot,
          $$BalanceSnapshotsTableFilterComposer,
          $$BalanceSnapshotsTableOrderingComposer,
          $$BalanceSnapshotsTableAnnotationComposer,
          $$BalanceSnapshotsTableCreateCompanionBuilder,
          $$BalanceSnapshotsTableUpdateCompanionBuilder,
          (BalanceSnapshot, $$BalanceSnapshotsTableReferences),
          BalanceSnapshot,
          PrefetchHooks Function({bool accountId, bool updateSessionId})
        > {
  $$BalanceSnapshotsTableTableManager(
    _$AppDatabase db,
    $BalanceSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BalanceSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BalanceSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BalanceSnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> accountId = const Value.absent(),
                Value<int> updateSessionId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<String?> changeReason = const Value.absent(),
                Value<String> changeReasonText = const Value.absent(),
                Value<double?> deltaFromPrevious = const Value.absent(),
                Value<double?> deltaPercent = const Value.absent(),
              }) => BalanceSnapshotsCompanion(
                id: id,
                accountId: accountId,
                updateSessionId: updateSessionId,
                amount: amount,
                recordedAt: recordedAt,
                note: note,
                changeReason: changeReason,
                changeReasonText: changeReasonText,
                deltaFromPrevious: deltaFromPrevious,
                deltaPercent: deltaPercent,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int accountId,
                required int updateSessionId,
                required double amount,
                Value<DateTime> recordedAt = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<String?> changeReason = const Value.absent(),
                Value<String> changeReasonText = const Value.absent(),
                Value<double?> deltaFromPrevious = const Value.absent(),
                Value<double?> deltaPercent = const Value.absent(),
              }) => BalanceSnapshotsCompanion.insert(
                id: id,
                accountId: accountId,
                updateSessionId: updateSessionId,
                amount: amount,
                recordedAt: recordedAt,
                note: note,
                changeReason: changeReason,
                changeReasonText: changeReasonText,
                deltaFromPrevious: deltaFromPrevious,
                deltaPercent: deltaPercent,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BalanceSnapshotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({accountId = false, updateSessionId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (accountId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.accountId,
                                    referencedTable:
                                        $$BalanceSnapshotsTableReferences
                                            ._accountIdTable(db),
                                    referencedColumn:
                                        $$BalanceSnapshotsTableReferences
                                            ._accountIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (updateSessionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.updateSessionId,
                                    referencedTable:
                                        $$BalanceSnapshotsTableReferences
                                            ._updateSessionIdTable(db),
                                    referencedColumn:
                                        $$BalanceSnapshotsTableReferences
                                            ._updateSessionIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$BalanceSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BalanceSnapshotsTable,
      BalanceSnapshot,
      $$BalanceSnapshotsTableFilterComposer,
      $$BalanceSnapshotsTableOrderingComposer,
      $$BalanceSnapshotsTableAnnotationComposer,
      $$BalanceSnapshotsTableCreateCompanionBuilder,
      $$BalanceSnapshotsTableUpdateCompanionBuilder,
      (BalanceSnapshot, $$BalanceSnapshotsTableReferences),
      BalanceSnapshot,
      PrefetchHooks Function({bool accountId, bool updateSessionId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String> displayCurrency,
      Value<double> largeChangeThresholdPercent,
      Value<double> largeChangeThresholdAmount,
      Value<String> s3Endpoint,
      Value<String> s3Bucket,
      Value<String> s3AccessKey,
      Value<String> s3Prefix,
      Value<String> localeLanguageCode,
      Value<bool> biometricLockEnabled,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<int> id,
      Value<String> displayCurrency,
      Value<double> largeChangeThresholdPercent,
      Value<double> largeChangeThresholdAmount,
      Value<String> s3Endpoint,
      Value<String> s3Bucket,
      Value<String> s3AccessKey,
      Value<String> s3Prefix,
      Value<String> localeLanguageCode,
      Value<bool> biometricLockEnabled,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayCurrency => $composableBuilder(
    column: $table.displayCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get largeChangeThresholdPercent => $composableBuilder(
    column: $table.largeChangeThresholdPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get largeChangeThresholdAmount => $composableBuilder(
    column: $table.largeChangeThresholdAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get s3Endpoint => $composableBuilder(
    column: $table.s3Endpoint,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get s3Bucket => $composableBuilder(
    column: $table.s3Bucket,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get s3AccessKey => $composableBuilder(
    column: $table.s3AccessKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get s3Prefix => $composableBuilder(
    column: $table.s3Prefix,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localeLanguageCode => $composableBuilder(
    column: $table.localeLanguageCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get biometricLockEnabled => $composableBuilder(
    column: $table.biometricLockEnabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayCurrency => $composableBuilder(
    column: $table.displayCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get largeChangeThresholdPercent => $composableBuilder(
    column: $table.largeChangeThresholdPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get largeChangeThresholdAmount => $composableBuilder(
    column: $table.largeChangeThresholdAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get s3Endpoint => $composableBuilder(
    column: $table.s3Endpoint,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get s3Bucket => $composableBuilder(
    column: $table.s3Bucket,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get s3AccessKey => $composableBuilder(
    column: $table.s3AccessKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get s3Prefix => $composableBuilder(
    column: $table.s3Prefix,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localeLanguageCode => $composableBuilder(
    column: $table.localeLanguageCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get biometricLockEnabled => $composableBuilder(
    column: $table.biometricLockEnabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayCurrency => $composableBuilder(
    column: $table.displayCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<double> get largeChangeThresholdPercent => $composableBuilder(
    column: $table.largeChangeThresholdPercent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get largeChangeThresholdAmount => $composableBuilder(
    column: $table.largeChangeThresholdAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get s3Endpoint => $composableBuilder(
    column: $table.s3Endpoint,
    builder: (column) => column,
  );

  GeneratedColumn<String> get s3Bucket =>
      $composableBuilder(column: $table.s3Bucket, builder: (column) => column);

  GeneratedColumn<String> get s3AccessKey => $composableBuilder(
    column: $table.s3AccessKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get s3Prefix =>
      $composableBuilder(column: $table.s3Prefix, builder: (column) => column);

  GeneratedColumn<String> get localeLanguageCode => $composableBuilder(
    column: $table.localeLanguageCode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get biometricLockEnabled => $composableBuilder(
    column: $table.biometricLockEnabled,
    builder: (column) => column,
  );
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> displayCurrency = const Value.absent(),
                Value<double> largeChangeThresholdPercent =
                    const Value.absent(),
                Value<double> largeChangeThresholdAmount = const Value.absent(),
                Value<String> s3Endpoint = const Value.absent(),
                Value<String> s3Bucket = const Value.absent(),
                Value<String> s3AccessKey = const Value.absent(),
                Value<String> s3Prefix = const Value.absent(),
                Value<String> localeLanguageCode = const Value.absent(),
                Value<bool> biometricLockEnabled = const Value.absent(),
              }) => AppSettingsCompanion(
                id: id,
                displayCurrency: displayCurrency,
                largeChangeThresholdPercent: largeChangeThresholdPercent,
                largeChangeThresholdAmount: largeChangeThresholdAmount,
                s3Endpoint: s3Endpoint,
                s3Bucket: s3Bucket,
                s3AccessKey: s3AccessKey,
                s3Prefix: s3Prefix,
                localeLanguageCode: localeLanguageCode,
                biometricLockEnabled: biometricLockEnabled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> displayCurrency = const Value.absent(),
                Value<double> largeChangeThresholdPercent =
                    const Value.absent(),
                Value<double> largeChangeThresholdAmount = const Value.absent(),
                Value<String> s3Endpoint = const Value.absent(),
                Value<String> s3Bucket = const Value.absent(),
                Value<String> s3AccessKey = const Value.absent(),
                Value<String> s3Prefix = const Value.absent(),
                Value<String> localeLanguageCode = const Value.absent(),
                Value<bool> biometricLockEnabled = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                id: id,
                displayCurrency: displayCurrency,
                largeChangeThresholdPercent: largeChangeThresholdPercent,
                largeChangeThresholdAmount: largeChangeThresholdAmount,
                s3Endpoint: s3Endpoint,
                s3Bucket: s3Bucket,
                s3AccessKey: s3AccessKey,
                s3Prefix: s3Prefix,
                localeLanguageCode: localeLanguageCode,
                biometricLockEnabled: biometricLockEnabled,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FamilyMembersTableTableManager get familyMembers =>
      $$FamilyMembersTableTableManager(_db, _db.familyMembers);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$FxSnapshotsTableTableManager get fxSnapshots =>
      $$FxSnapshotsTableTableManager(_db, _db.fxSnapshots);
  $$FxRatesTableTableManager get fxRates =>
      $$FxRatesTableTableManager(_db, _db.fxRates);
  $$UpdateSessionsTableTableManager get updateSessions =>
      $$UpdateSessionsTableTableManager(_db, _db.updateSessions);
  $$BalanceSnapshotsTableTableManager get balanceSnapshots =>
      $$BalanceSnapshotsTableTableManager(_db, _db.balanceSnapshots);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
