import 'dart:math';

import 'models/bar.dart';

class AppBarChartData {
  final List<Bar> _chartData = [];

  List<Bar> get chartData => _chartData;

  void addValue(double value) => _chartData.add(
        Bar(x: _chartData.length, y: value),
      );

  double maxValue() =>
      _chartData.isNotEmpty ? _chartData.map((item) => item.y).reduce(max) : 5;
}
