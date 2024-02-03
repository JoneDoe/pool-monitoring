import '/providers/pool_config_provider.dart';

import 'pool_factory.dart';
import 'worker.dart';

class HerominersPoolStats extends PoolStatFactory {
  HerominersPoolStats({
    super.coinUnits,
    super.hashrate,
    super.effort,
    super.price,
    super.paid,
    super.incomeHour,
    super.incomeHalfDay,
    super.incomeDay,
    super.incomeWeek,
    super.incomeMonth,
  });

  factory HerominersPoolStats.fromMap(Map<String, dynamic> map, Config config) {
    var stats = map['stats'];

    var pool = HerominersPoolStats(
      hashrate: stats['hashrate'] / 1000000000,
      effort: 100,
      price: config.coinPrice,
      paid: double.parse(stats['paid']) / config.coinUnits,
      incomeHour: 0,
      incomeHalfDay: stats['payments_24h'].toDouble() / 2 / config.coinUnits,
      incomeDay: stats['payments_24h'].toDouble() / config.coinUnits,
      incomeWeek: stats['payments_7d'].toDouble() / config.coinUnits,
      incomeMonth: 0,
    );

    if (map['workers'].isEmpty == false) {
      map['workers'].forEach((data) {
        pool.workers.add(Worker.fromMapHm(data));
      });
    }

    return pool;
  }
}
