class WalletEntryItemException implements Exception {
  final String message;

  WalletEntryItemException(this.message);

  @override
  String toString() => message;
}
