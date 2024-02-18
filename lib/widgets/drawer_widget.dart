import 'package:flutter/material.dart';

import '/constants.dart';
import '/pages/my_wallet_page.dart';
import '/pages/settings_page.dart';

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
          ListTile(
            leading: const Icon(Icons.settings, color: textColor),
            title: const Text(
              'Settings',
              style: TextStyle(color: textColor),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
