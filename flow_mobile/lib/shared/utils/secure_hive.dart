import 'dart:convert';

import 'package:flow_mobile/data/source/local_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SecureHive {
  /// Initialize Hive and open the encrypted box
  static Future<void> initHive() async {
    await Hive.initFlutter();

    // Retrieve encryption key from secure storage
    var encryptionKey = await SecureStorage.getData('hiveKey');

    if (encryptionKey == null) {
      // Generate a secure 32-byte encryption key
      var key = Hive.generateSecureKey();
      // Encode the key to Base64 to store it as a string
      encryptionKey = base64Encode(key);
      await SecureStorage.saveData('hiveKey', encryptionKey);
    }

    // Decode the encryption key from Base64 back to Uint8List
    final secureKey = base64Decode(encryptionKey);

    // Open a Hive box with AES encryption
    await Hive.openBox('secureBox', encryptionCipher: HiveAesCipher(secureKey));
  }

  /// Store encrypted data
  static Future<void> saveData(String key, Object value) async {
    var box = Hive.box('secureBox');
    await box.put(key, value);
  }

  /// Retrieve encrypted data
  static Future<Object?> getData(String key) async {
    var box = Hive.box('secureBox');
    return box.get(key);
  }

  /// Delete data
  static Future<void> deleteData(String key) async {
    var box = Hive.box('secureBox');
    await box.delete(key);
  }

  /// Close Hive safely when the app is closed
  static Future<void> closeHive() async {
    await Hive.close();
  }
}
