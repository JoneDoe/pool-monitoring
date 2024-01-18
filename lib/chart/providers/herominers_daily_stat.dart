import 'package:pool_monitoring/chart/providers/abstract_daily_stat.dart';

import '../../providers/pool_config_provider.dart';
import '../bar_chart_data.dart';

class HerominersDailyStat extends AbstractDailyStat {
  @override
  AppBarChartData load(dynamic map, Config config) {
    map['unlocked_daily'].forEach((data) {
      myBarData.addValue(double.parse(data) / config.coinUnits);
    });

    return myBarData;
  }
}
