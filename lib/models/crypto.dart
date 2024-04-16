import '../providers/cryptocurrency_listing.dart';

class Crypto {
  final String name, symbol, iconUrl;
  final double price;
  final Currency currency;

  Crypto({
    required this.name,
    required this.symbol,
    required this.iconUrl,
    this.price = 0,
    required this.currency,
  });

  factory Crypto.fromMap(Map<String, dynamic> map) {
    Currency currency;

    switch (map['id']) {
      case 'iron-fish':
        currency = Currency.ironfish;
        break;
      default:
        currency = Currency.values.byName(map['id']);
    }

    return Crypto(
      name: map['name'],
      symbol: map['symbol'],
      price: map['current_price'].toDouble(),
      iconUrl: currency.iconUrl,
      currency: currency,
    );
  }
}
