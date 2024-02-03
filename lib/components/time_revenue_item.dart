import 'package:flutter/material.dart';

import '../constants.dart';
import '../extensions/number_extension.dart';

class TimeRevenueItem extends StatelessWidget {
  final String name;
  final double amount, price;

  const TimeRevenueItem({
    super.key,
    required this.name,
    required this.amount,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: textColor,
              fontSize: 16,
            ),
          ),
          Text(
            '${NumberParsing(amount).digit()} (${NumberParsing(amount * price).asMoney()})',
            style: const TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
