import 'package:get_storage/get_storage.dart';

class AppStorage {
  final _box = GetStorage();

  Future<void> saveLastUpdatedDateTime() async {
    await _box.write(
      NavaTechStorageKeys.lastUpdatedData,
      DateTime.now().toString(),
    );
  }

  Future<DateTime?> getLastUpdatedDateTime() async {
    final dateString = await _box.read(NavaTechStorageKeys.lastUpdatedData);
    if (dateString != null) {
      return DateTime.tryParse(dateString);
    }
    return null;
  }

  Future<void> erase() async {
    await _box.erase();
  }
}

class NavaTechStorageKeys {
  static const lastUpdatedData = 'lastUpdatedData';
}
