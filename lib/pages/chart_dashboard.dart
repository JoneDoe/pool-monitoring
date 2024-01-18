import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../chart/chart_data.dart';
import '../components/url_builder.dart';
import '../exceptions/waller_exception.dart';
import '../constants/colors.dart';
import '../models/abstract_pool.dart';
import '../models/crypto.dart';
import 'main_dashboard.dart';

class ChartDashboard extends StatefulWidget {
  final Crypto crypto;

  const ChartDashboard({super.key, required this.crypto});

  @override
  State<ChartDashboard> createState() => _ChartDashboardState();
}

class _ChartDashboardState extends State<ChartDashboard> {
  List<ChartData> data = [];
  PoolName _poolName = PoolName.herominers;

  @override
  void initState() {
    super.initState();
    // fetchCartData();
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
                MaterialPageRoute(builder: (_) => const CryptoDashboard()),
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  changePool(int index) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Pool cnahged')));

    setState(() {
      _poolName = PoolName.values[index];
    });

    fetchCartData();
  }

  Future<void> fetchCartData() async {
    try {
      var builder = PoolUrlBuilder(
        poolName: _poolName,
        coin: widget.crypto,
      );

      debugPrint(builder.url());
      // Config config = await PoolConfigProvider()
      //     .fetchData(widget.crypto.name.toLowerCase());
      // print(config);
      final response = await http.get(Uri.parse(builder.url()));
      // print(config);
      final decoded = json.decode(response.body);

      print(decoded['charts']['payments']);

      if (response.statusCode == 200 && decoded['error'] == null) {
        // setState(() {
        //   data = decoded['charts']['payments'].map((item) => ChartData(
        //         xval: DateTime.fromMicrosecondsSinceEpoch(item[0]),
        //         yval: item[1].toDouble / 10000,
        //       ));
        // });
      } else {
        throw Exception('Failed to load crypto data for ${widget.crypto.name}');
      }
    } on WalletException catch (e) {
      debugPrint(e.toString());
      _showAlert(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // final List _chartData;

  @override
  Widget build(BuildContext context) {
    ChartData myBarData = ChartData(
      sevenDays: 231,
      sixDays: 112.5,
      fiveDays: 213.4,
      fourDays: 135.7,
      threeDays: 114.3,
      twoDays: 15.6,
      oneDay: 0,
    );
    myBarData.initializeBarData();

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        foregroundColor: textColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(widget.crypto.iconUrl),
              width: 20,
              height: 20,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error);
              },
            ),
            const SizedBox(width: 5.0),
            Text(
              widget.crypto.name,
              style: const TextStyle(color: textColor),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.replay,
              color: textColor,
            ),
            onPressed: () {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   const SnackBar(content: Text('Fetch crypto data')),
              // );
              fetchCartData();
            },
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          height: 400,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 300,
              minY: 0,
              barTouchData: barTouchData,
              gridData: const FlGridData(
                drawHorizontalLine: true,
                drawVerticalLine: false,
              ),
              borderData: borderData,
              titlesData: titlesData,
              barGroups: _chartGroups(myBarData),
            ),
          ),
        ),
      ),
    );
  }
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

List<BarChartGroupData> _chartGroups(ChartData myBarData) {
  return myBarData.chartData
      .map((data) => BarChartGroupData(
            x: data.x,
            barRods: [
              BarChartRodData(
                toY: data.y,
                width: 30,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
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
    case 1:
      textValue = '24h';
      break;
    case 2:
      textValue = '2d';
      break;
    case 3:
      textValue = '3d';
      break;
    case 4:
      textValue = '4d';
      break;
    case 5:
      textValue = '5d';
      break;
    case 6:
      textValue = '6d';
      break;
    case 7:
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
// class ChartData {
//   ChartData({required this.xval, required this.yval});

//   final DateTime xval;
//   final double yval;

//   var d12 = DateFormat('MMdd');

//   String get val => d12.format(xval);
// }
