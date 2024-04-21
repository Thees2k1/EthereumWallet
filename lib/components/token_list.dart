import 'package:cached_network_image/cached_network_image.dart';
import 'package:crypto_wallet_traning/config_env.dart';
import 'package:crypto_wallet_traning/utils/token_data.dart';
import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

class TokenList extends StatefulWidget {
  final List<TokenData> tokenData;
  const TokenList({super.key, required this.tokenData});

  @override
  State<TokenList> createState() => _TokenListState();
}

class _TokenListState extends State<TokenList>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  static const List<Tab> tabItems = <Tab>[
    Tab(
      text: 'Token',
    ),
    Tab(
      text: 'NFT',
    ),
  ];
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: tabItems.length, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverStack(
      insetOnOverlap: false,
      children: [
        SliverPositioned.fill(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColor.customBlack.withOpacity(0.7)),
          ),
        ),
        MultiSliver(children: [
          // ignore: prefer_const_constructors
          SliverAppBar(
            elevation: 0,
            iconTheme: const IconThemeData(color: AppColor.customGreen),
            pinned: true,
            backgroundColor: Colors.transparent,
            floating: true,
            toolbarHeight: kToolbarHeight,
            leadingWidth: 200,
            actions: [
              IconButton(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                onPressed: () {},
                icon: const Icon(
                  MaterialCommunityIcons.plus_circle_outline,
                ),
              )
            ],
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TabBar(
                labelColor: AppColor.customGreen,
                labelStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                controller: _tabController,
                indicatorColor: Colors.blue,
                tabs: tabItems,
              ),
            ),
          ),
          _currentIndex == 0
              ? SliverClip(
                  child: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final data = widget.tokenData[index];
                      return ListTile(
                        textColor: Colors.white70,
                        leading: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: CachedNetworkImage(
                                imageUrl: data.token!.logoURI,
                                fit: BoxFit.contain)),
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(data.token!.name),
                              Text(
                                  '${(data.balance!).toStringAsFixed(2)} ${data.token!.symbol}')
                            ]),
                        subtitle: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [Text('\$0.0'), Text('~\$0')]),
                      );
                    }, childCount: widget.tokenData.length),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return const ListTile();
                  }, childCount: 4),
                ),
        ])
      ],
    );
  }
}
