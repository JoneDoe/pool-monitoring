import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '/components/url_builder.dart';
import '/models/crypto.dart';
import '/providers/pool_config_provider.dart';
import '../models/pool_factory.dart';

class PoolStatProvider {
  static Future<PoolStatFactory> fetchData(
      PoolName poolName, Crypto crypto) async {
    var builder = PoolUrlBuilder(
      poolName: poolName,
      coin: crypto,
    );

    print(builder.url());

    Config config = await PoolConfigProvider().load(crypto.currency.name);
    final response = await http.get(Uri.parse(builder.url()));

    PoolStatFactory statistics = PoolStatFactory();

    final decoded = json.decode(response.body);

    if (response.statusCode == 200 && decoded['error'] == null) {
      statistics = PoolStatFactory.fromMap(decoded, poolName, config);
    } else {
      throw Exception('Failed to load crypto data for ${crypto.currency.name}');
    }

    return statistics;
  }
}
