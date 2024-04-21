class SupportedToken {
  final String name;
  final String symbol;
  final String address;
  final double chainId;
  final double decimals;
  final String logoURI;
  const SupportedToken({
    required this.name,
    required this.symbol,
    required this.address,
    required this.chainId,
    required this.decimals,
    required this.logoURI,
  });
  SupportedToken copyWith(String? name, String? symbol, String? address,
      double? chainId, double? decimals, String? logoURI) {
    return SupportedToken(
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      address: address ?? this.address,
      chainId: chainId ?? this.chainId,
      decimals: decimals ?? this.decimals,
      logoURI: logoURI ?? this.logoURI,
    );
  }
}
