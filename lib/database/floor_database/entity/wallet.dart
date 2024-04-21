import 'package:floor/floor.dart';

@entity
class Wallet {
  @PrimaryKey(autoGenerate: true)
  final int key;

  final String address;

  final String privateKey;

  final bool isSelected;

  final String name;

  Wallet(
      {required this.key,
      required this.address,
      required this.name,
      required this.privateKey,
      required this.isSelected});
}
