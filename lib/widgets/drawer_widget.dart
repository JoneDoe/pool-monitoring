import 'package:flutter/material.dart';

import '../constants.dart';
import '../pages/my_wallet_page.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: secondaryColor,
      child: Column(
        children: [
          const DrawerHeader(
            child: Text(
              'Menu',
              style: TextStyle(color: textColor),
            ),
          ),
          // const ListTile(
          //   leading: Icon(Icons.home, color: textColor),
          //   title: Text(
          //     'Home',
          //     style: TextStyle(color: textColor),
          //   ),
          // ),
          ListTile(
            leading: const Icon(Icons.wallet, color: textColor),
            title: const Text(
              'My wallets',
              style: TextStyle(color: textColor),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const MyWalletsPage()),
              );
            },
          ),
          const ListTile(
            leading: Icon(Icons.settings, color: textColor),
            title: Text(
              'Settings',
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}