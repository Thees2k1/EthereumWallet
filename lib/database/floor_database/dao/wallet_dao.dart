import 'package:crypto_wallet_traning/database/floor_database/entity/wallet.dart';
import 'package:floor/floor.dart';

@dao
abstract class WalletDao {
  @Query('SELECT * FROM Wallet')
  Future<List<Wallet>> findAllWallets();

  @Query('SELECT * FROM Wallet WHERE id = :id')
  Stream<Wallet?> findWalletById(int id);

  @Query('SELECT * FROM Wallet WHERE privateKey = :pkey')
  Stream<Wallet?> findWalletByPKey(String pkey);

  @insert
  Future<void> insertWallet(Wallet wallet);

  @Query('DELETE FROM Wallet')
  Future<void> deleteAllWallet();

  @Query('UPDATE Wallet SET isSelected = 0 WHERE isSelected = 1')
  Future<void> unSelectWallet();

  @Query('UPDATE Wallet SET isSelected = 1 WHERE privateKey = :privateKey')
  Future<void> selectWallet(String privateKey);

  @Query('SELECT name FROM Wallet WHERE privateKey = :privateKey')
  Future<String?> findWalletName(String privateKey);
}
