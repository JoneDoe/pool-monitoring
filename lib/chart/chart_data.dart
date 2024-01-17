import 'bar.dart';

class ChartData {
  final double sevenDays,
      sixDays,
      fiveDays,
      fourDays,
      threeDays,
      twoDays,
      oneDay;

  ChartData({
    required this.sevenDays,
    required this.sixDays,
    required this.fiveDays,
    required this.fourDays,
    required this.threeDays,
    required this.twoDays,
    required this.oneDay,
  });

  List<Bar> chartData = [];

  void initializeBarData() {
    chartData = [
      Bar(x: 7, y: sevenDays),
      Bar(x: 6, y: sixDays),
      Bar(x: 5, y: fiveDays),
      Bar(x: 4, y: fourDays),
      Bar(x: 3, y: threeDays),
      Bar(x: 2, y: threeDays),
      Bar(x: 1, y: oneDay),
    ];
  }
}
