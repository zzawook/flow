import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/data/datasources/datasources.dart';

/// Provider for DataSourceFactory - singleton behavior maintained
final dataSourceFactoryProvider = Provider<DataSourceFactory>((ref) {
  return DataSourceFactory.instance;
});

// Local Data Source Providers

/// Provider for UserLocalDataSource
final userLocalDataSourceProvider = FutureProvider<UserLocalDataSource>((ref) async {
  final factory = ref.read(dataSourceFactoryProvider);
  return await factory.createUserLocalDataSource();
});

/// Provider for TransactionLocalDataSource
final transactionLocalDataSourceProvider = FutureProvider<TransactionLocalDataSource>((ref) async {
  final factory = ref.read(dataSourceFactoryProvider);
  return await factory.createTransactionLocalDataSource();
});

/// Provider for AccountLocalDataSource
final accountLocalDataSourceProvider = FutureProvider<AccountLocalDataSource>((ref) async {
  final factory = ref.read(dataSourceFactoryProvider);
  return await factory.createAccountLocalDataSource();
});

/// Provider for SpendingLocalDataSource
final spendingLocalDataSourceProvider = FutureProvider<SpendingLocalDataSource>((ref) async {
  final factory = ref.read(dataSourceFactoryProvider);
  return await factory.createSpendingLocalDataSource();
});

/// Provider for NotificationLocalDataSource
final notificationLocalDataSourceProvider = FutureProvider<NotificationLocalDataSource>((ref) async {
  final factory = ref.read(dataSourceFactoryProvider);
  return await factory.createNotificationLocalDataSource();
});

/// Provider for SettingsLocalDataSource
final settingsLocalDataSourceProvider = FutureProvider<SettingsLocalDataSource>((ref) async {
  final factory = ref.read(dataSourceFactoryProvider);
  return await factory.createSettingsLocalDataSource();
});

/// Provider for AuthLocalDataSource
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final factory = ref.read(dataSourceFactoryProvider);
  return factory.createAuthLocalDataSource();
});

// Remote Data Source Providers

/// Provider for UserRemoteDataSource
final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  final factory = ref.read(dataSourceFactoryProvider);
  return factory.createUserRemoteDataSource();
});

/// Provider for TransactionRemoteDataSource
final transactionRemoteDataSourceProvider = Provider<TransactionRemoteDataSource>((ref) {
  final factory = ref.read(dataSourceFactoryProvider);
  return factory.createTransactionRemoteDataSource();
});

/// Provider for AccountRemoteDataSource
final accountRemoteDataSourceProvider = Provider<AccountRemoteDataSource>((ref) {
  final factory = ref.read(dataSourceFactoryProvider);
  return factory.createAccountRemoteDataSource();
});

/// Provider for SpendingRemoteDataSource
final spendingRemoteDataSourceProvider = Provider<SpendingRemoteDataSource>((ref) {
  final factory = ref.read(dataSourceFactoryProvider);
  return factory.createSpendingRemoteDataSource();
});

/// Provider for AuthRemoteDataSource
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final factory = ref.read(dataSourceFactoryProvider);
  return factory.createAuthRemoteDataSource();
});

/// Provider for SettingsRemoteDataSource
final settingsRemoteDataSourceProvider = Provider<SettingsRemoteDataSource>((ref) {
  final factory = ref.read(dataSourceFactoryProvider);
  return factory.createSettingsRemoteDataSource();
});

/// Provider for NotificationRemoteDataSource
final notificationRemoteDataSourceProvider = Provider<NotificationRemoteDataSource>((ref) {
  final factory = ref.read(dataSourceFactoryProvider);
  return factory.createNotificationRemoteDataSource();
});