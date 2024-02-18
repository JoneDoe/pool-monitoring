import 'package:hive/hive.dart';
import '../models/settings_model.dart';

const _bucketName = 'SETTINGS_HOLDER';

class SettingsProvider {
  final _myBox = Hive.box();

  AppSettings _settings = AppSettings();

  void loadData() {
    _settings = _myBox.get(_bucketName, defaultValue: _settings);
  }

  void save(AppSettings value) {
    _settings = value;
    _updateDb();
  }

  void _updateDb() {
    _myBox.put(_bucketName, _settings);
  }

  AppSettings get items => _settings;
}
