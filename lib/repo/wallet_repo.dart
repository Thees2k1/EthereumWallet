import 'dart:async';
import 'package:crypto_wallet_traning/config_env.dart';
import 'package:crypto_wallet_traning/utils/custom_number_formatter.dart';
import 'package:flutter/widgets.dart';
import 'package:web3dart/web3dart.dart';
import '../models/walletmodel.dart';

class WalletsRepo {
  late Web3Client _web3client;
  WalletsRepo(
    Web3Client web3client,
  ) {
    _web3client = web3client;
  }
  Future<double> getNativeBalance(String userAddress) async {
    var weiBalance =
        (await _web3client.getBalance(EthereumAddress.fromHex(userAddress)))
            .getInWei;
    return CustomNumberFormatter.fromWeiToEthFormatted(weiBalance);
  }

  Future<List<WalletModel>> getAllWallets() async {
    List<WalletModel> wallets = [];
    final res = await database!.findAllWallets();

    for (int i = 0; i < res.length; i++) {
      final balance = await getNativeBalance(res[i].address);
      wallets.add(
        WalletModel(
          privateKey: res[i].privateKey,
          walletName: res[i].name,
          walletAddress: res[i].address,
          nativeBalance: balance.toStringAsFixed(2),
          isSelected: res[i].isSelected,
        ),
      );
    }
    return wallets;
  }

  Future<bool> changeSelection(String privateKey) async {
    try {
      await database!.unSelectWallet();
      await database!.selectWallet(privateKey);
      return true;
    } catch (e) {
      debugPrint('$e');
      return false;
    }
  }
}
