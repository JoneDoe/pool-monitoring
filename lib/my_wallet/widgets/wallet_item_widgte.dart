import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pool_monitoring/extensions/string_extension.dart';

import '../../constants/colors.dart';
import '../models/wallet_entry.dart';

class WalletItemWidget extends StatelessWidget {
  const WalletItemWidget({super.key, required this.wallet});

  final WalletEntryItem wallet;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(158, 255, 3, 11),
            Color.fromARGB(158, 214, 85, 5),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          tileMode: TileMode.clamp,
        ),
      ),
      height: 70,
      child: ListTile(
        onLongPress: () => onLongPress(context, wallet.token),
        contentPadding: const EdgeInsets.only(left: 10.0),
        title: Text(
          wallet.name.capitalize(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        subtitle: Text(
          wallet.token.length > 40 ? shorten(wallet.token) : wallet.token,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: textColor,
          ),
        ),
        leading: Image.asset(
          'assets/${wallet.name}.webp',
          height: 50,
        ),
      ),
    );
  }

  void onLongPress(BuildContext context, String token) {
    Clipboard.setData(ClipboardData(text: token));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Token copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String shorten(String text) {
    return '${text.substring(0, 12)}......${text.substring(text.length - 10, text.length)}';
  }
}
