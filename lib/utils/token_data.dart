import 'package:crypto_wallet_traning/utils/supported_token.dart';

class TokenData {
  final SupportedToken? token;
  final double? balance;
  TokenData({this.token, this.balance});
  TokenData copyWith({SupportedToken? token, double? balance}) {
    return TokenData(
        token: token ?? this.token, balance: balance ?? this.balance);
  }
}
