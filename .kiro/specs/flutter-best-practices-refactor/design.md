# Design Document

## Overview

This design outlines the refactoring of the existing Flutter financial application from a Redux-based architecture to a modern, clean architecture following Flutter best practices. The refactoring will transition from Redux + GetIt to Riverpod for state management and dependency injection, implement GoRouter for navigation, and restructure the codebase using clean architecture principles while maintaining 100% functional and visual compatibility.

## Architecture

### Current Architecture Analysis
- **State Management**: Redux with flutter_redux and redux_thunk
- **Dependency Injection**: GetIt with manual service/manager registration
- **Navigation**: Manual route management with custom transitions
- **Data Layer**: Hive for local storage, HTTP for API calls
- **Structure**: Domain-driven with managers, services, and entities

### Target Architecture: Clean Architecture with Riverpod

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
│  ┌─────────────────┐  ┌─────────────────┐  ┌──────────────┐ │
│  │     Screens     │  │     Widgets     │  │  Controllers │ │
│  │   (StatefulW)   │  │  (StatelessW)   │  │  (Notifiers) │ │
│  └─────────────────┘  └─────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                     Domain Layer                            │
│  ┌─────────────────┐  ┌─────────────────┐  ┌──────────────┐ │
│  │    Entities     │  │   Use Cases     │  │ Repositories │ │
│  │   (Models)      │  │  (Business      │  │ (Interfaces) │ │
│  │                 │  │   Logic)        │  │              │ │
│  └─────────────────┘  └─────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                      Data Layer                             │
│  ┌─────────────────┐  ┌─────────────────┐  ┌──────────────┐ │
│  │  Repositories   │  │  Data Sources   │  │    Models    │ │
│  │ (Implementations│  │ (Local/Remote)  │  │    (DTOs)    │ │
│  │                 │  │                 │  │              │ │
│  └─────────────────┘  └─────────────────┘  └──────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

### Key Architectural Changes

#### 1. State Management Migration: Redux → Riverpod

**Justification:**
- **Flutter Ecosystem Alignment**: Redux is primarily a React pattern; Riverpod is built specifically for Flutter/Dart with better integration
- **Reduced Boilerplate**: Redux requires actions, reducers, middleware setup; Riverpod providers are more concise and type-safe
- **Better Performance**: Riverpod's selective rebuilding is more efficient than Redux's global state updates
- **Compile-time Safety**: Riverpod provides compile-time dependency resolution vs Redux's runtime string-based action dispatching
- **Easier Testing**: Riverpod providers can be easily overridden for testing without complex store mocking
- **Modern Flutter Standard**: Riverpod is actively maintained by the Flutter community and follows current Dart patterns

**Migration Benefits:**
- Replace Redux store with Riverpod providers
- Convert Redux actions/reducers to Riverpod notifiers
- Maintain identical state behavior and data flow
- Eliminate redux_thunk complexity with native async support

#### 2. Navigation Modernization: Custom routing → GoRouter

**Justification:**
- **Official Flutter Recommendation**: GoRouter is now the recommended navigation solution by the Flutter team
- **Type Safety**: Current string-based routing is error-prone; GoRouter provides compile-time route validation
- **Declarative Routing**: GoRouter's declarative approach is more maintainable than imperative navigation
- **Deep Linking Support**: Built-in support for web URLs and deep linking without additional configuration
- **Route Guards**: Built-in authentication and authorization guards vs custom implementation
- **Better Web Support**: Proper browser history and URL management for web deployment
- **Nested Navigation**: Better support for complex navigation patterns like tab bars with sub-routes

**Migration Benefits:**
- Implement type-safe navigation with GoRouter
- Preserve all existing transitions and animations through custom page builders
- Maintain identical navigation behavior with improved maintainability
- Future-proof for web deployment and deep linking

#### 3. Dependency Injection Enhancement: GetIt → Riverpod DI

**Justification:**
- **Unified Architecture**: Using Riverpod for both state management and DI creates a cohesive architecture
- **Compile-time Safety**: Riverpod providers are resolved at compile-time vs GetIt's runtime service location
- **Automatic Disposal**: Riverpod automatically manages provider lifecycle vs manual GetIt disposal
- **Better Testing**: Providers can be easily overridden in tests without global state mutation
- **Scoped Dependencies**: Riverpod supports scoped providers for better memory management
- **No Service Locator Anti-pattern**: Eliminates the service locator pattern in favor of dependency injection
- **Reactive Dependencies**: Providers can react to other provider changes automatically

**Migration Benefits:**
- Replace GetIt registration with Riverpod providers
- Implement proper abstractions and interfaces with compile-time validation
- Maintain singleton behavior where needed through provider scoping
- Eliminate manual service registration complexity

## Components and Interfaces

### 1. Presentation Layer Components

#### Screen Structure
```dart
// Before: StatefulWidget with Redux StoreConnector
class HomeScreen extends StatefulWidget with Redux integration

// After: ConsumerStatefulWidget with Riverpod
class HomeScreen extends ConsumerStatefulWidget {
  // Identical UI and behavior
  // State management via Riverpod providers
}
```

#### Widget Organization
- **Atomic Components**: Smallest reusable UI elements (buttons, inputs)
- **Molecular Components**: Combinations of atoms (cards, forms)
- **Organism Components**: Complex UI sections (top bars, navigation)
- **Screen Components**: Full screen implementations

#### State Management Pattern
```dart
// Provider definitions
final userStateProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier(ref.read(userRepositoryProvider));
});

// Screen consumption
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userStateProvider);
    // Identical UI rendering logic
  }
}
```

### 2. Domain Layer Components

#### Entities (Unchanged)
- Maintain existing entity classes (User, Transaction, BankAccount, etc.)
- Add freezed annotations for immutability and code generation
- Preserve all existing properties and methods

#### Use Cases (New Layer)
```dart
abstract class GetUserTransactionsUseCase {
  Future<List<Transaction>> execute(String userId);
}

class GetUserTransactionsUseCaseImpl implements GetUserTransactionsUseCase {
  final TransactionRepository repository;
  // Business logic implementation
}
```

#### Repository Interfaces
```dart
abstract class TransactionRepository {
  Future<List<Transaction>> getTransactions(String userId);
  Future<void> saveTransaction(Transaction transaction);
  // All existing manager methods as repository methods
}
```

### 3. Data Layer Components

#### Repository Implementations
```dart
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;
  final TransactionRemoteDataSource remoteDataSource;
  
  // Implement all methods using existing service logic
}
```

#### Data Sources
- **Local Data Sources**: Hive-based implementations (existing logic)
- **Remote Data Sources**: HTTP-based implementations (existing logic)
- **Cache Management**: Maintain existing caching behavior

### 4. Navigation System

#### GoRouter Configuration
```dart
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
        // Preserve existing transitions
      ),
      // All existing routes with identical behavior
    ],
  );
});
```

## Data Models

### Entity Models (Enhanced)
```dart
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    // All existing properties
  }) = _User;
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

### State Models
```dart
@freezed
class UserState with _$UserState {
  const factory UserState({
    @Default([]) List<User> users,
    @Default(false) bool isLoading,
    String? error,
    // Mirror existing Redux state structure
  }) = _UserState;
}
```

### Data Transfer Objects
- Maintain existing JSON serialization logic
- Add json_annotation for code generation
- Preserve all existing API contracts

## Error Handling

### Centralized Error Management
```dart
@freezed
class AppError with _$AppError {
  const factory AppError.network(String message) = NetworkError;
  const factory AppError.storage(String message) = StorageError;
  const factory AppError.validation(String message) = ValidationError;
  // All existing error types
}

class ErrorHandler {
  static void handleError(AppError error, WidgetRef ref) {
    // Maintain existing error display behavior
  }
}
```

### Error State Management
- Implement consistent error states across all providers
- Maintain existing user-facing error messages
- Preserve error recovery mechanisms

## Testing Strategy

### Unit Testing Structure
```
test/
├── domain/
│   ├── entities/
│   ├── use_cases/
│   └── repositories/
├── data/
│   ├── repositories/
│   ├── data_sources/
│   └── models/
└── presentation/
    ├── providers/
    └── widgets/
```

### Testing Approach
1. **Unit Tests**: All business logic and data operations
2. **Widget Tests**: UI components in isolation
3. **Integration Tests**: Complete user flows
4. **Provider Tests**: State management behavior

### Mockable Dependencies
- All repository interfaces will be easily mockable
- Data sources will have test implementations
- External services will be abstracted behind interfaces

## Migration Strategy

### Phase 1: Foundation Setup
- Add new dependencies (Riverpod, GoRouter, Freezed)
- Set up new folder structure alongside existing code
- Create base interfaces and abstract classes

### Phase 2: Data Layer Migration
- Implement repository interfaces
- Create data source abstractions
- Migrate existing service logic to new structure

### Phase 3: Domain Layer Implementation
- Create use cases for business logic
- Implement repository implementations
- Add entity enhancements with Freezed

### Phase 4: State Management Migration
- Create Riverpod providers for each Redux state slice
- Implement state notifiers with identical behavior
- Maintain existing state structure and transitions

### Phase 5: Presentation Layer Refactoring
- Convert screens to ConsumerWidgets
- Implement GoRouter navigation
- Preserve all UI components and styling

### Phase 6: Integration and Testing
- Remove old Redux/GetIt code
- Comprehensive testing of all functionality
- Performance validation

## Performance Considerations

### State Management Optimization
- Use Riverpod's selective rebuilding capabilities
- Implement proper provider scoping
- Maintain existing performance characteristics

### Memory Management
- Preserve existing singleton patterns where appropriate
- Implement proper provider disposal
- Maintain existing caching strategies

### Build Performance
- Use code generation to reduce runtime overhead
- Implement proper const constructors
- Maintain existing widget rebuild optimization

## Compatibility Requirements

### Functional Compatibility
- All user interactions must behave identically
- All business logic must produce identical results
- All data persistence must work identically

### Visual Compatibility
- All screens must look pixel-perfect identical
- All animations and transitions must be preserved
- All styling and theming must remain unchanged

### Performance Compatibility
- App startup time must remain the same or improve
- Screen navigation must maintain existing speed
- Data operations must maintain existing performance