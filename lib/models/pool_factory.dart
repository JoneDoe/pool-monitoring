import '../providers/pool_config_provider.dart';

import 'herominers_pool_stats.dart';
import 'woolypooly_pool_stats.dart';
import 'worker.dart';

enum PoolName { woolypooly, herominers }

class PoolStatFactory {
  int coinUnits;
  double hashrate, effort, price, paid, incomeHour;
  double incomeHalfDay, incomeDay, incomeWeek, incomeMonth;

  List<Worker> workers = [];

  PoolStatFactory({
    this.coinUnits = 0,
    this.hashrate = 0,
    this.effort = 0,
    this.price = 0,
    this.paid = 0,
    this.incomeHour = 0,
    this.incomeHalfDay = 0,
    this.incomeDay = 0,
    this.incomeWeek = 0,
    this.incomeMonth = 0,
  });

  factory PoolStatFactory.fromMap(
    Map<String, dynamic> map,
    PoolName poolName,
    Config config,
  ) {
    switch (poolName) {
      case PoolName.herominers:
        return HerominersPoolStats.fromMap(map, config);
      default:
        return WoolyPoolyPoolStats.fromMap(map, config);
    }
  }
}
