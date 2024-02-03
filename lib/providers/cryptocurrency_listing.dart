import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '/models/crypto.dart';

enum Currency {
  bitcoin,
  ethereum,
  alephium,
  karlsen,
  pyrin,
  solana,
  radiant,
  kaspa;

  String get short => _currencySlug[this]!;
  String get iconUrl => 'assets/$name.webp';
}

Map<Currency, String> _currencySlug = {
  Currency.bitcoin: 'btc',
  Currency.ethereum: 'eth',
  Currency.alephium: 'alph',
  Currency.solana: 'sol',
  Currency.kaspa: 'kas',
  Currency.radiant: 'rxd',
  Currency.pyrin: 'pyi',
  Currency.karlsen: 'kls',
};

class CryptocurrencyListingProvider {
  static Future<List<Crypto>> load() async {
    String? url = dotenv.env['COINGECKO_API'];
    if (url == null) {
      throw Exception('COINGECKO_API is empty');
    }

    String? token = dotenv.env['COINGECKO_TOKEN'];
    if (token == null) {
      throw Exception('COINGECKO_TOKEN is empty');
    }

    url =
        '$url&ids=${Currency.values.map((Currency cyrrecy) => cyrrecy.name).join(',')}';
    // print(url);
    Map<String, String> headers = {
      'Accepts': 'application/json',
      'x-cg-demo-api-key': token
      // 'X-CMC_PRO_API_KEY': token
    };

    List<Crypto> list = [];

    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body) as List;

      list = jsonData.map((cryptoData) => Crypto.fromMap(cryptoData)).toList();
    } else {
      throw Exception('Failed to load crypto data: ${response.body}');
    }

    return list.toList();
  }
}
