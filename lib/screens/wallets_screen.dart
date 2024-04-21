import 'package:crypto_wallet_traning/blocs/wallet_bloc/wallet_bloc.dart';
import 'package:crypto_wallet_traning/blocs/wallet_bloc/wallet_event.dart';
import 'package:crypto_wallet_traning/blocs/wallet_bloc/wallet_state.dart';
import 'package:crypto_wallet_traning/components/address_widget.dart';
import 'package:crypto_wallet_traning/models/walletmodel.dart';
import 'package:crypto_wallet_traning/repo/wallet_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:http/http.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

import '../config_env.dart';

class WalletsScreen extends StatefulWidget {
  final web3Client = Web3Client(web3HttpUrl, Client(), socketConnector: () {
    return IOWebSocketChannel.connect(web3RdpUrl).cast<String>();
  });
  WalletsScreen({super.key});

  @override
  State<WalletsScreen> createState() => _WalletsScreenState();
}

class _WalletsScreenState extends State<WalletsScreen> {
  late WalletsRepo _walletsRepo;
  late WalletBloc _walletBloc;
  @override
  void initState() {
    _walletsRepo = WalletsRepo(widget.web3Client);
    _walletBloc = WalletBloc(_walletsRepo);
    _walletBloc.add(LoadAllWallets());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Wallets'),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(MaterialIcons.add))
          ],
        ),
        body: BlocBuilder<WalletBloc, WalletsState>(
          bloc: _walletBloc,
          builder: (context, state) {
            if (state.wallets == null) {
              return Center(
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: LoadingIndicator(
                    colors: [
                      Colors.white.withOpacity(0.5),
                    ],
                    indicatorType: Indicator.ballPulse,
                    strokeWidth: 30,
                  ),
                ),
              );
            }
            if (state.error != null) {
              return Center(
                child: Text(state.error.toString()),
              );
            }
            return ListView.builder(
              itemBuilder: (context, item) {
                final wallet = state.wallets![item];
                return buildTile(wallet, () {
                  _walletBloc.add(ChangeSelection(wallet.privateKey));
                  Navigator.pop(context);
                });
              },
              itemCount: state.wallets!.length,
            );
          },
        ));
  }

  buildTile(WalletModel wallet, void Function()? tileTap) {
    return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: wallet.isSelected ? Colors.green : Colors.white24,
          ),
          borderRadius: BorderRadius.circular(5),
          color: wallet.isSelected
              ? Colors.blue.shade800.withOpacity(0.2)
              : const Color.fromARGB(32, 92, 91, 124),
        ),
        margin: const EdgeInsets.all(5),
        height: 95,
        alignment: Alignment.center,
        child: ListTile(
          onTap: tileTap,
          selected: wallet.isSelected,
          iconColor: Colors.white,
          textColor: Colors.white60,
          selectedColor: Colors.indigo.shade500,
          leading: CircleAvatar(
            child: RandomAvatar(wallet.walletName),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(wallet.walletName),
            ],
          ),
          subtitle: AddressWidget(address: wallet.walletAddress),
          trailing: wallet.isSelected
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text('${wallet.nativeBalance} BNB'),
                    const Icon(Icons.check),
                  ],
                )
              : Text('${wallet.nativeBalance} BNB'),
        ));
  }
}
