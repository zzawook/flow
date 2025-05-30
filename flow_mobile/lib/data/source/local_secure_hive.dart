import 'dart:convert';
import 'dart:typed_data';

import 'package:flow_mobile/data/source/local_secure_storage.dart';
import 'package:flow_mobile/domain/entities/bank.dart';
import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/domain/entities/notification.dart';
import 'package:flow_mobile/domain/entities/paynow_recipient.dart';
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

    var encryptionKey = await secureStorage.getData('hiveKey');

    if (encryptionKey == null) {
      encryptionKey = base64Encode(Hive.generateSecureKey());
      await secureStorage.saveData('hiveKey', encryptionKey);
    }

    secureKey = base64Decode(encryptionKey);

    _doMigration(secureKey!);

    Hive.registerAdapter(SettingsAdapter());
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(BankAccountAdapter());
    Hive.registerAdapter(BankAdapter());
    Hive.registerAdapter(TransactionAdapter());
    Hive.registerAdapter(PayNowRecipientAdapter());
    Hive.registerAdapter(NotificationAdapter());

    // ADD ADAPTERS FOR BOTH LEGACY AND NEW ENTITIES

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

  static void _doMigration(Uint8List secureKey) async {
    const kHiveVersionKey = '__schema_version__';
    const hiveBoxKey = 'app_meta';

    if (!await Hive.boxExists(kHiveVersionKey)) {
      // If the version box does not exist, create it with version 0
      // then return
      await Hive.openBox(
        hiveBoxKey,
        encryptionCipher: HiveAesCipher(secureKey),
      ).then((box) => box.put(kHiveVersionKey, 0));
      return;
    }

    final meta = await Hive.openBox(
      hiveBoxKey,
      encryptionCipher: HiveAesCipher(secureKey),
    );
    final currentVersion = meta.get(kHiveVersionKey, defaultValue: 0) as int;

    // if (currentVersion < 2) {
    //   // Migration logic for version
    //   await meta.put(kHiveVersionKey, 2);
    // }
    // Add more migrations here as needed
  }
}
