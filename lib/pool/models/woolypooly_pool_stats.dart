import '/providers/pool_config_provider.dart';
import 'pool_factory.dart';
import 'worker.dart';

class WoolyPoolyPoolStats extends PoolStatFactory {
  WoolyPoolyPoolStats({
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

  factory WoolyPoolyPoolStats.fromMap(Map<String, dynamic> map, Config config) {
    var income = map['stats']['income'];
    var stats = map['stats'];

    var pool = WoolyPoolyPoolStats(
      hashrate: map['mode_stats'].containsKey('pplns')
          ? map['mode_stats']['pplns']['default']['currentHashrate'] /
              1000000000
          : 0,
      effort: stats['effort'].isEmpty == false
          ? stats['effort'][0]['rate'] * 100
          : 0,
      price: config.coinPrice,
      paid: stats['paid'],
      incomeHour: income['income_Hour'],
      incomeHalfDay: income['income_HalfDay'],
      incomeDay: income['income_Day'],
      incomeWeek: income['income_Week'],
      incomeMonth: income['income_Month'],
    );

    if (map['workers'].isEmpty == false) {
      map['workers'].forEach((data) {
        pool.workers.add(Worker.fromMapWp(data));
      });
    }

    return pool;
  }
}
