import 'package:hive/hive.dart';

import '../exception.dart';
import '../models/wallet_entry.dart';

const _bucketName = 'WALLET_HOLDER';

class Bucket {
  final _myBox = Hive.box(name: 'myWallets');

  final List<WalletEntryItem> _entries = [];

  void loadData() {
    var list = _myBox.get(_bucketName);

    if (null != list) {
      for (var element in list) {
        _entries.add(WalletEntryItem.fromJson(element));
      }
    }
  }

  void add(WalletEntryItem item) {
    if (_entries.any((element) => element.name == item.name)) {
      throw WalletEntryItemException('Wallet for ${item.name} exists');
    }

    _entries.add(item);
    _updateDb();
  }

  void remove(int index) {
    _entries.removeAt(index);
    _updateDb();
  }

  void _updateDb() {
    _myBox.put(_bucketName, _entries);
  }

  int size() {
    return _entries.length;
  }

  WalletEntryItem getAt(int index) {
    return _entries[index];
  }
}
