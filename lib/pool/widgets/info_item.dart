import 'package:flutter/material.dart';

import '/constants.dart';

class InfoRowItem extends StatelessWidget {
  final String name, value;
  final IconData icon;

  const InfoRowItem({
    super.key,
    required this.name,
    required this.icon,
    this.value = '?',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 20, left: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: textColor),
              const SizedBox(width: 12.0),
              Text(
                name,
                style: const TextStyle(
                  color: textColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          Text(
            value,
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
