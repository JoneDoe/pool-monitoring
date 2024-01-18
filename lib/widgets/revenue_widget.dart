import 'package:flutter/material.dart';

import '../components/time_revenue_item.dart';
import '../constants/colors.dart';
import '../models/pool_factory.dart';

class RevenueWidget extends StatelessWidget {
  const RevenueWidget({super.key, required PoolStatFactory statistics})
      : _statistics = statistics;

  final PoolStatFactory _statistics;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 210,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: secondaryColor,
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Time',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Revenue',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 10,
            indent: 12,
            endIndent: 12,
            color: Colors.white30,
          ),
          TimeRevenueItem(
            name: '60 minutes',
            price: _statistics.price,
            amount: _statistics.incomeHour,
          ),
          TimeRevenueItem(
            name: '12 hours',
            price: _statistics.price,
            amount: _statistics.incomeHalfDay,
          ),
          TimeRevenueItem(
            name: '24 hours',
            price: _statistics.price,
            amount: _statistics.incomeDay,
          ),
          TimeRevenueItem(
            name: 'week',
            price: _statistics.price,
            amount: _statistics.incomeWeek,
          ),
          TimeRevenueItem(
            name: 'month',
            price: _statistics.price,
            amount: _statistics.incomeMonth,
          )
        ],
      ),
    );
  }
}
