import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();

  static void init() {

  }

  /// Save a value securely
  static Future<void> saveData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Retrieve a value securely
  static Future<String?> getData(String key) async {
    return await _storage.read(key: key);
  }

  /// Delete a specific key
  static Future<void> deleteData(String key) async {
    await _storage.delete(key: key);
  }

  /// Clear all secure storage
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
