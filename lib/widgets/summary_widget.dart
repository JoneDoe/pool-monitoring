import 'package:flutter/material.dart';

import '../components/info_item.dart';
import '../constants.dart';
import '../models/pool_factory.dart';
import '../extensions/number_extension.dart';

class SummaryWidget extends StatelessWidget {
  const SummaryWidget({super.key, required PoolStatFactory statistics})
      : _statistics = statistics;

  final PoolStatFactory _statistics;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 245,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: secondaryColor,
      ),
      child: Column(
        children: [
          InfoRowItem(
            name: 'Hashrate',
            value:
                '${NumberParsing(_statistics.hashrate).digit(decimal: 2)} Gh/s',
            icon: Icons.speed,
          ),
          const Divider(
            height: 20,
            indent: 12,
            endIndent: 12,
            color: Colors.white30,
          ),
          InfoRowItem(
            name: 'Effort',
            value: '${NumberParsing(_statistics.effort).digit(decimal: 2)}%',
            icon: Icons.person,
          ),
          const Divider(
            height: 20,
            indent: 12,
            endIndent: 12,
            color: Colors.white30,
          ),
          InfoRowItem(
            name: 'Balance',
            value:
                '${NumberParsing(_statistics.paid).digit(decimal: 2)} (${NumberParsing(_statistics.paid * _statistics.price).asMoney()})',
            icon: Icons.wallet,
          ),
          const Divider(
            height: 20,
            indent: 12,
            endIndent: 12,
            color: Colors.white30,
          ),
          InfoRowItem(
            name: 'Price',
            value: NumberParsing(_statistics.price).asMoney(),
            icon: Icons.ssid_chart_sharp,
          ),
        ],
      ),
    );
  }
}
