import 'package:crypto_wallet_traning/blocs/token_bloc.dart';
import 'package:crypto_wallet_traning/components/chart_card.dart';
import 'package:crypto_wallet_traning/components/custom_inkwell.dart';
import 'package:crypto_wallet_traning/components/main_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:crypto_wallet_traning/components/token_list.dart';
import 'package:crypto_wallet_traning/repo/token_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

import '../config_env.dart';

class HomePage extends StatefulWidget {
  final web3Client = Web3Client(web3HttpUrl, Client(), socketConnector: () {
    return IOWebSocketChannel.connect(web3RdpUrl).cast<String>();
  });

  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final TokensRepo tokenRepo;
  TokenBloc? get _tokenBloc => context.read<TokenBloc>();
  @override
  void initState() {
    tokenRepo = TokensRepo(
      widget.web3Client,
    );
    //_tokenBloc = TokenBloc(tokenRepo);
    //_tokenBloc.add(LoadTokenInfo());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: kToolbarHeight * 2.5,
        leading: Padding(
            padding: const EdgeInsets.all(8),
            child: CustomInkWell(
                roundedRadius: 8,
                color: AppColor.customGreen,
                onTap: () {},
                child: const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 38,
                        height: 38,
                        child: CircleAvatar(
                          foregroundImage: AssetImage('assets/images/BSC.png'),
                        ),
                      ),
                      Text(
                        'BSC',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                          width: 38,
                          height: 38,
                          child: Image(
                              image:
                                  AssetImage('assets/images/chainblock.png'))),
                    ],
                  ),
                ))

            // Container(
            //   decoration: const BoxDecoration(
            //     color: AppColor.customGreen,
            //     borderRadius: BorderRadius.all(
            //       Radius.circular(8),
            //     ),
            //   ),
            // ),
            ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.search),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.notifications),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.person_off_outlined),
          ),
        ],
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage("assets/images/background.jpg"),
        )),
        child: BlocBuilder<TokenBloc, TokenBlocState>(
          bloc: _tokenBloc,
          builder: (context, state) {
            final walletsToken = state.walletsToken;
            if (walletsToken == null) {
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
            List<Widget> cards = [
              MainCard(
                walletsToken: walletsToken,
                onNameTap: () {
                  context.go('/wallets');
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (BuildContext context) => WalletsScreen()));
                },
              ),
              ChartCard(chartData: state.tokenBalances!),
            ];
            return RefreshIndicator(
              onRefresh: () async {
                _tokenBloc!.add(ReloadInfo());
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 15),
                    sliver: SliverToBoxAdapter(
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 250,
                          viewportFraction: 0.92,
                          initialPage: 0,
                          enableInfiniteScroll: true,
                          reverse: false,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.2,
                          //onPageChanged: callbackFunction,
                          scrollDirection: Axis.horizontal,
                        ),
                        items: cards,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(15),
                    sliver: TokenList(tokenData: walletsToken.tokenData),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
