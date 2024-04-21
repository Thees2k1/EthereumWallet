import 'package:drift/drift.dart';

class Wallets extends Table {
  IntColumn get key => integer().autoIncrement()();
  TextColumn get address => text()();
  TextColumn get privateKey => text()();
  TextColumn get name => text()();
  BoolColumn get isSelected => boolean()();
}
