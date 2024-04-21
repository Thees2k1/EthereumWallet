class WalletModel {
  final String privateKey;
  final String walletName;
  final String walletAddress;
  final String nativeBalance;
  final bool isSelected;
  WalletModel({
    required this.privateKey,
    required this.walletName,
    required this.walletAddress,
    required this.nativeBalance,
    required this.isSelected,
  });

  WalletModel copyWith(String? privateKey, String? walletName,
      String? walletAddress, String? nativeBalance, bool? isSelected) {
    return WalletModel(
      privateKey: privateKey ?? this.privateKey,
      walletName: walletName ?? this.walletName,
      walletAddress: walletAddress ?? this.walletAddress,
      nativeBalance: nativeBalance ?? this.nativeBalance,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
