import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'custom_inkwell.dart';

class AddressWidget extends StatelessWidget {
  final String address;
  const AddressWidget({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    String shorted = address.replaceRange(5, 37, '......');
    return CustomInkWell(
      width: 50,
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
