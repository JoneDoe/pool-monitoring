import 'package:flutter/material.dart';

import '/constants.dart';

AppBar defaultAppBar({required String textTitle}) {
  return AppBar(
    leading: Builder(builder: (context) {
      return BackButton(
        onPressed: () => Navigator.pop(context),
      );
    }),
    title: Text(
      textTitle,
      style: const TextStyle(color: textColor),
    ),
    backgroundColor: secondaryColor,
    foregroundColor: textColor,
  );
}
