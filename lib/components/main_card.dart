import 'package:crypto_wallet_traning/components/custom_card.dart';
import 'package:crypto_wallet_traning/components/custom_inkwell.dart';
import 'package:crypto_wallet_traning/models/token_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:random_avatar/random_avatar.dart';

class MainCard extends StatefulWidget {
  final TokenModel walletsToken;
  final void Function()? onNameTap;
  const MainCard({super.key, required this.walletsToken, this.onNameTap});

  @override
  State<MainCard> createState() => _MainCardState();
}

class _MainCardState extends State<MainCard> {
  bool visible = true;
  late TokenModel _walletsToken;
  @override
  void initState() {
    _walletsToken = widget.walletsToken;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomInkWell(
                padding: const EdgeInsets.all(5),
                color: Colors.white.withOpacity(0.3),
                roundedRadius: 5,
                width: 170,
                height: 35,
                onTap: widget.onNameTap,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: RandomAvatar(_walletsToken.walletName),
                    ),
                    Text(_walletsToken.walletName),
                    const Icon(
                      Icons.arrow_drop_down_outlined,
                      size: 20,
                    ),
                  ],
                ),
              ),
              _buildAddressWidget(_walletsToken.walletAddress),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildBalanceInfor('0', _walletsToken.nativeBalance, '0', () {
                setState(() {
                  visible = !visible;
                });
              }),
              SizedBox(
                width: 70,
                height: 70,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.3),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAction(Icons.send, 'Send', () {
                  context.go('/sendtoken', extra: _walletsToken);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => SendTokenScreen(
                  //               walletsToken: _walletsToken,
                  //             )));
                }),
                _buildAction(Icons.arrow_downward, 'Receive', () {}),
                _buildAction(Icons.shop, 'Buy', () {}),
                _buildAction(Icons.swap_calls, 'Swap', () {}),
                _buildAction(Icons.plus_one, 'Earn', () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildBalanceInfor(String balance, String nativeBalance, String staked,
      void Function()? onPress) {
    const String hided = "*****";
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          visible ? '\$$balance' : hided,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            RichText(
              text: TextSpan(
                  style: const TextStyle(fontSize: 18),
                  children: <TextSpan>[
                    TextSpan(
                      text: '${visible ? nativeBalance : hided} BNB',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' ~ \$${visible ? '0.0' : hided}',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ]),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 20,
              width: 20,
              child: IconButton(
                padding: const EdgeInsets.all(0),
                iconSize: 22,
                onPressed: onPress,
                icon: Icon(
                  visible ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          '${visible ? staked : hided} BNB Staked ~ \$${visible ? '0.0' : hided}',
          style: const TextStyle(fontSize: 18),
        )
      ],
    );
  }

  Widget _buildAction(IconData icon, String label, void Function()? onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CustomInkWell(
          color: Colors.white.withOpacity(0.3),
          height: 40,
          width: 40,
          roundedRadius: 20,
          onTap: onTap,
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        Text(
          label,
        ),
      ],
    );
  }

  Widget _buildAddressWidget(String address) {
    String shorted = address.replaceRange(5, 37, '......');
    return CustomInkWell(
      color: Colors.transparent,
      roundedRadius: 20,
      padding: const EdgeInsets.all(3),
      height: 40,
      onTap: () {
        Fluttertoast.showToast(msg: 'Coppied address');
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            shorted,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          SizedBox(
            width: 30,
            child: IconButton(
                iconSize: 15,
                onPressed: () {},
                icon: const Icon(
                  Icons.copy,
                )),
          )
        ],
      ),
    );
  }
}
