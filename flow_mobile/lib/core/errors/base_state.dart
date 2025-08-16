import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flow_mobile/core/errors/app_error.dart';
import 'package:flow_mobile/core/errors/error_handler.dart';

part 'base_state.freezed.dart';

/// Base state mixin that provides consistent error handling and loading states
/// Can be mixed into any state model to provide standard error/loading functionality
mixin BaseStateMixin {
  /// Loading state flag
  bool get isLoading;
  
  /// Error state
  AppError? get error;
  
  /// Check if state has error
  bool get hasError => error != null;
  
  /// Get error message as string for compatibility
  String get errorMessage => error?.displayMessage ?? '';
  
  /// Check if state is in a valid state (not loading, no error)
  bool get isValid => !isLoading && !hasError;
}

/// Generic async state that wraps any data with loading and error states
@freezed
class AsyncState<T> with _$AsyncState<T>, BaseStateMixin {
  const factory AsyncState.loading() = AsyncLoading<T>;
  
  const factory AsyncState.data(T value) = AsyncData<T>;
  
  const factory AsyncState.error(AppError error) = AsyncError<T>;
  
  const AsyncState._();
  
  @override
  bool get isLoading => this is AsyncLoading<T>;
  
  @override
  AppError? get error => whenOrNull(error: (error) => error);
  
  /// Get data if available
  T? get value => whenOrNull(data: (value) => value);
  
  /// Check if has data
  bool get hasData => this is AsyncData<T>;
  
  /// Get data or throw if not available
  T get requireValue => when(
    loading: () => throw StateError('Data not available while loading'),
    data: (value) => value,
    error: (error) => throw StateError('Data not available due to error: ${error.displayMessage}'),
  );
}

/// Extension methods for AsyncState to provide additional functionality
extension AsyncStateExtensions<T> on AsyncState<T> {
  /// Map the data value if present
  AsyncState<R> map<R>(R Function(T) mapper) {
    return when(
      loading: () => const AsyncState.loading(),
      data: (value) => AsyncState.data(mapper(value)),
      error: (error) => AsyncState.error(error),
    );
  }
  
  /// Transform to another AsyncState
  AsyncState<R> flatMap<R>(AsyncState<R> Function(T) mapper) {
    return when(
      loading: () => const AsyncState.loading(),
      data: (value) => mapper(value),
      error: (error) => AsyncState.error(error),
    );
  }
  
  /// Provide a default value when in error or loading state
  T valueOr(T defaultValue) {
    return when(
      loading: () => defaultValue,
      data: (value) => value,
      error: (error) => defaultValue,
    );
  }
  
  /// Convert to nullable value
  T? get valueOrNull => whenOrNull(data: (value) => value);
}

/// Helper methods for creating AsyncState instances
class AsyncStateHelper {
  static AsyncState<T> loading<T>() => const AsyncState.loading();
  
  static AsyncState<T> data<T>(T value) => AsyncState.data(value);
  
  static AsyncState<T> error<T>(AppError error) => AsyncState.error(error);
  
  static AsyncState<T> fromException<T>(Object exception) {
    return AsyncState.error(ErrorHandler.fromException(exception));
  }
}

/// Simple state for operations that don't return data
typedef SimpleAsyncState = AsyncState<void>;

/// Helper for simple async operations
class SimpleAsyncStateHelper {
  static SimpleAsyncState loading() => const AsyncState.loading();
  
  static SimpleAsyncState success() => const AsyncState.data(null);
  
  static SimpleAsyncState error(AppError error) => AsyncState.error(error);
  
  static SimpleAsyncState fromException(Object exception) {
    return AsyncState.error(ErrorHandler.fromException(exception));
  }
}