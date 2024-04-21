import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';

//const bscExplorer = 'https://testnet.bscscan.com/tx/';

// void exploreTransaction(String transHash) async {
//   var url = '$bscExplorer$transHash';
//   final uri = Uri.parse(url);
//   debugPrint("Exploring transaction: $url");
//   if (await canLaunchUrl(uri)) {
//     await launchUrl(uri);
//   } else {
//     throw 'Could not launch $url';
//   }
// }

const bscExplorer = 'https://testnet.bscscan.com/tx/';

void exploreTransaction(String transHash) async {
  var uri = Uri.parse('$bscExplorer$transHash');
  debugPrint("Exploring transaction: ${uri.path}");
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    throw 'Could not launch $uri';
  }
}

void reTryCheckingTransactionResult(
    {required Web3Client web3Client,
    required String transactionHash,
    required Function(TransactionReceipt) onTransactionSuccess,
    Function? onTransactionFailed}) {
  reTry(function: () async {
    var trans = await web3Client.getTransactionReceipt(transactionHash);
    debugPrint("Transaction Hash: $transactionHash");
    debugPrint("Transaction status call after : $trans");
    if (trans != null) {
      if (trans.status!) {
        onTransactionSuccess.call(trans);
      } else {
        onTransactionFailed?.call(trans);
      }
      return true;
    } else {
      return false;
    }
  });
}

void reTry(
    {int currentTryIndex = 1,
    int tryCount = 30,
    required Function function}) async {
  await Future.delayed(const Duration(milliseconds: 1000));
  debugPrint('"===TryCount====> $currentTryIndex"');
  bool isSuccess;
  try {
    isSuccess = await function.call();
  } catch (_) {
    isSuccess = false;
  }
  tryCount -= tryCount;
  if (!isSuccess && tryCount > 0) {
    reTry(
      function: function,
      currentTryIndex: currentTryIndex + 1,
      tryCount: tryCount,
    );
  }
}
