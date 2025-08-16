import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/core/errors/errors.dart';

/// Widget that displays errors consistently across the app
/// Maintains existing error display behavior while using new error types
class ErrorDisplayWidget extends ConsumerWidget {
  final AppError? error;
  final VoidCallback? onRetry;
  final bool showAsSnackbar;
  final bool showAsInline;

  const ErrorDisplayWidget({
    super.key,
    required this.error,
    this.onRetry,
    this.showAsSnackbar = false,
    this.showAsInline = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (error == null) return const SizedBox.shrink();

    if (showAsSnackbar) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showErrorSnackbar(context);
      });
      return const SizedBox.shrink();
    }

    if (showAsInline) {
      return _buildInlineError(context);
    }

    return const SizedBox.shrink();
  }

  void _showErrorSnackbar(BuildContext context) {
    if (error == null) return;

    ErrorHandler.handleError(
      error!,
      context,
      showSnackbar: true,
      onRetry: onRetry,
    );
  }

  Widget _buildInlineError(BuildContext context) {
    if (error == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red.shade600,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  error!.displayMessage,
                  style: TextStyle(
                    color: Colors.red.shade800,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (error!.isRetryable && onRetry != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Loading indicator widget that maintains existing loading UI patterns
class LoadingIndicatorWidget extends StatelessWidget {
  final bool isLoading;
  final Widget? child;
  final String? loadingText;

  const LoadingIndicatorWidget({
    super.key,
    required this.isLoading,
    this.child,
    this.loadingText,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return child ?? const SizedBox.shrink();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (loadingText != null) ...[
            const SizedBox(height: 16),
            Text(
              loadingText!,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Combined widget that handles loading, error, and success states
class StateDisplayWidget<T> extends ConsumerWidget {
  final AsyncState<T> state;
  final Widget Function(T data) builder;
  final VoidCallback? onRetry;
  final String? loadingText;
  final Widget? emptyWidget;

  const StateDisplayWidget({
    super.key,
    required this.state,
    required this.builder,
    this.onRetry,
    this.loadingText,
    this.emptyWidget,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return state.when(
      loading: () => LoadingIndicatorWidget(
        isLoading: true,
        loadingText: loadingText,
      ),
      data: (data) {
        // Handle empty data case
        if (data is List && (data as List).isEmpty) {
          return emptyWidget ?? const Center(
            child: Text(
              'No data available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          );
        }
        return builder(data);
      },
      error: (error) => ErrorDisplayWidget(
        error: error,
        onRetry: onRetry,
        showAsInline: true,
      ),
    );
  }
}

/// Extension methods for easy error handling in widgets
extension ErrorHandlingExtensions on WidgetRef {
  /// Show error snackbar
  void showErrorSnackbar(AppError error, {VoidCallback? onRetry}) {
    final context = this.context;
    if (context.mounted) {
      ErrorHandler.handleError(
        error,
        context,
        showSnackbar: true,
        onRetry: onRetry,
      );
    }
  }

  /// Handle error with ref context
  void handleError(AppError error, {VoidCallback? onRetry}) {
    ErrorHandler.handleErrorWithRef(
      error,
      this,
      showSnackbar: true,
      onRetry: onRetry,
    );
  }
}