import 'dart:convert';
import 'dart:typed_data';

import 'package:flow_mobile/domain/entity/bank.dart';
import 'package:flow_mobile/domain/entity/bank_account.dart';
import 'package:flow_mobile/domain/entity/notification.dart';
import 'package:flow_mobile/domain/entity/notification_setting.dart';
import 'package:flow_mobile/domain/entity/paynow_recipient.dart';
import 'package:flow_mobile/domain/entity/setting.dart';
import 'package:flow_mobile/domain/entity/setting_v1.dart';
import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/domain/entity/user.dart';
import 'package:flow_mobile/service/local_source/local_secure_storage.dart';
import 'package:hive_flutter/adapters.dart';

class SecureHive {
  /// Initialize Hive and open the encrypted box
  static Uint8List? secureKey;

  static Future<bool> initHive(SecureStorage secureStorage) async {
    await Hive.initFlutter();

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
