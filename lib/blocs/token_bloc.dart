import 'dart:async';

import 'package:crypto_wallet_traning/config_env.dart';
import 'package:crypto_wallet_traning/database/drift_database/database.dart';
import 'package:crypto_wallet_traning/repo/token_repo.dart';
import 'package:crypto_wallet_traning/utils/chart_data.dart';
import 'package:drift/isolate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3dart/web3dart.dart';
import '../models/token_model.dart';
import '../utils/token_data.dart';
import 'app_event_bloc.dart';

class TokenBloc extends Bloc<TokenBlocEvt, TokenBlocState> {
  // ignore: unused_field
  late final StreamSubscription<BlocEvent> _subChangeSelectedWallet;
  late final TokensRepo _repo;

  late Credentials _credentials;

  TokenBloc(this._repo) : super(TokenBlocState()) {
    _credentials = EthPrivateKey.fromHex(selectedPKey!);
    _subChangeSelectedWallet = AppEventBloc().listenEvent(
        eventName: EventName.changeSelectedWallet,
        handler: _changeSelectionHandle);
    on<LoadTokenInfo>(
      _onLoadTokenInfo,
    );
    on<ReloadInfo>(_onReloadInfo);
    // on<GetTokensInfo>(
    //   _onGetTokensInfo,
    // );
  }
  Future<void> _onLoadTokenInfo(
      LoadTokenInfo event, Emitter<TokenBlocState> emit) async {
    final res = await loadInfoWithIsolate({
      'repo': _repo,
      'credentials': _credentials,
      'selectedKey': selectedPKey!
    });
    emit(res);
    // List<ChartData> tokensPercentage = [];
    // List<TokenData> tokenData = [];
    // double totalBalances = 0;
    // try {
    //   String walletAddress = _repo.getCurrentWalletAddress(_credentials);
    //   final walletName =
    //       await database!.walletDao.findWalletName(selectedPKey!);
    //   String nativeBalance =
    //       (await _repo.getNativeBalance(walletAddress)).toStringAsFixed(3);

    //   for (int i = 0; i < tokens.length; i++) {
    //     try {
    //       if (tokens[i].symbol == "BNB") {
    //         final balance = double.parse(nativeBalance);
    //         tokenData.add(TokenData(token: tokens[i], balance: balance));
    //       }
    //       final balance =
    //           await _repo.getTokenBalance(walletAddress, tokens[i].address);
    //       totalBalances += balance;
    //       tokenData.add(TokenData(token: tokens[i], balance: balance));
    //     } catch (_) {
    //       tokenData.add(TokenData(token: tokens[i], balance: 0));
    //     }
    //   }
    //   tokenData.sort((a, b) => a.balance!.compareTo(b.balance!));
    //   tokenData = tokenData.reversed.toList();
    //   double otherTokenBalance = 0;
    //   for (int i = 0; i < tokenData.length; i++) {
    //     if (i < 7) {
    //       tokensPercentage.add(ChartData(
    //           label: tokenData[i].token!.symbol,
    //           value: tokenData[i].balance,
    //           percentage: (tokenData[i].balance! / totalBalances * 100)
    //               .toStringAsFixed(2)));
    //     } else {
    //       otherTokenBalance += tokenData[i].balance ?? 0;
    //     }
    //   }
    //   tokensPercentage.add(ChartData(
    //       label: 'Others',
    //       value: otherTokenBalance,
    //       percentage:
    //           (otherTokenBalance / totalBalances * 100).toStringAsFixed(2)));

    //   TokenModel token = TokenModel(
    //     walletName: walletName ?? 'No name',
    //     walletAddress: walletAddress,
    //     nativeBalance: nativeBalance,
    //     tokenData: tokenData,
    //   );
    //   emit(
    //       TokenBlocState(walletsToken: token, tokenBalances: tokensPercentage));
    // } catch (e) {
    //   emit(TokenBlocState(error: 'Error: $e'));
    // }
  }

  _changeSelectionHandle(BlocEvent event) {
    _credentials = EthPrivateKey.fromHex(event.value);
    add(ReloadInfo());
  }

  Future<void> _onReloadInfo(
      ReloadInfo event, Emitter<TokenBlocState> emit) async {
    emit(TokenBlocState());
    add(LoadTokenInfo());
  }
}

Future<TokenBlocState> loadInfoWithIsolate(Map<String, dynamic> params) async {
  final connection = await database!.serializableConnection();

  params.addAll({'connection': connection});
  final res = compute(_getTokenInfo, params);
  return res;
  //return Isolate.run(() => _getTokenInfo(repo, credentials, selectedKey));
}

Future<TokenBlocState> _getTokenInfo(Map<String, dynamic> params) async {
  final TokensRepo repo = params['repo'];
  final credentials = params['credentials'];
  final selectedKey = params['selectedKey'];
  final databaseForIsolate = MyDatabase(await params['connection'].connect());
  List<ChartData> tokensPercentage = [];
  List<TokenData> tokenData = [];
  double totalBalances = 0;
  try {
    String walletAddress = repo.getCurrentWalletAddress(credentials);
    final wName = await databaseForIsolate.findWalletName(selectedKey);
    String nativeBalance =
        (await repo.getNativeBalance(walletAddress)).toStringAsFixed(3);

    for (int i = 0; i < tokens.length; i++) {
      try {
        if (tokens[i].symbol == "BNB") {
          final balance = double.parse(nativeBalance);
          tokenData.add(TokenData(token: tokens[i], balance: balance));
          continue;
        }
        final balance =
            await repo.getTokenBalance(walletAddress, tokens[i].address);
        totalBalances += balance;
        tokenData.add(TokenData(token: tokens[i], balance: balance));
      } catch (_) {
        tokenData.add(TokenData(token: tokens[i], balance: 0));
      }
    }
    tokenData.sort((a, b) => a.balance!.compareTo(b.balance!));
    tokenData = tokenData.reversed.toList();
    double otherTokenBalance = 0;
    for (int i = 0; i < tokenData.length; i++) {
      if (i < 7) {
        tokensPercentage.add(ChartData(
            label: tokenData[i].token!.symbol,
            value: tokenData[i].balance,
            percentage: (tokenData[i].balance! / totalBalances * 100)
                .toStringAsFixed(2)));
      } else {
        otherTokenBalance += tokenData[i].balance ?? 0;
      }
    }
    tokensPercentage.add(ChartData(
        label: 'Others',
        value: otherTokenBalance,
        percentage:
            (otherTokenBalance / totalBalances * 100).toStringAsFixed(2)));

    TokenModel token = TokenModel(
      walletName: wName,
      walletAddress: walletAddress,
      nativeBalance: nativeBalance,
      tokenData: tokenData,
    );
    return TokenBlocState(walletsToken: token, tokenBalances: tokensPercentage);
  } catch (e) {
    return TokenBlocState(error: e.toString());
  }
}

class TokenBlocState {
  final Object? error;
  final TokenModel? walletsToken;
  final List<ChartData>? tokenBalances;

  TokenBlocState({this.error, this.walletsToken, this.tokenBalances});

  TokenBlocState copyWith({
    Object? error,
    TokenModel? walletsToken,
    List<ChartData>? tokenBalances,
  }) =>
      TokenBlocState(
        error: error ?? this.error,
        walletsToken: walletsToken ?? this.walletsToken,
        tokenBalances: tokenBalances ?? this.tokenBalances,
      );
}

abstract class TokenBlocEvt {}

class LoadTokenInfo extends TokenBlocEvt {}

class ReloadInfo extends TokenBlocEvt {}
