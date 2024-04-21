import 'dart:async';

import 'package:crypto_wallet_traning/config_env.dart';
import 'package:crypto_wallet_traning/contracts/token/TokenContract.g.dart';
import 'package:crypto_wallet_traning/utils/custom_number_formatter.dart';
import 'package:web3dart/web3dart.dart';

import '../utils/contract_utils.dart';

class TokensRepo {
  late Web3Client _web3client;

  late StreamSubscription<Transfer> _tokenTransferSub;

  TokensRepo(Web3Client web3client) {
    _web3client = web3client;
    //_userWalletCredential = EthPrivateKey.fromHex(walletPrivateKey);
  }

  String getCurrentWalletAddress(Credentials credentials) {
    return credentials.address.toString();
  }

  TokenContract getTokenContract(String contractAddress) {
    return TokenContract(
      address: EthereumAddress.fromHex(contractAddress),
      client: _web3client,
      chainId: 97,
    );
  }

  Future<double> getNativeBalance(String userAddress) async {
    var weiBalance =
        (await _web3client.getBalance(EthereumAddress.fromHex(userAddress)))
            .getInWei;
    return CustomNumberFormatter.fromWeiToEthFormatted(weiBalance);
  }

  Future<String> transferNativeCoin(
      Credentials credentials,
      double amount,
      String toAddress,
      Function(String, String, double) onTransferCompleted) async {
    var transactionHash = await _web3client.sendTransaction(
        credentials,
        Transaction(
            to: EthereumAddress.fromHex(toAddress),
            maxGas: 100000,
            value: EtherAmount.inWei(
                CustomNumberFormatter.fromDoubleEthToWei(amount))),
        chainId: 97);
    reTryCheckingTransactionResult(
        web3Client: _web3client,
        transactionHash: transactionHash,
        onTransactionSuccess: (receipt) {
          onTransferCompleted.call(
            credentials.address.toString(),
            toAddress,
            amount,
          );
        });
    return transactionHash;
  }

  Future<String> getTokenSymbol(String tokenContractAddress) async {
    var tokenContract = getTokenContract(tokenContractAddress);
    return await tokenContract.symbol();
  }

  Future<String> getTokenName(String tokenContractAddress) async {
    var tokenContract = getTokenContract(tokenContractAddress);
    return await tokenContract.name();
  }

  Future<double> getTokenBalance(
      String useAddress, String tokenContractAddress) async {
    var tokenContract = getTokenContract(tokenContractAddress);
    var weiBalance =
        await tokenContract.balanceOf(EthereumAddress.fromHex(useAddress));
    return CustomNumberFormatter.fromWeiToEthFormatted(weiBalance);
  }

  Future<String> transferToken(
    Credentials credentials,
    String tokenContractAddress,
    double amount,
    String toAddress,
    Function(String, String, double) onTransferCompleted,
  ) async {
    var tokenContract = getTokenContract(tokenContractAddress);
    var receiptientAddress = EthereumAddress.fromHex(toAddress);
    var amountToSend = CustomNumberFormatter.fromDoubleEthToWei(amount);

    _tokenTransferSub = tokenContract.transferEvents().listen((event) {
      if (event.from == credentials.address &&
          event.to == receiptientAddress &&
          event.value == amountToSend) {
        onTransferCompleted.call(
            credentials.address.toString(),
            recipientAddress.toString(),
            CustomNumberFormatter.fromWeiToEthFormatted(amountToSend));
        _tokenTransferSub.cancel();
      }
    });
    return await tokenContract.transfer(receiptientAddress, amountToSend,
        credentials: credentials, transaction: Transaction(maxGas: 100000));
  }
}
