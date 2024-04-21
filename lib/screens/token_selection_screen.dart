import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_wallet_traning/blocs/token_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../config_env.dart';

class TokenSelectionScreen extends StatefulWidget {
  const TokenSelectionScreen({super.key});

  @override
  State<TokenSelectionScreen> createState() => _TokenSelectionScreenState();
}

class _TokenSelectionScreenState extends State<TokenSelectionScreen> {
  TokenBloc? get _tokenBloc => context.read<TokenBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Select Token'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(color: AppColor.subText),
                  hintText: 'Search Token',
                  contentPadding: EdgeInsets.only(left: 10),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<TokenBloc, TokenBlocState>(
                  bloc: _tokenBloc,
                  builder: (context, state) {
                    if (state.walletsToken != null) {
                      final data = state.walletsToken!.tokenData;
                      return ListView.builder(
                        itemBuilder: (context, item) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              onTap: () {
                                context.pop(data[item].token!.address);
                              },
                              textColor: Colors.white70,
                              leading: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: CachedNetworkImage(
                                    imageUrl: data[item].token!.logoURI,
                                    fit: BoxFit.contain),
                              ),
                              title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(data[item].token!.name),
                                    Text(
                                        '${data[item].balance!.toStringAsFixed(2)} ${data[item].token!.symbol}'),
                                    // Text(
                                    //     '${(data.balance!).toStringAsFixed(2)} ${data.token!.symbol}')
                                  ]),
                            ),
                          );
                        },
                        itemCount: data.length,
                      );
                    }
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
                  }),
            )
          ],
        ));
  }
}
