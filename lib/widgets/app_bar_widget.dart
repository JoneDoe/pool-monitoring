import 'package:flutter/material.dart';

import '/models/crypto.dart';
import '/constants.dart';

AppBar myAppBar({required Crypto cryptoInfo, List<Widget>? actions}) {
  return AppBar(
    backgroundColor: secondaryColor,
    foregroundColor: textColor,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          image: AssetImage(cryptoInfo.iconUrl),
          width: 20,
          height: 20,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error);
          },
        ),
        const SizedBox(width: 5.0),
        Text(
          cryptoInfo.name,
          style: const TextStyle(color: textColor),
        ),
      ],
    ),
    actions: actions ?? [],
  );
}
