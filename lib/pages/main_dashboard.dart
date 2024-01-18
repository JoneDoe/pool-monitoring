import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../components/crypto_card.dart';
import '../models/crypto.dart';
import '../providers/cryptocurrency_listing.dart';

class CryptoDashboard extends StatefulWidget {
  const CryptoDashboard({super.key});

  @override
  State<CryptoDashboard> createState() => _CryptoDashboardState();
}

class _CryptoDashboardState extends State<CryptoDashboard> {
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
      drawer: _drawerWidget(),
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

Widget _drawerWidget() {
  return const Drawer(
    backgroundColor: secondaryColor,
    child: Column(
      children: [
        DrawerHeader(
          child: Text(
            'Menu',
            style: TextStyle(color: textColor),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: ListTile(
            leading: Icon(Icons.home, color: textColor),
            title: Text(
              'Home',
              style: TextStyle(color: textColor),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.0),
          child: ListTile(
            leading: Icon(Icons.settings, color: textColor),
            title: Text(
              'Settings',
              style: TextStyle(color: textColor),
            ),
          ),
        ),
      ],
    ),
  );
}
