import '/providers/pool_config_provider.dart';
import '../models/bar_chart_data.dart';

abstract class AbstractDailyStat {
  final AppBarChartData myBarData = AppBarChartData();

  AppBarChartData load(dynamic map, Config config);
}
