import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/core/errors/app_error.dart';
import 'package:flow_mobile/presentation/shared/flow_snackbar.dart';

/// Centralized error handling that maintains existing UI behavior
class ErrorHandler {
  /// Convert various exception types to AppError
  static AppError fromException(Object exception) {
    if (exception is AppError) {
      return exception;
    }

    // Network-related errors
    if (exception is SocketException) {
      return AppError.network(
        message: 'No internet connection. Please check your network.',
        code: 'SOCKET_EXCEPTION',
        isRetryable: true,
      );
    }

    if (exception is HttpException) {
      return AppError.network(
        message: exception.message,
        code: 'HTTP_EXCEPTION',
        isRetryable: true,
      );
    }

    // Timeout errors
    if (exception is TimeoutException) {
      return const AppError.timeout();
    }

    // Format errors (JSON parsing, etc.)
    if (exception is FormatException) {
      return AppError.validation(
        message: 'Invalid data format: ${exception.message}',
      );
    }

    // Argument errors
    if (exception is ArgumentError) {
      return AppError.validation(
        message: exception.message ?? 'Invalid argument provided',
      );
    }

    // State errors
    if (exception is StateError) {
      return AppError.business(
        message: exception.message,
        code: 'STATE_ERROR',
      );
    }

    // Unknown errors
    return AppError.unknown(
      message: exception.toString(),
      originalError: exception,
    );
  }

  /// Handle error and display to user using existing UI patterns
  static void handleError(
    AppError error,
    BuildContext context, {
    bool showSnackbar = true,
    VoidCallback? onRetry,
  }) {
    if (showSnackbar) {
      _showErrorSnackbar(context, error, onRetry);
    }

    // Log error for debugging (maintain existing logging behavior)
    _logError(error);
  }

  /// Handle error in Riverpod context
  static void handleErrorWithRef(
    AppError error,
    WidgetRef ref, {
    bool showSnackbar = true,
    VoidCallback? onRetry,
  }) {
    final context = ref.context;
    if (context.mounted) {
      handleError(error, context, showSnackbar: showSnackbar, onRetry: onRetry);
    }
  }

  /// Show error using existing FlowSnackbar pattern
  static void _showErrorSnackbar(
    BuildContext context,
    AppError error,
    VoidCallback? onRetry,
  ) {
    final messenger = ScaffoldMessenger.of(context);
    
    // Create snackbar content with retry option if applicable
    Widget content = Text(
      error.displayMessage,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
    );

    // Add retry button for retryable errors
    if (error.isRetryable && onRetry != null) {
      content = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              error.displayMessage,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              messenger.hideCurrentSnackBar();
              onRetry();
            },
            child: const Text(
              'Retry',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    }

    final snackbar = FlowSnackbar(
      content: content,
      duration: error.isRetryable ? 5 : 3, // Longer duration for retryable errors
    );

    messenger.showSnackBar(snackbar);
  }

  /// Log error for debugging (maintain existing logging behavior)
  static void _logError(AppError error) {
    // In development, print detailed error information
    debugPrint('AppError: ${error.displayMessage}');
    if (error.code != null) {
      debugPrint('Error Code: ${error.code}');
    }
    
    // Log original error if available for debugging
    error.whenOrNull(
      unknown: (message, originalError) {
        if (originalError != null) {
          debugPrint('Original Error: $originalError');
        }
      },
    );
  }

  /// Convert AppError back to String for compatibility with existing code
  static String errorToString(AppError error) {
    return error.displayMessage;
  }

  /// Create AppError from String for backward compatibility
  static AppError errorFromString(String errorMessage) {
    if (errorMessage.isEmpty) {
      return const AppError.unknown(message: 'Unknown error occurred');
    }
    
    // Try to categorize based on common error messages
    final lowerMessage = errorMessage.toLowerCase();
    
    if (lowerMessage.contains('network') || 
        lowerMessage.contains('connection') ||
        lowerMessage.contains('internet')) {
      return AppError.network(
        message: errorMessage,
        isRetryable: true,
      );
    }
    
    if (lowerMessage.contains('timeout')) {
      return AppError.timeout(message: errorMessage);
    }
    
    if (lowerMessage.contains('validation') || 
        lowerMessage.contains('invalid')) {
      return AppError.validation(message: errorMessage);
    }
    
    if (lowerMessage.contains('auth') || 
        lowerMessage.contains('unauthorized') ||
        lowerMessage.contains('forbidden')) {
      return AppError.auth(message: errorMessage);
    }
    
    return AppError.unknown(message: errorMessage);
  }
}

/// Exception class for timeout operations
class TimeoutException implements Exception {
  final String message;
  const TimeoutException([this.message = 'Operation timed out']);
  
  @override
  String toString() => 'TimeoutException: $message';
}