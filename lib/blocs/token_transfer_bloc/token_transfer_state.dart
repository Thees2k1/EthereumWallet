enum TransactionStatus {
  initial,
  submitting,
  comfirming,
  completed,
  error,
}

class TokenTransferState {
  final TransactionStatus? status;
  final String? transactionHash;
  final Object? error;
  TokenTransferState({this.transactionHash, this.error, this.status});

  TokenTransferState copyWith({
    TransactionStatus? status,
    String? transactionHash,
    Object? error,
  }) =>
      TokenTransferState(
        transactionHash: transactionHash ?? this.transactionHash,
        status: status ?? this.status,
        error: error ?? this.error,
      );
}
