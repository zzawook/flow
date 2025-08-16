# Riverpod Providers Migration Guide

This guide explains how to migrate from GetIt service registration to Riverpod providers for dependency injection.

## Overview

The Riverpod providers replace the existing GetIt service registration system with a more modern, type-safe, and testable dependency injection solution.

## Provider Structure

### Service Providers (`service_providers.dart`)
- Replace GetIt service registration from `service_registry.dart`
- Maintain singleton behavior for all services
- Handle Hive initialization through `initializeHive()` function

### DataSource Providers (`datasource_providers.dart`)
- Use the existing `DataSourceFactory` for proper Hive box initialization
- Support both local and remote data sources
- Handle async initialization for local data sources that require Hive boxes

### Repository Providers (`repository_providers.dart`)
- Create repository implementations using data source providers
- Support async initialization for repositories that depend on async data sources
- Maintain clean architecture separation

### Use Case Providers (`usecase_providers.dart`)
- Create use case implementations using repository providers
- Support async initialization for use cases that depend on async repositories
- Provide business logic layer access

## Migration Steps

### 1. Replace GetIt Registration

**Before (GetIt):**
```dart
// In service_registry.dart
getIt.registerSingleton<ConnectionService>(ConnectionService());
getIt.registerSingleton<AuthService>(
  AuthService(localSecureStorageService: getIt<LocalSecureStorageService>()),
);

// Usage
final authService = getIt<AuthService>();
```

**After (Riverpod):**
```dart
// In service_providers.dart
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(
    localSecureStorageService: ref.read(localSecureStorageServiceProvider),
  );
});

// Usage in ConsumerWidget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.read(authServiceProvider);
    // Use authService
  }
}
```

### 2. Handle Async Dependencies

**For async repositories and use cases:**
```dart
// Repository provider (async)
final userRepositoryProvider = FutureProvider<UserRepository>((ref) async {
  final localDataSource = await ref.read(userLocalDataSourceProvider.future);
  final remoteDataSource = ref.read(userRemoteDataSourceProvider);
  
  return UserRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );
});

// Usage in ConsumerWidget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userRepositoryAsync = ref.watch(userRepositoryProvider);
    
    return userRepositoryAsync.when(
      data: (repository) {
        // Use repository
        return Text('Repository loaded');
      },
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

### 3. App Initialization

**Before (GetIt):**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  await initManagers();
  runApp(MyApp());
}
```

**After (Riverpod):**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final container = ProviderContainer();
  await initializeHive(container);
  
  runApp(
    ProviderScope(
      parent: container,
      child: MyApp(),
    ),
  );
}
```

### 4. Testing with Providers

```dart
void main() {
  group('Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should resolve providers correctly', () {
      final authService = container.read(authServiceProvider);
      expect(authService, isNotNull);
    });

    test('should override providers for testing', () {
      final container = ProviderContainer(
        overrides: [
          authServiceProvider.overrideWithValue(MockAuthService()),
        ],
      );

      final authService = container.read(authServiceProvider);
      expect(authService, isA<MockAuthService>());
    });
  });
}
```

## Benefits of Migration

1. **Type Safety**: Compile-time dependency resolution vs runtime service location
2. **Better Testing**: Easy provider overriding for mocking dependencies
3. **Automatic Disposal**: Providers are automatically disposed when no longer needed
4. **Reactive Dependencies**: Providers can react to other provider changes
5. **No Service Locator Anti-pattern**: Proper dependency injection instead of service location
6. **Scoped Dependencies**: Better memory management with provider scoping
7. **Flutter Integration**: Built specifically for Flutter with better widget integration

## Current Status

✅ Service providers - Complete
✅ DataSource providers - Complete  
✅ Repository providers - Complete (except Bank and Transfer repositories)
✅ Use case providers - Complete (except Bank and Transfer use cases)
⏳ Bank and Transfer providers - TODO: Create missing repository implementations
✅ Provider tests - Complete
✅ Migration guide - Complete

## Next Steps

1. Create `BankRepositoryImpl` and `TransferRepositoryImpl`
2. Uncomment bank and transfer providers
3. Update app initialization to use Riverpod
4. Migrate screens to use ConsumerWidget/ConsumerStatefulWidget
5. Remove GetIt dependencies