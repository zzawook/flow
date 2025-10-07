import 'dart:convert';
import 'dart:typed_data';

import 'package:flow_mobile/domain/entity/bank.dart';
import 'package:flow_mobile/domain/entity/bank_account.dart';
import 'package:flow_mobile/domain/entity/card.dart';
import 'package:flow_mobile/domain/entity/notification.dart';
import 'package:flow_mobile/domain/entity/notification_setting.dart';
import 'package:flow_mobile/domain/entity/paynow_recipient.dart';
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

    Hive.registerAdapter(SettingsV1Adapter());
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(BankAccountAdapter());
    Hive.registerAdapter(BankAdapter());
    Hive.registerAdapter(TransactionAdapter());
    Hive.registerAdapter(PayNowRecipientAdapter());
    Hive.registerAdapter(NotificationAdapter());
    Hive.registerAdapter(NotificationSettingAdapter());
    Hive.registerAdapter(CardAdapter());

    // ADD ADAPTERS FOR BOTH LEGACY AND NEW ENTITIES

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
    // Hive.deleteBoxFromDisk(boxName); // For development only
    return Hive.openBox(boxName, encryptionCipher: HiveAesCipher(secureKey!));
  }
}
