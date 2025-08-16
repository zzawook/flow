import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flow_mobile/core/errors/app_error.dart';
import 'package:flow_mobile/core/errors/error_handler.dart';

part 'loading_state.freezed.dart';

/// Generic loading state that can be used across all providers
/// Maintains compatibility with existing isLoading and error patterns
@freezed
class LoadingState<T> with _$LoadingState<T> {
  /// Initial state - no data loaded yet
  const factory LoadingState.initial() = LoadingInitial<T>;

  /// Loading state - operation in progress
  const factory LoadingState.loading() = LoadingInProgress<T>;

  /// Success state - data loaded successfully
  const factory LoadingState.success(T data) = LoadingSuccess<T>;

  /// Error state - operation failed
  const factory LoadingState.error(AppError error) = LoadingError<T>;
}

/// Extension methods for LoadingState to maintain compatibility with existing patterns
extension LoadingStateExtensions<T> on LoadingState<T> {
  /// Check if currently loading
  bool get isLoading => this is LoadingInProgress<T>;

  /// Check if has error
  bool get hasError => this is LoadingError<T>;

  /// Check if has data
  bool get hasData => this is LoadingSuccess<T>;

  /// Check if is initial state
  bool get isInitial => this is LoadingInitial<T>;

  /// Get data if available, null otherwise
  T? get data => whenOrNull(success: (data) => data);

  /// Get error if available, null otherwise
  AppError? get error => whenOrNull(error: (error) => error);

  /// Get error message as string for compatibility with existing code
  String get errorMessage => error?.displayMessage ?? '';

  /// Convert to boolean loading state for compatibility
  bool get loadingFlag => isLoading;

  /// Convert to string error for compatibility
  String get errorString => errorMessage;
}

/// Simple loading state without data for operations that don't return data
typedef SimpleLoadingState = LoadingState<void>;

/// Helper methods for creating common loading states
class LoadingStateHelper {
  /// Create initial state
  static LoadingState<T> initial<T>() => const LoadingState.initial();

  /// Create loading state
  static LoadingState<T> loading<T>() => const LoadingState.loading();

  /// Create success state
  static LoadingState<T> success<T>(T data) => LoadingState.success(data);

  /// Create error state
  static LoadingState<T> error<T>(AppError error) => LoadingState.error(error);

  /// Create error state from exception
  static LoadingState<T> errorFromException<T>(Object exception) {
    return LoadingState.error(ErrorHandler.fromException(exception));
  }

  /// Create simple loading states for operations without return data
  static SimpleLoadingState simpleInitial() => const LoadingState.initial();
  static SimpleLoadingState simpleLoading() => const LoadingState.loading();
  static SimpleLoadingState simpleSuccess() => const LoadingState.success(null);
  static SimpleLoadingState simpleError(AppError error) => LoadingState.error(error);
}