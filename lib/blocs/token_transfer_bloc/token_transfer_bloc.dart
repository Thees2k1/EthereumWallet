import 'dart:async';

import 'package:crypto_wallet_traning/blocs/token_transfer_bloc/token_transfer_event.dart';
import 'package:crypto_wallet_traning/blocs/token_transfer_bloc/token_transfer_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3dart/web3dart.dart';
import '../../config_env.dart';
import '../../repo/token_repo.dart';

class TokenTransferBloc extends Bloc<TokenTransEvt, TokenTransferState> {
  late final TokensRepo _repo;
  late Credentials _credentials;
  TokenTransferBloc(this._repo)
      : super(TokenTransferState(status: TransactionStatus.initial)) {
    _credentials = EthPrivateKey.fromHex(selectedPKey!);
    on<SendToken>(_onSendToken);
    on<UpdateStatus>(
      (event, emit) {
        emit(state.copyWith(status: event.newStatus));
      },
    );
  }

  Future<void> _onSendToken(
      SendToken event, Emitter<TokenTransferState> emit) async {
    emit(TokenTransferState(status: TransactionStatus.submitting));
    final String transactionHash;
    if (event.transactionData.tokenContract != nativeTokenAddress) {
      transactionHash = await _repo.transferToken(
          _credentials,
          event.transactionData.tokenContract,
          event.transactionData.amount,
          event.transactionData.receiverAddress, (from, to, amount) {
        onComplete();
      });
    } else {
      try {
        transactionHash = await _repo.transferNativeCoin(
            _credentials,
            event.transactionData.amount,
            event.transactionData.receiverAddress, (from, to, amount) {
          onComplete();
        });
      } catch (e) {
        throw (e.toString());
      }
    }

    emit(TokenTransferState(
        status: TransactionStatus.comfirming,
        transactionHash: transactionHash));
  }

  void onComplete() {
    add(UpdateStatus(TransactionStatus.completed));
  }
}
