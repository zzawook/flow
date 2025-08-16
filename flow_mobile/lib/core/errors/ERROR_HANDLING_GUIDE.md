# Error Handling and Loading States Guide

This guide explains how to use the new centralized error handling and loading states system while maintaining compatibility with existing UI behavior.

## Overview

The new error handling system provides:
- **Centralized Error Types**: Using Freezed for type-safe error handling
- **Consistent Loading States**: Standardized loading patterns across providers
- **Error Recovery**: Automatic retry mechanisms with exponential backoff
- **UI Compatibility**: Maintains existing error display behavior

## Core Components

### 1. AppError Types

```dart
// Network errors with retry capability
AppError.network(
  message: 'Failed to load data',
  code: 'NETWORK_ERROR',
  isRetryable: true,
)

// Validation errors
AppError.validation(
  message: 'Invalid email format',
  field: 'email',
)

// Authentication errors
AppError.auth(
  message: 'Session expired',
  code: 'TOKEN_EXPIRED',
)
```

### 2. Loading States

```dart
// Simple loading state
LoadingState<List<Transaction>>.loading()
LoadingState<List<Transaction>>.success(transactions)
LoadingState<List<Transaction>>.error(appError)

// Async state for complex operations
AsyncState<User>.loading()
AsyncState<User>.data(user)
AsyncState<User>.error(appError)
```

### 3. Error Recovery

```dart
// Automatic retry with exponential backoff
await executeWithRecovery(() => apiCall());

// Custom recovery configuration
await executeWithRecovery(
  () => apiCall(),
  config: ErrorRecoveryConfig(
    strategy: RecoveryStrategy.retryWithBackoff,
    maxRetries: 3,
  ),
);
```

## Usage Patterns

### 1. Provider Implementation

```dart
class TransactionNotifier extends StateNotifier<TransactionStateModel> 
    with ErrorRecoveryMixin {
  
  Future<void> loadTransactions() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final transactions = await executeWithRecovery(
        () => _getTransactionsUseCase.execute(),
      );
      
      state = state.copyWith(
        transactions: transactions,
        isLoading: false,
      );
    } catch (e) {
      final appError = ErrorHandler.fromException(e);
      state = state.copyWith(
        isLoading: false,
        error: appError,
      );
    }
  }
}
```

### 2. State Model with Error Handling

```dart
@freezed
class TransactionStateModel with _$TransactionStateModel, BaseStateMixin {
  const factory TransactionStateModel({
    @Default([]) List<Transaction> transactions,
    @Default(false) bool isLoading,
    AppError? error,
  }) = _TransactionStateModel;

  const TransactionStateModel._();
}
```

### 3. UI Error Display

```dart
// Using the error display widget
ErrorDisplayWidget(
  error: state.error,
  onRetry: () => ref.read(transactionNotifierProvider.notifier).loadTransactions(),
)

// Using state display widget for complete state handling
StateDisplayWidget<List<Transaction>>(
  state: asyncTransactionState,
  builder: (transactions) => TransactionList(transactions: transactions),
  onRetry: () => loadTransactions(),
  loadingText: 'Loading transactions...',
)

// Manual error handling
if (state.hasError) {
  ref.showErrorSnackbar(
    state.error!,
    onRetry: () => loadTransactions(),
  );
}
```

## Migration from Existing Code

### 1. String Error to AppError

```dart
// Before
state = state.copyWith(error: e.toString());

// After
final appError = ErrorHandler.fromException(e);
state = state.copyWith(error: appError);
```

### 2. Error Display

```dart
// Before
if (state.error.isNotEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(state.error)),
  );
}

// After
if (state.hasError) {
  ErrorHandler.handleError(state.error!, context);
}
```

### 3. Loading States

```dart
// Before
if (state.isLoading) {
  return CircularProgressIndicator();
}

// After
LoadingIndicatorWidget(
  isLoading: state.isLoading,
  loadingText: 'Loading...',
)
```

## Error Recovery Strategies

### 1. Network Errors
- **Strategy**: Retry with exponential backoff
- **Max Retries**: 3
- **User Message**: Shows retry button in snackbar

### 2. Authentication Errors
- **Strategy**: Refresh auth token and retry
- **Max Retries**: 1
- **User Message**: "Session expired, please try again"

### 3. Validation Errors
- **Strategy**: Show error immediately
- **Max Retries**: 0
- **User Message**: Specific validation message

### 4. Storage Errors
- **Strategy**: Clear cache and retry
- **Max Retries**: 2
- **User Message**: "Storage issue, retrying..."

## Best Practices

### 1. Provider Error Handling
- Always use `ErrorRecoveryMixin` for providers that make async calls
- Set loading state before operations
- Clear error state on successful operations
- Provide retry methods for user-initiated retries

### 2. State Models
- Use `BaseStateMixin` for consistent error/loading patterns
- Use `AppError?` instead of `String` for error fields
- Provide computed properties for compatibility

### 3. UI Components
- Use `ErrorDisplayWidget` for consistent error display
- Use `StateDisplayWidget` for complete state handling
- Provide retry callbacks for retryable errors
- Show loading indicators during async operations

### 4. Error Messages
- Keep messages user-friendly and actionable
- Provide specific error information when helpful
- Use consistent terminology across the app
- Include retry options for recoverable errors

## Compatibility

The new error handling system maintains full compatibility with existing code:

- **String Errors**: Automatically converted to AppError types
- **Loading States**: Existing boolean flags still work
- **UI Behavior**: Snackbars and error displays work identically
- **Error Messages**: Same user-facing messages are displayed

## Testing

```dart
// Test error handling
test('should handle network error with retry', () async {
  // Arrange
  when(() => useCase.execute()).thenThrow(SocketException('No internet'));
  
  // Act
  await notifier.loadData();
  
  // Assert
  expect(notifier.state.hasError, true);
  expect(notifier.state.error, isA<NetworkError>());
  expect(notifier.state.error!.isRetryable, true);
});

// Test error recovery
test('should retry on retryable error', () async {
  // Arrange
  when(() => useCase.execute())
    .thenThrow(SocketException('No internet'))
    .thenReturn(mockData);
  
  // Act
  await notifier.retryLastOperation();
  
  // Assert
  expect(notifier.state.hasError, false);
  expect(notifier.state.data, equals(mockData));
});
```

This error handling system provides a robust foundation for handling errors consistently across the application while maintaining the existing user experience.