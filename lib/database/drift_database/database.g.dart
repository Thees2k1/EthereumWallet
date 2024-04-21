// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $WalletsTable extends Wallets with TableInfo<$WalletsTable, Wallet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<int> key = GeneratedColumn<int>(
      'key', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _privateKeyMeta =
      const VerificationMeta('privateKey');
  @override
  late final GeneratedColumn<String> privateKey = GeneratedColumn<String>(
      'private_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isSelectedMeta =
      const VerificationMeta('isSelected');
  @override
  late final GeneratedColumn<bool> isSelected =
      GeneratedColumn<bool>('is_selected', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: true,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_selected" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }));
  @override
  List<GeneratedColumn> get $columns =>
      [key, address, privateKey, name, isSelected];
  @override
  String get aliasedName => _alias ?? 'wallets';
  @override
  String get actualTableName => 'wallets';
  @override
  VerificationContext validateIntegrity(Insertable<Wallet> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('private_key')) {
      context.handle(
          _privateKeyMeta,
          privateKey.isAcceptableOrUnknown(
              data['private_key']!, _privateKeyMeta));
    } else if (isInserting) {
      context.missing(_privateKeyMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_selected')) {
      context.handle(
          _isSelectedMeta,
          isSelected.isAcceptableOrUnknown(
              data['is_selected']!, _isSelectedMeta));
    } else if (isInserting) {
      context.missing(_isSelectedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Wallet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Wallet(
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}key'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address'])!,
      privateKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}private_key'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      isSelected: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_selected'])!,
    );
  }

  @override
  $WalletsTable createAlias(String alias) {
    return $WalletsTable(attachedDatabase, alias);
  }
}

class Wallet extends DataClass implements Insertable<Wallet> {
  final int key;
  final String address;
  final String privateKey;
  final String name;
  final bool isSelected;
  const Wallet(
      {required this.key,
      required this.address,
      required this.privateKey,
      required this.name,
      required this.isSelected});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<int>(key);
    map['address'] = Variable<String>(address);
    map['private_key'] = Variable<String>(privateKey);
    map['name'] = Variable<String>(name);
    map['is_selected'] = Variable<bool>(isSelected);
    return map;
  }

  WalletsCompanion toCompanion(bool nullToAbsent) {
    return WalletsCompanion(
      key: Value(key),
      address: Value(address),
      privateKey: Value(privateKey),
      name: Value(name),
      isSelected: Value(isSelected),
    );
  }

  factory Wallet.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Wallet(
      key: serializer.fromJson<int>(json['key']),
      address: serializer.fromJson<String>(json['address']),
      privateKey: serializer.fromJson<String>(json['privateKey']),
      name: serializer.fromJson<String>(json['name']),
      isSelected: serializer.fromJson<bool>(json['isSelected']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<int>(key),
      'address': serializer.toJson<String>(address),
      'privateKey': serializer.toJson<String>(privateKey),
      'name': serializer.toJson<String>(name),
      'isSelected': serializer.toJson<bool>(isSelected),
    };
  }

  Wallet copyWith(
          {int? key,
          String? address,
          String? privateKey,
          String? name,
          bool? isSelected}) =>
      Wallet(
        key: key ?? this.key,
        address: address ?? this.address,
        privateKey: privateKey ?? this.privateKey,
        name: name ?? this.name,
        isSelected: isSelected ?? this.isSelected,
      );
  @override
  String toString() {
    return (StringBuffer('Wallet(')
          ..write('key: $key, ')
          ..write('address: $address, ')
          ..write('privateKey: $privateKey, ')
          ..write('name: $name, ')
          ..write('isSelected: $isSelected')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, address, privateKey, name, isSelected);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Wallet &&
          other.key == this.key &&
          other.address == this.address &&
          other.privateKey == this.privateKey &&
          other.name == this.name &&
          other.isSelected == this.isSelected);
}

class WalletsCompanion extends UpdateCompanion<Wallet> {
  final Value<int> key;
  final Value<String> address;
  final Value<String> privateKey;
  final Value<String> name;
  final Value<bool> isSelected;
  const WalletsCompanion({
    this.key = const Value.absent(),
    this.address = const Value.absent(),
    this.privateKey = const Value.absent(),
    this.name = const Value.absent(),
    this.isSelected = const Value.absent(),
  });
  WalletsCompanion.insert({
    this.key = const Value.absent(),
    required String address,
    required String privateKey,
    required String name,
    required bool isSelected,
  })  : address = Value(address),
        privateKey = Value(privateKey),
        name = Value(name),
        isSelected = Value(isSelected);
  static Insertable<Wallet> custom({
    Expression<int>? key,
    Expression<String>? address,
    Expression<String>? privateKey,
    Expression<String>? name,
    Expression<bool>? isSelected,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (address != null) 'address': address,
      if (privateKey != null) 'private_key': privateKey,
      if (name != null) 'name': name,
      if (isSelected != null) 'is_selected': isSelected,
    });
  }

  WalletsCompanion copyWith(
      {Value<int>? key,
      Value<String>? address,
      Value<String>? privateKey,
      Value<String>? name,
      Value<bool>? isSelected}) {
    return WalletsCompanion(
      key: key ?? this.key,
      address: address ?? this.address,
      privateKey: privateKey ?? this.privateKey,
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<int>(key.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (privateKey.present) {
      map['private_key'] = Variable<String>(privateKey.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isSelected.present) {
      map['is_selected'] = Variable<bool>(isSelected.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletsCompanion(')
          ..write('key: $key, ')
          ..write('address: $address, ')
          ..write('privateKey: $privateKey, ')
          ..write('name: $name, ')
          ..write('isSelected: $isSelected')
          ..write(')'))
        .toString();
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(e);
  late final $WalletsTable wallets = $WalletsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [wallets];
}
