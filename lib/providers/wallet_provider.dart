import 'package:flutter_dotenv/flutter_dotenv.dart';

class WalletProvider {
  static String? getWallet(String coinName) =>
      dotenv.env['${coinName.toUpperCase()}_TOKEN'];

  static bool isWalletExists(String coinName) => getWallet(coinName) != null;
}
