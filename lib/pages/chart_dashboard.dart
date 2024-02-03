import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../chart/bar_chart_data.dart';
import '../exceptions/waller_exception.dart';
import '../constants.dart';
import '../pool/models/pool_factory.dart';
import '../models/crypto.dart';
import '../chart/providers/daily_stat_provider.dart';
import '../widgets/app_bar_widget.dart';
import 'coins_dashboard.dart';

class ChartDashboard extends StatefulWidget {
  final Crypto crypto;

  const ChartDashboard({super.key, required this.crypto});

  @override
  State<ChartDashboard> createState() => _ChartDashboardState();
}

class _ChartDashboardState extends State<ChartDashboard> {
  AppBarChartData _myBarData = AppBarChartData();
  PoolName _poolName = PoolName.herominers;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    loadDailyStat();
  }

  void _showAlert(String msg) async {
    await Future.delayed(const Duration(milliseconds: 50));

    if (!context.mounted) return;
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text(
            msg,
            style: const TextStyle(fontSize: 16),
          ),
          backgroundColor: Colors.grey[300],
          actions: <Widget>[
            FilledButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => const CoinsListingDashboard()),
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  changePool(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pool has been cnahged'),
        duration: Duration(seconds: 2),
      ),
    );

    setState(() {
      _poolName = PoolName.values[index];
    });

    loadDailyStat();
  }

  Future<void> loadDailyStat({bool? disableLoading}) async {
    if (null == disableLoading) {
      setState(() => _loading = true);
    }

    try {
      var data = await DailyStatProvider.load(_poolName, widget.crypto);

      setState(() {
        _loading = false;
        _myBarData = data;
      });
    } on WalletException catch (e) {
      debugPrint(e.toString());
      _showAlert(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: myAppBar(
        cryptoInfo: widget.crypto,
        actions: <Widget>[
          IconButton(
            icon: _loading
                ? const CircularProgressIndicator()
                : const Icon(
                    Icons.replay,
                    color: textColor,
                  ),
            onPressed: () => loadDailyStat(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => loadDailyStat(disableLoading: true),
        child: ListView(
          padding: const EdgeInsets.only(top: 125, right: 25),
          children: [
            chartWidget(_myBarData),
          ],
        ),
      ),
    );
  }
}

Widget chartWidget(AppBarChartData barData) {
  return Center(
    child: SizedBox(
      height: 400,
      child: BarChart(
        // swapAnimationDuration: const Duration(milliseconds: 150),
        BarChartData(
          // alignment: BarChartAlignment.spaceAround,
          maxY: barData.maxValue().roundToDouble() + 1,
          minY: 0,
          barTouchData: barTouchData,
          gridData: const FlGridData(
            drawHorizontalLine: true,
            drawVerticalLine: false,
          ),
          borderData: borderData,
          titlesData: titlesData,
          barGroups: _chartGroups(barData),
        ),
      ),
    ),
  );
}

FlBorderData get borderData => FlBorderData(
      show: false,
    );

LinearGradient get _barsGradient => LinearGradient(
      colors: [
        Colors.red.shade900,
        Colors.orange.shade500,
      ],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
    );

FlTitlesData get titlesData => const FlTitlesData(
      show: true,
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 55,
          getTitlesWidget: _getLeftTiles,
        ),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 25,
          getTitlesWidget: _getBottomTitles,
        ),
      ),
    );

BarTouchData get barTouchData => BarTouchData(
      enabled: true,
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: const Color.fromARGB(93, 96, 125, 139),
        tooltipPadding: const EdgeInsets.all(6),
        tooltipMargin: 8,
        getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
        ) {
          return BarTooltipItem(
            rod.toY.toString(),
            const TextStyle(
              color: Colors.cyan,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          );
        },
      ),
    );

List<BarChartGroupData> _chartGroups(AppBarChartData myBarData) {
  return myBarData.chartData
      .map((data) => BarChartGroupData(
            x: data.x,
            barRods: [
              BarChartRodData(
                toY: data.y,
                width: 30,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(5),
                  topRight: Radius.circular(5),
                ),
                gradient: _barsGradient,
              ),
            ],
          ))
      .toList();
}

Widget _getLeftTiles(double value, TitleMeta meta) {
  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(
      value.toString(),
      style: const TextStyle(color: textColor, fontSize: 14),
    ),
  );
}

Widget _getBottomTitles(double value, TitleMeta meta) {
  String textValue = '';
  switch (value.toInt()) {
    case 6:
      textValue = '24h';
      break;
    case 5:
      textValue = '2d';
      break;
    case 4:
      textValue = '3d';
      break;
    case 3:
      textValue = '4d';
      break;
    case 2:
      textValue = '5d';
      break;
    case 1:
      textValue = '6d';
      break;
    case 0:
      textValue = '7d';
      break;
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: Text(
      textValue,
      style: const TextStyle(
        color: textColor,
        fontSize: 15,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
