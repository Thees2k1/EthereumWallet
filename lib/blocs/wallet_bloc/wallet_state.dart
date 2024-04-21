import 'package:crypto_wallet_traning/models/walletmodel.dart';

class WalletsState {
  final List<WalletModel>? wallets;
  final Object? error;
  WalletsState({this.wallets, this.error});
}
