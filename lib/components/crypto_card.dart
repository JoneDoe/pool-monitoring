import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../extensions/number_extension.dart';
import '../pages/chart_dashboard.dart';
import '../pages/pool_dashboard.dart';
import '../models/crypto.dart';
import '../providers/wallet_provider.dart';

class CryptoCard extends StatelessWidget {
  final Crypto crypto;

  const CryptoCard({super.key, required this.crypto});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[100],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
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
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 10.0),
        // minLeadingWidth: 10,
        // horizontalTitleGap: 10,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PoolDashboard(crypto: crypto),
            ),
          );
        },
        trailing: WalletProvider.isWalletExists(crypto.name)
            ? SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChartDashboard(crypto: crypto),
                        ),
                      ),
                      icon: const Icon(
                        Icons.candlestick_chart,
                        color: textColor,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PoolDashboard(crypto: crypto),
                        ),
                      ),
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              )
            : null,
        leading: Image(
          image: AssetImage(crypto.iconUrl),
          height: 50,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error);
          },
        ),
        title: Text(
          '${crypto.name} (${crypto.symbol.toUpperCase()})',
          style: const TextStyle(
            color: textColor,
          ),
        ),
        subtitle: Text(
          NumberParsing(crypto.price).asMoney(decimal: 5),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
