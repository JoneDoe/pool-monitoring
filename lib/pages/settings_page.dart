import 'package:flutter/material.dart';
import 'package:pool_monitoring/constants.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return BackButton(
            onPressed: () => Navigator.pop(context),
          );
        }),
        title: const Text(
          'Settings',
          style: TextStyle(color: textColor),
        ),
        backgroundColor: primaryColor,
        foregroundColor: textColor,
      ),
    );
  }
}
