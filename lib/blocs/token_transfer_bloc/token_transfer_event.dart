import 'package:crypto_wallet_traning/blocs/token_transfer_bloc/token_transfer_state.dart';
import 'package:crypto_wallet_traning/models/transaction_model.dart';

abstract class TokenTransEvt {}

class SendToken extends TokenTransEvt {
  TransactionModel transactionData;
  SendToken(this.transactionData);
}

class UpdateStatus extends TokenTransEvt {
  TransactionStatus newStatus;
  UpdateStatus(this.newStatus);
}
