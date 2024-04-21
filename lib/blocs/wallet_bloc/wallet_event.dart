abstract class WalletsBlocEvent {}

class LoadAllWallets extends WalletsBlocEvent {}

class ChangeSelection extends WalletsBlocEvent {
  String privateKey;
  ChangeSelection(this.privateKey);
}
