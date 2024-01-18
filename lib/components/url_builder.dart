import '../models/pool_factory.dart';
import '../models/crypto.dart';
import '../exceptions/waller_exception.dart';
import '../providers/wallet_provider.dart';

class PoolUrlBuilder {
  PoolName poolName;
  Crypto coin;

  PoolUrlBuilder({required this.poolName, required this.coin});

  String url() {
    String? wallet = WalletProvider.getWallet(coin.name);

    if (wallet == null) {
      throw WalletException('Wallet not found for `${coin.name}`');
    }

    Base builder;

    switch (poolName) {
      case PoolName.herominers:
        builder = Herominers(coin: coin.name, wallet: wallet);
      default:
        builder = Woolypooly(coin: coin.symbol, wallet: wallet);
    }

    return builder.build();
  }
}

abstract class Base {
  final String coin;
  final String wallet;

  Base({required this.coin, required this.wallet});

  String build() => '';
}

class Herominers extends Base {
  Herominers({required super.coin, required super.wallet});

  @override
  String build() =>
      'https://${coin.toLowerCase()}.herominers.com/api/stats_address?address=$wallet&recentBlocksAmount=20&longpoll=false';
}

class Woolypooly extends Base {
  Woolypooly({required super.coin, required super.wallet});

  @override
  String build() => 'https://api.woolypooly.com/api/$coin-1/accounts/$wallet';
}
