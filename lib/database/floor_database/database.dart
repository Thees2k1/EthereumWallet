import 'dart:async';
import 'package:floor/floor.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/wallet_dao.dart';
import 'entity/wallet.dart';

part 'database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Wallet])
abstract class AppDatabase extends FloorDatabase {
  WalletDao get walletDao;
}
