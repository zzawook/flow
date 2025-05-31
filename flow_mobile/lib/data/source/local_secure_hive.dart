import 'dart:convert';
import 'dart:typed_data';

import 'package:flow_mobile/data/source/local_secure_storage.dart';
import 'package:flow_mobile/domain/entities/bank.dart';
import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/domain/entities/notification.dart';
import 'package:flow_mobile/domain/entities/notification_setting.dart';
import 'package:flow_mobile/domain/entities/paynow_recipient.dart';
import 'package:flow_mobile/domain/entities/setting.dart';
import 'package:flow_mobile/domain/entities/setting_v1.dart';
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

    Hive.registerAdapter(SettingsAdapter());
    Hive.registerAdapter(SettingsV1Adapter());
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(BankAccountAdapter());
    Hive.registerAdapter(BankAdapter());
    Hive.registerAdapter(TransactionAdapter());
    Hive.registerAdapter(PayNowRecipientAdapter());
    Hive.registerAdapter(NotificationAdapter());
    Hive.registerAdapter(NotificationSettingAdapter());

    // ADD ADAPTERS FOR BOTH LEGACY AND NEW ENTITIES

    await _doMigration(secureKey!);

    return true;
  }

  static Future<T?> getData<T>(String key) async {
    final box = await Hive.openBox<T>(
      'secureBox',
      encryptionCipher: HiveAesCipher(secureKey!),
    );
    return box.get(key);
  }

  static Future<Box<E>> getBox<E>(String boxName) {
    return Hive.openBox(boxName, encryptionCipher: HiveAesCipher(secureKey!));
  }

  static Future<void> _doMigration(Uint8List secureKey) async {
    const kHiveVersionKey = '__schema_version__';
    const hiveBoxKey = 'app_meta';

    if (!await Hive.boxExists(hiveBoxKey)) {
      // If the version box does not exist, create it with version 0
      // then return
      await getBox<int>(hiveBoxKey).then((box) => box.put(kHiveVersionKey, 0));
      return;
    }

    final meta = await Hive.openBox(
      hiveBoxKey,
      encryptionCipher: HiveAesCipher(secureKey),
    );
    final currentVersion = meta.get(kHiveVersionKey, defaultValue: 0) as int;

    if (currentVersion < 1) {
      await meta.put(kHiveVersionKey, 0);
      final box = await getBox<Settings>("settingsBox");

      Settings? settings = box.get("settings");

      if (settings == null) {
        settings = Settings.initial();
        await box.put("settings", settings);
      }
      await box.clear();
      await box.close();
      final newVersionBox = await getBox<SettingsV1>('settingsBox');

      await newVersionBox.put("settings", SettingsV1.fromPrevVersion(settings));
      await newVersionBox.close();
      await meta.put(kHiveVersionKey, 1);
    }
  }
}
