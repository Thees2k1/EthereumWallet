// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  WalletDao? _walletDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Wallet` (`key` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, `address` TEXT NOT NULL, `privateKey` TEXT NOT NULL, `isSelected` INTEGER NOT NULL, `name` TEXT NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  WalletDao get walletDao {
    return _walletDaoInstance ??= _$WalletDao(database, changeListener);
  }
}

class _$WalletDao extends WalletDao {
  _$WalletDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _walletInsertionAdapter = InsertionAdapter(
            database,
            'Wallet',
            (Wallet item) => <String, Object?>{
                  'key': item.key,
                  'address': item.address,
                  'privateKey': item.privateKey,
                  'isSelected': item.isSelected ? 1 : 0,
                  'name': item.name
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Wallet> _walletInsertionAdapter;

  @override
  Future<List<Wallet>> findAllWallets() async {
    return _queryAdapter.queryList('SELECT * FROM Wallet',
        mapper: (Map<String, Object?> row) => Wallet(
            key: row['key'] as int,
            address: row['address'] as String,
            name: row['name'] as String,
            privateKey: row['privateKey'] as String,
            isSelected: (row['isSelected'] as int) != 0));
  }

  @override
  Stream<Wallet?> findWalletById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Wallet WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Wallet(
            key: row['key'] as int,
            address: row['address'] as String,
            name: row['name'] as String,
            privateKey: row['privateKey'] as String,
            isSelected: (row['isSelected'] as int) != 0),
        arguments: [id],
        queryableName: 'Wallet',
        isView: false);
  }

  @override
  Stream<Wallet?> findWalletByPKey(String pkey) {
    return _queryAdapter.queryStream(
        'SELECT * FROM Wallet WHERE privateKey = ?1',
        mapper: (Map<String, Object?> row) => Wallet(
            key: row['key'] as int,
            address: row['address'] as String,
            name: row['name'] as String,
            privateKey: row['privateKey'] as String,
            isSelected: (row['isSelected'] as int) != 0),
        arguments: [pkey],
        queryableName: 'Wallet',
        isView: false);
  }

  @override
  Future<void> deleteAllWallet() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Wallet');
  }

  @override
  Future<void> unSelectWallet() async {
    await _queryAdapter
        .queryNoReturn('UPDATE Wallet SET isSelected = 0 WHERE isSelected = 1');
  }

  @override
  Future<void> selectWallet(String privateKey) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE Wallet SET isSelected = 1 WHERE privateKey = ?1',
        arguments: [privateKey]);
  }

  @override
  Future<String?> findWalletName(String privateKey) async {
    return _queryAdapter.query('SELECT name FROM Wallet WHERE privateKey = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        arguments: [privateKey]);
  }

  @override
  Future<void> insertWallet(Wallet wallet) async {
    await _walletInsertionAdapter.insert(wallet, OnConflictStrategy.abort);
  }
}
