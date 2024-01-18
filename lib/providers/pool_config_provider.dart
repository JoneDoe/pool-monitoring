import 'dart:convert';
import 'package:http/http.dart' as http;

class PoolConfigProvider {
  Future<Config> load(String coin) async {
    var url = 'https://$coin.herominers.com/api/stats';

    final response = await http.get(Uri.parse(url));
    // print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      return Config.fromMap(decoded);
    } else {
      throw Exception('Failed to load pool config data: ${response.body}');
    }
  }
}

class Config {
  int coinUnits;
  double coinPrice;
  // bool soloMining;

  Config({
    required this.coinPrice,
    required this.coinUnits,
    // required this.soloMining,
  });

  factory Config.fromMap(Map<String, dynamic> map) {
    return Config(
      coinPrice: double.parse(map['pool']['price']['usd']),
      coinUnits: map['config']['coinUnits'],
      // soloMining: map['config']['soloMining'],
    );
  }
}
