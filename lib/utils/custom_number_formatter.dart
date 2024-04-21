import 'dart:math';

import 'package:web3dart/web3dart.dart';

class CustomNumberFormatter {
  static double fromWeiToEthFormatted(BigInt weiAmount) {
    return EtherAmount.fromBigInt(EtherUnit.wei, weiAmount)
        .getValueInUnit(EtherUnit.ether);
  }

  static BigInt fromDoubleEthToWei(double value) {
    return BigInt.from(value * pow(10, 18));
  }
}
