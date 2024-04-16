import 'dart:convert';
import 'package:http/http.dart' as http;

import '../providers/abstract_daily_stat.dart';
import '../models/bar_chart_data.dart';
import '/components/url_builder.dart';
import '/pool/models/pool_factory.dart';
import '/models/crypto.dart';
import '/providers/pool_config_provider.dart';
import 'herominers_daily_stat.dart';

class DailyStatProvider {
  static Future<AppBarChartData> load(PoolName poolName, Crypto crypto) async {
    var builder = PoolUrlBuilder(poolName: poolName, coin: crypto);

    print(builder.url());

    final response = await http.get(Uri.parse(builder.url()));
    final decoded = json.decode(response.body);

    Config config = await PoolConfigProvider().load(crypto.currency.name);

    final AbstractDailyStat loader;

    if (response.statusCode == 200 && decoded['error'] == null) {
      switch (poolName) {
        case PoolName.herominers:
          loader = HerominersDailyStat();
        default:
          loader = HerominersDailyStat();
      }
    } else {
      throw Exception(
          'Failed to load daily stat data for ${crypto.currency.name}');
    }

    return loader.load(decoded, config);
  }
}
