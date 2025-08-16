import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/core/providers/providers.dart';

void main() {
  group('Provider Resolution Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should resolve service providers correctly', () {
      // Test service providers can be resolved
      expect(() => container.read(connectionServiceProvider), returnsNormally);
      expect(() => container.read(authServiceProvider), returnsNormally);
      expect(() => container.read(apiServiceProvider), returnsNormally);
      expect(() => container.read(notificationServiceProvider), returnsNormally);
    });

    test('should resolve datasource factory provider correctly', () {
      // Test datasource factory can be resolved
      expect(() => container.read(dataSourceFactoryProvider), returnsNormally);
    });

    test('should resolve auth repository provider correctly', () {
      // Test auth repository (synchronous) can be resolved
      expect(() => container.read(authRepositoryProvider), returnsNormally);
    });

    test('should resolve auth use case providers correctly', () {
      // Test auth use cases (synchronous) can be resolved
      expect(() => container.read(loginUseCaseProvider), returnsNormally);
      expect(() => container.read(logoutUseCaseProvider), returnsNormally);
      expect(() => container.read(getAuthStatusUseCaseProvider), returnsNormally);
      expect(() => container.read(refreshTokenUseCaseProvider), returnsNormally);
    });

    test('should handle async repository providers correctly', () async {
      // Test that async repository providers can be resolved
      expect(() => container.read(userRepositoryProvider.future), returnsNormally);
      expect(() => container.read(transactionRepositoryProvider.future), returnsNormally);
      expect(() => container.read(accountRepositoryProvider.future), returnsNormally);
      expect(() => container.read(spendingRepositoryProvider.future), returnsNormally);
      expect(() => container.read(notificationRepositoryProvider.future), returnsNormally);
      expect(() => container.read(settingsRepositoryProvider.future), returnsNormally);
    });

    test('should handle async use case providers correctly', () async {
      // Test that async use case providers can be resolved
      expect(() => container.read(getUserUseCaseProvider.future), returnsNormally);
      expect(() => container.read(createTransactionUseCaseProvider.future), returnsNormally);
      expect(() => container.read(getAccountsUseCaseProvider.future), returnsNormally);
      expect(() => container.read(getSpendingUseCaseProvider.future), returnsNormally);
      expect(() => container.read(getNotificationsUseCaseProvider.future), returnsNormally);
      expect(() => container.read(getDisplayBalanceUseCaseProvider.future), returnsNormally);
    });

    test('should maintain singleton behavior for services', () {
      // Test that services maintain singleton behavior
      final connectionService1 = container.read(connectionServiceProvider);
      final connectionService2 = container.read(connectionServiceProvider);
      expect(identical(connectionService1, connectionService2), isTrue);

      final authService1 = container.read(authServiceProvider);
      final authService2 = container.read(authServiceProvider);
      expect(identical(authService1, authService2), isTrue);
    });

    test('should provide proper dependency injection', () {
      // Test that dependencies are properly injected
      final apiService = container.read(apiServiceProvider);
      expect(apiService, isNotNull);
      
      final syncService = container.read(syncServiceProvider);
      expect(syncService, isNotNull);
      
      final authRepository = container.read(authRepositoryProvider);
      expect(authRepository, isNotNull);
    });
  });

  group('Provider Initialization Tests', () {
    test('should initialize Hive correctly', () async {
      final container = ProviderContainer();
      
      // Test that Hive initialization function exists and can be called
      expect(() => initializeHive(container), returnsNormally);
      
      container.dispose();
    });
  });
}