//tạo list privatekey;
//tạo model walletData;
// tạo walletsbloc , với mỗi privateKey trong listPK, lấy về walletAddress, Avatar, nativeBalance, nativeBalanceSymbol, lưu vào Floor

//to get wallet address we need private key  , so first we have to create a list of pkey, then with each one we call repo to get walletaddress first and then the navbalance, we set the first one is selected == true,
//

import 'dart:async';

import 'package:crypto_wallet_traning/blocs/wallet_bloc/wallet_event.dart';
import 'package:crypto_wallet_traning/blocs/wallet_bloc/wallet_state.dart';
import 'package:crypto_wallet_traning/config_env.dart';
import 'package:crypto_wallet_traning/repo/wallet_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/walletmodel.dart';
import '../app_event_bloc.dart';

class WalletBloc extends Bloc<WalletsBlocEvent, WalletsState> {
  late final WalletsRepo _repo;

  WalletBloc(this._repo) : super(WalletsState()) {
    on<LoadAllWallets>(_onLoadWallets);
    on<ChangeSelection>(_onChangeSelection);
  }

  Future<void> _onLoadWallets(
      LoadAllWallets event, Emitter<WalletsState> emit) async {
    try {
      List<WalletModel> wallets = await _repo.getAllWallets();
      emit(WalletsState(wallets: wallets));
    } catch (e) {
      emit(WalletsState(error: e.toString()));
    }
  }

  Future<void> _onChangeSelection(
      ChangeSelection event, Emitter<WalletsState> emit) async {
    if (event.privateKey != selectedPKey) {
      final res = await _repo.changeSelection(event.privateKey);
      if (res) {
        selectedPKey = event.privateKey;
        AppEventBloc()
            .emitEvent(BlocEvent(EventName.changeSelectedWallet, selectedPKey));
      }
    }
  }
}
