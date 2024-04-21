import 'package:crypto_wallet_traning/database/drift_database/database.dart';
import 'package:crypto_wallet_traning/utils/supported_token.dart';
import 'package:flutter/material.dart';

String web3HttpUrl =
    "https://rpc.ankr.com/bsc_testnet_chapel/f4824c588880244f9abe2a1af8253a4e932ff88a9bd4ac6965bd54740e6ee582/";
String web3RdpUrl =
    "wwss://rpc.ankr.com/bsc_testnet_chapel/ws/f4824c588880244f9abe2a1af8253a4e932ff88a9bd4ac6965bd54740e6ee582/";
String nativeTokenAddress = "0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd";

String walletPrivateKey =
    "bab86aaa751e8867a9da8c448704a2a8936e319509aee0354547bce6052ef92c";

List<String> walletPrivateKeys = [
  'bab86aaa751e8867a9da8c448704a2a8936e319509aee0354547bce6052ef92c',
  '3b1f6570342a1165ebd8ccac3441cfbc45e0d1c55c688ffe468c711c864b4f5f',
];

List<String> walletName = [
  'MagicLab',
  'TongNguyenThe',
];

// List<Wallet> wallets = [
//   Wallet(
//     key: 0,
//     privateKey:
//         'bab86aaa751e8867a9da8c448704a2a8936e319509aee0354547bce6052ef92c',
//     address: '0x2797EAe157DE9aAB22E8AB7B7bbb4aC061A94c85',
//     name: 'MagicLab',
//     isSelected: true,
//   ),
//   Wallet(
//     key: 1,
//     privateKey:
//         '3b1f6570342a1165ebd8ccac3441cfbc45e0d1c55c688ffe468c711c864b4f5f',
//     address: '0x80e0Fbf6E74520e04aEbbAC4e9C209473A7c9d55',
//     name: 'TongNguyenThe',
//     isSelected: false,
//   ),
// ];

//AppDatabase? database;
MyDatabase? database;

String? selectedPKey;
// ignore: non_constant_identifier_names
var DAI = const SupportedToken(
    address: "0xb6a15e5e795326306e9a8bc9611173cafb99dd37",
    decimals: 18,
    chainId: 97,
    symbol: "DAI",
    name: "Dai Stablecoin",
    logoURI:
        "https://assets.coingecko.com/coins/images/9956/thumb/4943.png?1636636734");
// ignore: non_constant_identifier_names
var BUSD = const SupportedToken(
    address: "0x69264a1a4fe2fbbc0a1c905f5d79f870931e3d69",
    decimals: 18,
    chainId: 97,
    symbol: "BUSD",
    name: "Binance USD",
    logoURI:
        "https://assets.coingecko.com/coins/images/9576/thumb/BUSD.png?1568947766");
// ignore: non_constant_identifier_names
var USDT = const SupportedToken(
    address: "0xf728066c846518417d2123d06bfbeeffe723387b",
    decimals: 18,
    chainId: 97,
    symbol: "USDT",
    name: "Tether USD",
    logoURI:
        "https://assets.coingecko.com/coins/images/325/thumb/Tether-logo.png?1598003707");
// ignore: non_constant_identifier_names
var ETH = const SupportedToken(
    address: "0xe35ec1d0cd973b313b6861d526488fd551112777",
    decimals: 18,
    chainId: 97,
    symbol: "ETH",
    name: "Ethereum",
    logoURI:
        "https://assets.coingecko.com/coins/images/2518/thumb/weth.png?1628852295");
// ignore: non_constant_identifier_names
var WBNB = const SupportedToken(
    address: "0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd",
    decimals: 18,
    chainId: 97,
    symbol: "WBNB",
    name: "Wrapped BNB",
    logoURI:
        "https://assets.coingecko.com/coins/images/12591/thumb/binance-coin-logo.png?1600947313");

// ignore: non_constant_identifier_names
var BNB = const SupportedToken(
    address: "0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd",
    decimals: 18,
    chainId: 97,
    symbol: "BNB",
    name: "Binance Coin",
    logoURI:
        "https://assets.coingecko.com/coins/images/12591/thumb/binance-coin-logo.png?1600947313");

// ignore: non_constant_identifier_names
var NATIVE_TOKEN = const SupportedToken(
    address: "0x0",
    decimals: 18,
    chainId: 97,
    symbol: "BNB",
    name: "BNB",
    logoURI:
        "https://assets.coingecko.com/coins/images/12591/thumb/binance-coin-logo.png?1600947313");

//////////////////////////
// ignore: non_constant_identifier_names
var ALPHA = const SupportedToken(
    address: "0xA40bF32b1BCDeE1b62A1b75a6d84d0ec9D1Db88b",
    decimals: 18,
    chainId: 97,
    symbol: "Alpha",
    name: "Alpha Labz",
    logoURI:
        "https://assets.coingecko.com/coins/images/27034/thumb/200x200_%281%29.png?1661499419");

// ignore: non_constant_identifier_names
var ALTI = const SupportedToken(
    address: "0x195e3087ea4d7eec6e9c37e9640162Fe32433D5e",
    decimals: 18,
    chainId: 97,
    symbol: "ALTI",
    name: "Altimatum",
    logoURI:
        "https://assets.coingecko.com/coins/images/26772/thumb/footerlogo.png?1660048555");

// ignore: non_constant_identifier_names
var ANRX = const SupportedToken(
    name: "AnRKey X",
    symbol: "ANRX",
    address: "0xE2e7329499E8DDb1f2b04EE4B35a8d7f6881e4ea",
    chainId: 56,
    decimals: 18,
    logoURI:
        "https://assets.coingecko.com/coins/images/13415/thumb/anrkey.jpg?1608311301");

// ignore: non_constant_identifier_names
var ARC = const SupportedToken(
    name: "AnRKey X",
    symbol: "ANRX",
    address: "0x2DEdE4b234A735cB76A00dF33588f2B8F0AA0b6a",
    chainId: 56,
    decimals: 18,
    logoURI:
        "https://assets.coingecko.com/coins/images/26770/thumb/rsz_1ezgue9tq_400x400.png?1660047420");

// ignore: non_constant_identifier_names
var BACK = const SupportedToken(
    name: "DollarBack",
    symbol: "BACK",
    address: "0xF2cAaBf67f99D3AC5D0A4529722cFB874c9b35Bf",
    chainId: 56,
    decimals: 18,
    logoURI:
        "https://assets.coingecko.com/coins/images/26973/thumb/logoring200x200.png?1661153856");

List<SupportedToken> tokens = [
  BNB,
  USDT,
  BUSD,
  ETH,
  DAI,
  WBNB,
  ALPHA,
  ALTI,
  ANRX,
  ARC,
  BACK,
];

String recipientAddress = "0x80e0Fbf6E74520e04aEbbAC4e9C209473A7c9d55";

class AppColor {
  static const Color primaryColor = Color(0xFF252532);
  static const Color secondaryColor = Color(0xFF20202b);
  static const Color customBlack = Color(0xFF1b1b28);
  static const Color customGrey = Color(0xFF292936);
  static const Color customGreen = Color.fromARGB(255, 44, 188, 52);
  static const Color subText = Colors.white54;
  static const Color mainText = Colors.white;
}
