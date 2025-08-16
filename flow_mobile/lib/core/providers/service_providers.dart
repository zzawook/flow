import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/service/local_source/local_secure_hive.dart';
import 'package:flow_mobile/service/local_source/local_secure_storage.dart';
import 'package:flow_mobile/service/api_service.dart';
import 'package:flow_mobile/service/auth_service.dart';
import 'package:flow_mobile/service/connection_service.dart';
import 'package:flow_mobile/service/local_database_service.dart';
import 'package:flow_mobile/service/local_secure_storage_service.dart';
import 'package:flow_mobile/service/notification_service.dart';
import 'package:flow_mobile/service/sync_service.dart';

/// Provider for SecureStorage - singleton behavior maintained
final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage();
});

/// Provider for ConnectionService - singleton behavior maintained
final connectionServiceProvider = Provider<ConnectionService>((ref) {
  return ConnectionService();
});

/// Provider for LocalSecureStorageService - singleton behavior maintained
final localSecureStorageServiceProvider = Provider<LocalSecureStorageService>((ref) {
  return LocalSecureStorageService(
    localSecureStorage: ref.read(secureStorageProvider),
  );
});

/// Provider for LocalDatabaseService - singleton behavior maintained
final localDatabaseServiceProvider = Provider<LocalDatabaseService>((ref) {
  return LocalDatabaseService(
    localSecureStorageService: ref.read(localSecureStorageServiceProvider),
  );
});

/// Provider for AuthService - singleton behavior maintained
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    localSecureStorageService: ref.read(localSecureStorageServiceProvider),
  );
});

/// Provider for ApiService - singleton behavior maintained
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService(
    connectionService: ref.read(connectionServiceProvider),
    authService: ref.read(authServiceProvider),
  );
});

/// Provider for SyncService - singleton behavior maintained
final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    apiService: ref.read(apiServiceProvider),
  );
});

/// Provider for NotificationService - singleton behavior maintained
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

/// Initialize Hive with SecureStorage
/// This replaces the initServices() function from service_registry.dart
Future<void> initializeHive(ProviderContainer container) async {
  final secureStorage = container.read(secureStorageProvider);
  await SecureHive.initHive(secureStorage);
}