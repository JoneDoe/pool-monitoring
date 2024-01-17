class Crypto {
  final String name, symbol, iconUrl;
  final double price;

  Crypto({
    required this.name,
    required this.symbol,
    required this.iconUrl,
    this.price = 0,
  });

  factory Crypto.fromMap(Map<String, dynamic> map) {
    return Crypto(
      name: map['name'],
      symbol: map['symbol'],
      price: map['current_price'].toDouble(),
      iconUrl: 'assets/${map['name'].toLowerCase()}.webp',
    );
  }
}
