# GoRouter Navigation System

This document explains the new GoRouter-based navigation system that replaces the previous Navigator.pushNamed approach.

## Overview

The new navigation system provides:
- Type-safe navigation with compile-time route validation
- Custom page transitions that match the original animations
- Better integration with modern Flutter patterns
- Maintained compatibility with existing Redux navigation tracking

## Key Files

### Core Router Files
- `app_router.dart` - Main GoRouter configuration with all routes
- `app_navigation.dart` - Type-safe navigation methods
- `router_delegate.dart` - Integration layer with Redux for transition period
- `navigation_compatibility.dart` - Compatibility layer for migration

### Supporting Files
- `app_transitions.dart` - Custom page transitions (unchanged)
- `transition_type.dart` - Transition type definitions (unchanged)
- `go_router_observer.dart` - Navigation observer for GoRouter
- `router_validation.dart` - Validation utilities

## Usage

### Basic Navigation

Instead of:
```dart
Navigator.pushNamed(context, '/home');
```

Use:
```dart
AppNavigation.goToHome(context);
// or
AppNavigation.pushToHome(context);
```

### Navigation with Parameters

Instead of:
```dart
Navigator.pushNamed(
  context, 
  '/account_detail', 
  arguments: CustomPageRouteArguments(
    transitionType: TransitionType.slideLeft,
    extraData: bankAccount,
  ),
);
```

Use:
```dart
AppNavigation.goToAccountDetail(context, bankAccount);
// or
AppNavigation.pushToAccountDetail(context, bankAccount);
```

### Available Navigation Methods

#### Go Methods (Replace current route)
- `AppNavigation.goToHome(context)`
- `AppNavigation.goToSpending(context)`
- `AppNavigation.goToSpendingDetail(context, displayedMonth)`
- `AppNavigation.goToSpendingCategory(context, displayMonthYear)`
- `AppNavigation.goToSpendingCategoryDetail(context, arguments)`
- `AppNavigation.goToFixedSpendingDetails(context, month)`
- `AppNavigation.goToAccountDetail(context, bankAccount)`
- `AppNavigation.goToTransfer(context)`
- `AppNavigation.goToTransferAmount(context)`
- `AppNavigation.goToTransferTo(context)`
- `AppNavigation.goToTransferConfirm(context)`
- `AppNavigation.goToTransferResult(context)`
- `AppNavigation.goToNotification(context)`
- `AppNavigation.goToRefresh(context)`
- `AppNavigation.goToSettings(context)`
- `AppNavigation.goToNotificationSettings(context)`
- `AppNavigation.goToBankAccountsSettings(context)`
- `AppNavigation.goToAccountSettings(context)`
- `AppNavigation.goToAsset(context)`
- `AppNavigation.goToBankAccountSettings(context, bankAccount)`

#### Push Methods (Add to navigation stack)
All the above methods have `push` equivalents:
- `AppNavigation.pushToHome(context)`
- `AppNavigation.pushToSpending(context)`
- etc.

#### Utility Methods
- `AppNavigation.pop(context)` - Pop current screen
- `AppNavigation.canPop(context)` - Check if can pop

## Route Paths

All route paths are defined in `AppRoutePaths`:

```dart
class AppRoutePaths {
  static const home = '/home';
  static const spending = '/spending';
  static const spendingDetail = '/spending/detail';
  static const category = '/spending/category';
  static const categoryDetail = '/spending/category/detail';
  static const fixedSpending = '/fixed_spending/details';
  static const accountDetail = '/account_detail';
  static const transfer = '/transfer';
  static const transferAmount = '/transfer/amount';
  static const transferTo = '/transfer/to';
  static const transferConfirm = '/transfer/confirm';
  static const transferResult = '/transfer/result';
  static const notification = '/notification';
  static const refresh = '/refresh';
  static const setting = '/setting';
  static const notificationSetting = '/notification/setting';
  static const bankAccountSetting = '/bank_account/setting';
  static const bankAccountsSetting = '/bank_accounts/setting';
  static const accountSetting = '/account/setting';
  static const asset = '/asset';
}
```

## Transitions

The new system maintains all existing custom transitions:
- `TransitionType.slideLeft` (default)
- `TransitionType.slideRight`
- `TransitionType.slideTop`
- `TransitionType.slideBottom`

All transitions use the same 150ms duration as the original system.

## Integration with Redux

During the transition period, the GoRouter system maintains compatibility with Redux navigation tracking through `router_delegate.dart`. This ensures that:

1. Navigation events are still dispatched to Redux
2. Screen tracking continues to work
3. Existing Redux-dependent code continues to function

## Migration Strategy

### Phase 1: Setup (Current)
- GoRouter configuration is complete
- Type-safe navigation methods are available
- Compatibility layer is in place

### Phase 2: Gradual Migration
- Replace `Navigator.pushNamed` calls with `AppNavigation` methods
- Use compatibility layer where needed
- Test each screen migration individually

### Phase 3: Full Migration
- Remove old navigation code
- Remove Redux navigation tracking
- Clean up compatibility layer

## Testing

The navigation system includes:
- Unit tests for route configuration
- Widget tests for navigation behavior
- Validation utilities to ensure setup correctness

Run validation:
```dart
import 'package:flow_mobile/presentation/navigation/router_validation.dart';

// In your app initialization or tests
RouterValidation.runAllValidations();
```

## Benefits

1. **Type Safety**: Compile-time validation of routes and parameters
2. **Better Developer Experience**: Auto-completion and parameter validation
3. **Maintainability**: Centralized route definitions and navigation logic
4. **Future-Proof**: Built on Flutter's recommended navigation solution
5. **Performance**: More efficient route management and rebuilding
6. **Web Support**: Ready for web deployment with proper URL handling

## Compatibility

The new system maintains 100% behavioral compatibility with the existing navigation:
- Same route paths
- Same transitions and animations
- Same navigation stack behavior
- Same Redux integration during transition period