import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/core/errors/app_error.dart';
import 'package:flow_mobile/core/errors/error_handler.dart';

/// Error recovery strategies
enum RecoveryStrategy {
  /// Retry the operation immediately
  retry,
  /// Retry with exponential backoff
  retryWithBackoff,
  /// Refresh authentication and retry
  refreshAuthAndRetry,
  /// Clear cache and retry
  clearCacheAndRetry,
  /// Show error to user and don't retry
  showError,
  /// Ignore the error
  ignore,
}

/// Error recovery configuration
class ErrorRecoveryConfig {
  final RecoveryStrategy strategy;
  final int maxRetries;
  final Duration initialDelay;
  final Duration maxDelay;
  final bool showUserMessage;

  const ErrorRecoveryConfig({
    required this.strategy,
    this.maxRetries = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.maxDelay = const Duration(seconds: 30),
    this.showUserMessage = true,
  });

  /// Default recovery config for network errors
  static const network = ErrorRecoveryConfig(
    strategy: RecoveryStrategy.retryWithBackoff,
    maxRetries: 3,
    showUserMessage: true,
  );

  /// Default recovery config for auth errors
  static const auth = ErrorRecoveryConfig(
    strategy: RecoveryStrategy.refreshAuthAndRetry,
    maxRetries: 1,
    showUserMessage: true,
  );

  /// Default recovery config for validation errors
  static const validation = ErrorRecoveryConfig(
    strategy: RecoveryStrategy.showError,
    maxRetries: 0,
    showUserMessage: true,
  );

  /// Default recovery config for storage errors
  static const storage = ErrorRecoveryConfig(
    strategy: RecoveryStrategy.clearCacheAndRetry,
    maxRetries: 2,
    showUserMessage: true,
  );

  /// Default recovery config for unknown errors
  static const unknown = ErrorRecoveryConfig(
    strategy: RecoveryStrategy.showError,
    maxRetries: 0,
    showUserMessage: true,
  );
}

/// Error recovery service that handles automatic error recovery
class ErrorRecoveryService {
  /// Get recovery configuration for an error
  static ErrorRecoveryConfig getRecoveryConfig(AppError error) {
    return error.when(
      network: (message, code, isRetryable) => 
        isRetryable ? ErrorRecoveryConfig.network : ErrorRecoveryConfig.unknown,
      storage: (message, code) => ErrorRecoveryConfig.storage,
      validation: (message, field) => ErrorRecoveryConfig.validation,
      auth: (message, code) => ErrorRecoveryConfig.auth,
      business: (message, code) => ErrorRecoveryConfig.validation,
      unknown: (message, originalError) => ErrorRecoveryConfig.unknown,
      timeout: (message) => ErrorRecoveryConfig.network,
      permission: (message, permission) => ErrorRecoveryConfig.validation,
    );
  }

  /// Execute operation with automatic error recovery
  static Future<T> executeWithRecovery<T>(
    Future<T> Function() operation, {
    ErrorRecoveryConfig? config,
    Future<void> Function()? onAuthRefresh,
    Future<void> Function()? onCacheCleared,
  }) async {
    int retryCount = 0;
    Duration currentDelay = const Duration(seconds: 1);

    while (true) {
      try {
        return await operation();
      } catch (exception) {
        final error = ErrorHandler.fromException(exception);
        final recoveryConfig = config ?? getRecoveryConfig(error);

        // If we've exceeded max retries, throw the error
        if (retryCount >= recoveryConfig.maxRetries) {
          throw error;
        }

        // Handle different recovery strategies
        switch (recoveryConfig.strategy) {
          case RecoveryStrategy.retry:
            retryCount++;
            // No delay for immediate retry
            break;

          case RecoveryStrategy.retryWithBackoff:
            retryCount++;
            await Future.delayed(currentDelay);
            // Exponential backoff with jitter
            currentDelay = Duration(
              milliseconds: (currentDelay.inMilliseconds * 1.5).round(),
            );
            if (currentDelay > recoveryConfig.maxDelay) {
              currentDelay = recoveryConfig.maxDelay;
            }
            break;

          case RecoveryStrategy.refreshAuthAndRetry:
            if (onAuthRefresh != null) {
              await onAuthRefresh();
            }
            retryCount++;
            break;

          case RecoveryStrategy.clearCacheAndRetry:
            if (onCacheCleared != null) {
              await onCacheCleared();
            }
            retryCount++;
            break;

          case RecoveryStrategy.showError:
          case RecoveryStrategy.ignore:
            throw error;
        }
      }
    }
  }
}

/// Provider for error recovery service
final errorRecoveryServiceProvider = Provider<ErrorRecoveryService>((ref) {
  return ErrorRecoveryService();
});

/// Mixin for providers that need error recovery
mixin ErrorRecoveryMixin {
  /// Execute operation with error recovery
  Future<T> executeWithRecovery<T>(
    Future<T> Function() operation, {
    ErrorRecoveryConfig? config,
    Future<void> Function()? onAuthRefresh,
    Future<void> Function()? onCacheCleared,
  }) {
    return ErrorRecoveryService.executeWithRecovery(
      operation,
      config: config,
      onAuthRefresh: onAuthRefresh,
      onCacheCleared: onCacheCleared,
    );
  }

  /// Handle error and determine if it should be retried
  bool shouldRetryError(AppError error) {
    final config = ErrorRecoveryService.getRecoveryConfig(error);
    return config.strategy != RecoveryStrategy.showError && 
           config.strategy != RecoveryStrategy.ignore;
  }

  /// Get user-friendly error message
  String getUserErrorMessage(AppError error) {
    return error.displayMessage;
  }
}