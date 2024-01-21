class WalletEntryItem {
  final String name, token;

  WalletEntryItem({required this.name, required this.token});

  factory WalletEntryItem.fromJson(dynamic json) => WalletEntryItem(
        name: json['name'] as String,
        token: json['token'] as String,
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'token': token,
      };
}
