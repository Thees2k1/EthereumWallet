import 'package:crypto_wallet_traning/config_env.dart';
import 'package:crypto_wallet_traning/repo/token_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'blocs/token_bloc.dart';
import 'router.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final web3Client = Web3Client(web3HttpUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(web3RdpUrl).cast<String>();
    });
    final TokensRepo repo = TokensRepo(web3Client);
    return BlocProvider<TokenBloc>(
      create: (_) => TokenBloc(repo)..add(LoadTokenInfo()),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: AppColor.secondaryColor,
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColor.primaryColor,
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(),
              bodyMedium: TextStyle(),
              titleMedium: TextStyle(),
            ).apply(bodyColor: Colors.white, displayColor: Colors.white)),
        routerConfig: router,
      ),
    );
  }
}
