import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_wallet_traning/blocs/token_transfer_bloc/token_transfer_bloc.dart';
import 'package:crypto_wallet_traning/blocs/token_transfer_bloc/token_transfer_event.dart';
import 'package:crypto_wallet_traning/blocs/token_transfer_bloc/token_transfer_state.dart';
import 'package:crypto_wallet_traning/components/custom_inkwell.dart';
import 'package:crypto_wallet_traning/config_env.dart';
import 'package:crypto_wallet_traning/models/token_model.dart';
import 'package:crypto_wallet_traning/models/transaction_model.dart';
import 'package:crypto_wallet_traning/utils/contract_utils.dart';
import 'package:crypto_wallet_traning/utils/token_data.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart';

import '../repo/token_repo.dart';

class SendTokenScreen extends StatefulWidget {
  final TokenModel walletsToken;

  final web3Client = Web3Client(web3HttpUrl, Client(), socketConnector: () {
    return IOWebSocketChannel.connect(web3RdpUrl).cast<String>();
  });
  SendTokenScreen({super.key, required this.walletsToken});

  @override
  State<SendTokenScreen> createState() => _SendTokenScreenState();
}

class _SendTokenScreenState extends State<SendTokenScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TokensRepo tokenRepo;
  late TokenTransferBloc _bloc;
  final _addressInputController = TextEditingController();
  final _amountInputController = TextEditingController();
  late TokenModel _walletsToken;
  String selectedTokenAddress = nativeTokenAddress;
  late TokenData selectedToken;
  @override
  void initState() {
    _walletsToken = widget.walletsToken;
    tokenRepo = TokensRepo(
      widget.web3Client,
    );
    _bloc = TokenTransferBloc(tokenRepo);
    for (var item in _walletsToken.tokenData) {
      if (item.token!.address == selectedTokenAddress) {
        selectedToken = item;
        break;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (selectedTokenAddress != nativeTokenAddress) {
      for (var item in _walletsToken.tokenData) {
        if (item.token!.address == selectedTokenAddress) {
          selectedToken = item;
        }
      }
    }
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Send token'),
          centerTitle: true,
          actions: [
            TextButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final transactioninfo = TransactionModel(
                        tokenContract: selectedTokenAddress,
                        senderAddress: widget.walletsToken.walletAddress,
                        receiverAddress: _addressInputController.value.text,
                        amount:
                            double.parse(_amountInputController.value.text));
                    showInfoModal(transactioninfo);
                  }
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                child: const Text('Next'))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Text('Choose token'),
            ),
            CustomInkWell(
              color: Colors.black12,
              padding: const EdgeInsets.all(8.0),
              onTap: () {
                context.push('/token_selection').then((value) {
                  if (value != null) {
                    selectedTokenAddress = value as String;
                    setState(() {});
                  }
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white.withOpacity(0.3),
                        child: CachedNetworkImage(
                            imageUrl: selectedToken.token!.logoURI),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(selectedToken.token!.name),
                      ),
                    ],
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_forward_ios)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text('Receipt Address'),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () async {
                            final res =
                                await context.push<String>('/qr_scanner');
                            if (res != null) {
                              _addressInputController.text = res.substring(9);
                            }
                          },
                          icon: const Icon(Icons.qr_code)),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.contact_phone))
                    ],
                  )
                ],
              ),
            ),
            Container(
              color: Colors.black12,
              child: TextFormField(
                controller: _addressInputController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  final valuetosub = value.toLowerCase();
                  if (valuetosub == _walletsToken.walletAddress) {
                    return 'This is the sender address';
                  }
                  return null;
                },
                decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    labelStyle: const TextStyle(color: AppColor.subText),
                    labelText: 'Input the receive address',
                    contentPadding: const EdgeInsets.only(left: 10),
                    suffixIcon: IconButton(
                        onPressed: () {
                          _addressInputController.text = '';
                        },
                        icon: const Icon(
                          Icons.clear,
                          color: AppColor.mainText,
                        ))),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              child: Text('Amount'),
            ),
            Container(
              color: Colors.black12,
              child: TextFormField(
                controller: _amountInputController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the amount';
                  }
                  final amount = double.parse(value);
                  if (amount > double.parse(_walletsToken.nativeBalance)) {
                    return 'the amount is over token balance';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: const UnderlineInputBorder(),
                  labelStyle: const TextStyle(color: AppColor.subText),
                  labelText: 'Input the amount',
                  contentPadding: const EdgeInsets.only(left: 10),
                  suffixIcon: TextButton(
                    child: const Text(
                      'MAX',
                      style: TextStyle(color: AppColor.mainText),
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              child: Text(
                  'Current balance: ${selectedToken.balance} ${selectedToken.token!.symbol}'),
            ),
          ]),
        ),
      ),
    );
  }

  void showInfoModal(TransactionModel transactioninfo) {
    showModalBottomSheet(
        backgroundColor: AppColor.secondaryColor,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
            height: 320,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: BlocBuilder<TokenTransferBloc, TokenTransferState>(
                  bloc: _bloc,
                  builder: (context, state) {
                    if (state.status == TransactionStatus.completed) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Text(
                            'Transaction',
                            style: TextStyle(
                                color: AppColor.subText, fontSize: 20),
                          ),
                          const Icon(
                            Icons.done,
                            size: 30,
                          ),
                          Center(
                            child: CustomInkWell(
                              color: Colors.green,
                              roundedRadius: 10,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              onTap: () {
                                exploreTransaction(state.transactionHash!);
                              },
                              child: Center(
                                child: Text(
                                    'Your transaction (${state.transactionHash!}) is completed!, Check your explore'),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    if (state.status == TransactionStatus.error) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Text(
                            'Transaction',
                            style: TextStyle(
                                color: AppColor.subText, fontSize: 20),
                          ),
                          const Icon(
                            Icons.error_outline_outlined,
                            size: 30,
                          ),
                          Center(
                            child: CustomInkWell(
                              color: Colors.green,
                              roundedRadius: 10,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              onTap: () {},
                              child: Center(
                                child: Text(
                                    'Error occur!, description: ${state.error}'),
                              ),
                            ),
                            // child: Container(
                            //   height: 100,
                            //   padding: const EdgeInsets.all(30),
                            //   color: Colors.amber,
                            //   child: Text(
                            //       'Trans Hash: ${state.transactionHash}'),
                            // ),
                          ),
                        ],
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Text(
                          'Transaction',
                          style:
                              TextStyle(color: AppColor.subText, fontSize: 20),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                              color: AppColor.customGrey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(children: [
                            textInfo(
                                label: 'Amount',
                                content:
                                    '${transactioninfo.amount.toString()} ${selectedToken.token!.symbol}'),
                            textInfo(
                                label: 'From Address',
                                content:
                                    transactioninfo.senderAddress.toString()),
                            textInfo(
                                label: 'To Address',
                                content:
                                    transactioninfo.receiverAddress.toString()),
                            textInfo(
                                label: 'Max Fee',
                                content:
                                    '${transactioninfo.maxFee.toString()} BNB'),
                          ]),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlinedButton(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            ElevatedButton(
                              child: state.status == TransactionStatus.initial
                                  ? const Text('Confirm')
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        state.status ==
                                                TransactionStatus.submitting
                                            ? const Text('Submitting...')
                                            : const Text('Comfirming'),
                                        const SizedBox(
                                            height: 15,
                                            width: 15,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: AppColor.mainText,
                                            ))
                                      ],
                                    ),
                              onPressed: () {
                                _bloc.add(SendToken(transactioninfo));
                              },
                            ),
                          ],
                        )
                      ],
                    );
                  }),
            ),
          );
        });
  }

  Widget textInfo({required String label, required String content}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColor.subText),
          ),
          SizedBox(
            width: 200,
            child: Text(
              content,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColor.mainText,
                overflow: TextOverflow.clip,
              ),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
