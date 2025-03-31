import 'dart:convert';
import 'dart:typed_data';

import 'package:flow_mobile/data/source/local_secure_storage.dart';
import 'package:flow_mobile/domain/entities/bank.dart';
import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/domain/entities/setting.dart';
import 'package:flow_mobile/domain/entities/transaction.dart';
import 'package:flow_mobile/domain/entities/user.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SecureHive {
  /// Initialize Hive and open the encrypted box
  static Uint8List? secureKey;
  static Future<bool> initHive() async {
    await Hive.initFlutter();

    SecureStorage secureStorage = SecureStorage();

    // Retrieve encryption key from secure storage
    var encryptionKey = await secureStorage.getData('hiveKey');

    if (encryptionKey == null) {
      encryptionKey = base64Encode(Hive.generateSecureKey());
      await secureStorage.saveData('hiveKey', encryptionKey);
    }

    // Decode the encryption key from Base64 back to Uint8List
    secureKey = base64Decode(encryptionKey);

    Hive.registerAdapter(SettingsAdapter());
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(BankAccountAdapter());
    Hive.registerAdapter(BankAdapter());
    Hive.registerAdapter(TransactionAdapter());

    // Test Transaction data
    Box<dynamic> box = await Hive.openBox(
      'secureBox',
      encryptionCipher: HiveAesCipher(secureKey!),
    );
    await box.put('monthlyBalance', {
      'income': 4300.00,
      'card': 732.12,
      'transfer': 1000.00,
      'other': 1002.23,
    });

    return true;
  }

  static getData(String key) async {
    Box<dynamic> box = await Hive.openBox(
      'secureBox',
      encryptionCipher: HiveAesCipher(secureKey!),
    );
    return box.get(key);
  }

  static Future<Box<E>> getBox<E>(String boxName) {
    return Hive.openBox(boxName, encryptionCipher: HiveAesCipher(secureKey!));
  }
}
