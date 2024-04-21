class TransactionModel {
  final String tokenContract;
  final String senderAddress;
  final String receiverAddress;
  final double amount;
  final maxFee = 0.01;
  const TransactionModel(
      {required this.tokenContract,
      required this.senderAddress,
      required this.receiverAddress,
      required this.amount});
}
