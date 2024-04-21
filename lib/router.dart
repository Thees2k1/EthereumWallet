import 'package:crypto_wallet_traning/models/token_model.dart';
import 'package:crypto_wallet_traning/screens/dashboard_page.dart';
import 'package:crypto_wallet_traning/screens/qrcode_scanner_screen.dart';
import 'package:crypto_wallet_traning/screens/send_token_screen.dart';
import 'package:crypto_wallet_traning/screens/token_selection_screen.dart';
import 'package:crypto_wallet_traning/screens/wallets_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const DashBoadPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'wallets',
          builder: (BuildContext context, GoRouterState state) {
            return WalletsScreen();
          },
        ),
        GoRoute(
          path: 'sendtoken',
          builder: (context, state) {
            return SendTokenScreen(walletsToken: state.extra as TokenModel);
          },
        ),
        GoRoute(
          path: 'qr_scanner',
          builder: (context, state) {
            return const QRCodeScannerScreen();
          },
        ),
        GoRoute(
          path: 'token_selection',
          builder: (context, state) {
            return const TokenSelectionScreen();
          },
        ),
      ],
    ),
  ],
);
