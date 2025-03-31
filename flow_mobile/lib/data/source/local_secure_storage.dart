import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final SecureStorage _instance = SecureStorage._internal();

  factory SecureStorage() => _instance;

  SecureStorage._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Save a value securely
  Future<void> saveData(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Retrieve a value securely
  Future<String?> getData(String key) async {
    return await _storage.read(key: key);
  }

  /// Delete a specific key
  Future<void> deleteData(String key) async {
    await _storage.delete(key: key);
  }

  /// Clear all secure storage
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
