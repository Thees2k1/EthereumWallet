import 'package:crypto_wallet_traning/utils/token_data.dart';

class TokenModel {
  final String walletName;
  final String walletAddress;
  final String nativeBalance;
  List<TokenData> tokenData;
  TokenModel({
    required this.walletName,
    required this.walletAddress,
    required this.nativeBalance,
    required this.tokenData,
  });

  TokenModel copyWith(String? walletName, String? walletAddress,
      String? nativeBalance, List<TokenData>? tokenData) {
    return TokenModel(
      walletName: walletName ?? this.walletName,
      walletAddress: walletAddress ?? this.walletAddress,
      nativeBalance: nativeBalance ?? this.nativeBalance,
      tokenData: tokenData ?? this.tokenData,
    );
  }
}
