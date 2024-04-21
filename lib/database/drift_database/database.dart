import 'package:crypto_wallet_traning/database/drift_database/tables.dart';
import 'package:drift/drift.dart';
import 'dart:io';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:async';

part 'database.g.dart';

@DriftDatabase(tables: [Wallets])
class MyDatabase extends _$MyDatabase {
  // we tell the database where to store the data with this constructor
  MyDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  // you should bump this number whenever you change or add a table definition.
  // Migrations are covered later in the documentation.
  @override
  int get schemaVersion => 1;

  Future<List<Wallet>> findAllWallets() async {
    final res = await select(wallets).get();
    return res;
  }

  Future unSelectWallet() {
    return (update(wallets)..where((wallet) => wallet.isSelected.equals(true)))
        .write(const WalletsCompanion(isSelected: Value(false)));
  }

  Future selectWallet(String privateKey) {
    return (update(wallets)..where((e) => e.privateKey.equals(privateKey)))
        .write(const WalletsCompanion(isSelected: Value(true)));
  }

  Future<String> findWalletName(String privateKey) async {
    final res = await findAllWallets();
    for (int i = 0; i < res.length; i++) {
      if (res[i].privateKey == privateKey) return res[i].name;
    }
    return 'No name';
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
