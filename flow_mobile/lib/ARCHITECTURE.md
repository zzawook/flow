# Clean Architecture Structure

This document describes the new clean architecture folder structure and import conventions for the Flutter app.

## Folder Structure

```
lib/
├── core/                           # Core utilities and shared components
│   ├── constants/                  # Application constants
│   ├── errors/                     # Error handling and types
│   ├── utils/                      # Utility functions (re-exports from utils/)
│   └── core.dart                   # Core barrel export
├── data/                           # Data layer (external concerns)
│   ├── datasources/               # Data source abstractions
│   │   ├── local/                 # Local data sources (Hive, SharedPrefs)
│   │   └── remote/                # Remote data sources (API, HTTP)
│   ├── models/                    # Data models (DTOs)
│   ├── repositories/              # Repository implementations
│   └── data.dart                  # Data layer barrel export
├── domain/                        # Domain layer (business logic)
│   ├── entities/                  # Domain entities (business objects)
│   ├── repositories/              # Repository interfaces
│   ├── usecases/                  # Use cases (business logic operations)
│   └── domain.dart                # Domain layer barrel export
├── presentation/                  # Presentation layer (UI)
│   ├── providers/                 # Riverpod providers
│   ├── screens/                   # Screen widgets
│   ├── widgets/                   # Reusable UI components
│   ├── navigation/                # Navigation configuration
│   └── presentation.dart          # Presentation layer barrel export
└── flow_mobile.dart               # Main application barrel export
```

## Import Conventions

### Barrel Exports
Use barrel exports to simplify imports and create clear module boundaries:

```dart
// Instead of multiple imports:
import 'package:flow_mobile/domain/entities/user.dart';
import 'package:flow_mobile/domain/entities/transaction.dart';
import 'package:flow_mobile/domain/entities/account.dart';

// Use barrel export:
import 'package:flow_mobile/domain/entities/entities.dart';
```

### Layer Dependencies
Follow clean architecture dependency rules:

```dart
// ✅ Presentation can import Domain and Core
import 'package:flow_mobile/domain/domain.dart';
import 'package:flow_mobile/core/core.dart';

// ✅ Data can import Domain and Core
import 'package:flow_mobile/domain/domain.dart';
import 'package:flow_mobile/core/core.dart';

// ✅ Domain can import Core
import 'package:flow_mobile/core/core.dart';

// ❌ Domain should NOT import Data or Presentation
// ❌ Core should NOT import any other layers
```

### Main Application Import
For external packages or main.dart, use the main barrel export:

```dart
import 'package:flow_mobile/flow_mobile.dart';
```

## Migration Notes

- Existing code in `domain/entity/`, `domain/manager/`, `service/`, and `utils/` folders will be gradually migrated to the new structure
- Barrel exports are set up to re-export existing code during the transition
- New implementations will follow the clean architecture pattern
- Legacy Redux code in `domain/redux/` will be replaced with Riverpod providers

## Key Benefits

1. **Clear Separation of Concerns**: Each layer has a specific responsibility
2. **Dependency Inversion**: High-level modules don't depend on low-level modules
3. **Testability**: Business logic is isolated and easily testable
4. **Maintainability**: Code is organized in a logical, predictable structure
5. **Scalability**: New features can be added following established patterns