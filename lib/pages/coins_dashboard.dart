import 'package:flutter/material.dart';

import '/constants.dart';
import '/widgets/crypto_card.dart';
import '/models/crypto.dart';
import '/providers/cryptocurrency_listing.dart';
import '/widgets/drawer_widget.dart';

class CoinsListingDashboard extends StatefulWidget {
  const CoinsListingDashboard({super.key});

  @override
  State<CoinsListingDashboard> createState() => _CoinsListingDashboardState();
}

class _CoinsListingDashboardState extends State<CoinsListingDashboard> {
  List<Crypto> cryptos = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    var data = await CryptocurrencyListingProvider.load();

    setState(() {
      cryptos = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu),
          );
        }),
        title: const Text(
          'Coins listing',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: secondaryColor,
        foregroundColor: textColor,
      ),
      drawer: const DrawerWidget(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: RefreshIndicator(
          onRefresh: () => loadData(),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 5,
              mainAxisSpacing: 15.0,
            ),
            itemCount: cryptos.length,
            itemBuilder: (_, index) => CryptoCard(crypto: cryptos[index]),
          ),
        ),
      ),
    );
  }
}
