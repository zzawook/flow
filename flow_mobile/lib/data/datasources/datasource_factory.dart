import 'package:flow_mobile/data/datasources/local/local_datasources.dart';
import 'package:flow_mobile/data/datasources/remote/remote_datasources.dart';
import 'package:flow_mobile/service/local_source/local_secure_hive.dart';
import 'package:flow_mobile/service/local_source/local_secure_storage.dart';
import 'package:flow_mobile/domain/entities/transaction.dart';
import 'package:flow_mobile/domain/entities/user.dart';
import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/domain/entities/notification.dart';
import 'package:flow_mobile/domain/entities/date_spending_statistics.dart';
import 'package:flow_mobile/domain/entity/setting_v1.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Factory class for creating data source instances
/// Manages Hive box initialization and data source creation
class DataSourceFactory {
  static DataSourceFactory? _instance;
  
  // Singleton pattern
  static DataSourceFactory get instance {
    _instance ??= DataSourceFactory._();
    return _instance!;
  }
  
  DataSourceFactory._();

  /// Create transaction local data source with initialized Hive box
  Future<TransactionLocalDataSource> createTransactionLocalDataSource() async {
    final box = await SecureHive.getBox<Transaction>('transaction');
    await box.clear(); // Maintain existing behavior
    final transactionList = box.values.toList();
    
    return TransactionLocalDataSourceImpl(
      transactionBox: box,
      transactionList: transactionList,
    );
  }

  /// Create transaction remote data source
  TransactionRemoteDataSource createTransactionRemoteDataSource() {
    return TransactionRemoteDataSourceImpl();
  }

  /// Create user local data source with initialized Hive box
  Future<UserLocalDataSource> createUserLocalDataSource() async {
    final box = await Hive.openBox<User>('userBox');
    return UserLocalDataSourceImpl(userBox: box);
  }

  /// Create user remote data source
  UserRemoteDataSource createUserRemoteDataSource() {
    return UserRemoteDataSourceImpl();
  }

  /// Create account local data source with initialized Hive box
  Future<AccountLocalDataSource> createAccountLocalDataSource() async {
    final box = await SecureHive.getBox<BankAccount>('bankAccount');
    return AccountLocalDataSourceImpl(bankAccountBox: box);
  }

  /// Create account remote data source
  AccountRemoteDataSource createAccountRemoteDataSource() {
    return AccountRemoteDataSourceImpl();
  }

  /// Create notification local data source with initialized Hive box
  Future<NotificationLocalDataSource> createNotificationLocalDataSource() async {
    final box = await Hive.openBox<Notification>('notificationBox');
    return NotificationLocalDataSourceImpl(notificationBox: box);
  }

  /// Create notification remote data source
  NotificationRemoteDataSource createNotificationRemoteDataSource() {
    return NotificationRemoteDataSourceImpl();
  }

  /// Create spending local data source with initialized Hive box
  Future<SpendingLocalDataSource> createSpendingLocalDataSource() async {
    final box = await Hive.openBox<DateSpendingStatistics>('spendingBox');
    return SpendingLocalDataSourceImpl(spendingBox: box);
  }

  /// Create spending remote data source
  SpendingRemoteDataSource createSpendingRemoteDataSource() {
    return SpendingRemoteDataSourceImpl();
  }

  /// Create settings local data source with initialized Hive box
  Future<SettingsLocalDataSource> createSettingsLocalDataSource() async {
    final box = await Hive.openBox<SettingsV1>('settingsBox');
    await box.put('settings', SettingsV1.initial()); // Maintain existing behavior
    return SettingsLocalDataSourceImpl(settingsBox: box);
  }

  /// Create settings remote data source
  SettingsRemoteDataSource createSettingsRemoteDataSource() {
    return SettingsRemoteDataSourceImpl();
  }

  /// Create auth local data source with secure storage
  AuthLocalDataSource createAuthLocalDataSource() {
    final secureStorage = SecureStorage();
    return AuthLocalDataSourceImpl(secureStorage: secureStorage);
  }

  /// Create auth remote data source
  AuthRemoteDataSource createAuthRemoteDataSource() {
    return AuthRemoteDataSourceImpl();
  }
}