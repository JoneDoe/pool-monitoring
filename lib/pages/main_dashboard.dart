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
    fetchCryptoData();
  }

  fetchCryptoData() async {
    // Currency.values.forEach((Currency element) {
    //   cryptos.add(Crypto(
    //     name: element.name.capitalize(),
    //     symbol: element.short,
    //     iconUrl: element.iconUrl,
    //   ));
    // });

    // return;

    var jsonData = await CryptocurrencyListingProvider.fetchData();

    setState(() {
      cryptos = jsonData;
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
      drawer: const Drawer(
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: RefreshIndicator(
          onRefresh: () => fetchCryptoData(),
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
