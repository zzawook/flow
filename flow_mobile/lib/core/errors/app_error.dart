import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_error.freezed.dart';

/// Centralized error types using Freezed for the application
/// Maintains compatibility with existing error handling behavior
@freezed
class AppError with _$AppError {
  /// Network-related errors (API calls, connectivity issues)
  const factory AppError.network({
    required String message,
    String? code,
    @Default(false) bool isRetryable,
  }) = NetworkError;

  /// Local storage errors (Hive, secure storage)
  const factory AppError.storage({
    required String message,
    String? code,
  }) = StorageError;

  /// Data validation errors
  const factory AppError.validation({
    required String message,
    String? field,
  }) = ValidationError;

  /// Authentication and authorization errors
  const factory AppError.auth({
    required String message,
    String? code,
  }) = AuthError;

  /// Business logic errors
  const factory AppError.business({
    required String message,
    String? code,
  }) = BusinessError;

  /// Unknown or unexpected errors
  const factory AppError.unknown({
    required String message,
    Object? originalError,
  }) = UnknownError;

  /// Timeout errors
  const factory AppError.timeout({
    @Default('Operation timed out') String message,
  }) = TimeoutError;

  /// Permission errors
  const factory AppError.permission({
    required String message,
    String? permission,
  }) = PermissionError;
}

/// Extension methods for AppError to maintain compatibility with existing String error handling
extension AppErrorExtensions on AppError {
  /// Get user-friendly message for display
  String get displayMessage {
    return when(
      network: (message, code, isRetryable) => message,
      storage: (message, code) => message,
      validation: (message, field) => message,
      auth: (message, code) => message,
      business: (message, code) => message,
      unknown: (message, originalError) => message,
      timeout: (message) => message,
      permission: (message, permission) => message,
    );
  }

  /// Check if error is retryable
  bool get isRetryable {
    return when(
      network: (message, code, isRetryable) => isRetryable,
      storage: (message, code) => false,
      validation: (message, field) => false,
      auth: (message, code) => false,
      business: (message, code) => false,
      unknown: (message, originalError) => false,
      timeout: (message) => true,
      permission: (message, permission) => false,
    );
  }

  /// Get error code if available
  String? get code {
    return when(
      network: (message, code, isRetryable) => code,
      storage: (message, code) => code,
      validation: (message, field) => null,
      auth: (message, code) => code,
      business: (message, code) => code,
      unknown: (message, originalError) => null,
      timeout: (message) => 'TIMEOUT',
      permission: (message, permission) => permission,
    );
  }
}