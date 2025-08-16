import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/core/errors/errors.dart';
import 'package:flow_mobile/presentation/providers/transaction_provider.dart';
import 'package:flow_mobile/presentation/shared/error_display_widget.dart';

/// Example widget demonstrating the new error handling patterns
/// This shows how to integrate the error handling system with existing UI
class ErrorHandlingExampleScreen extends ConsumerWidget {
  const ErrorHandlingExampleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionState = ref.watch(transactionStateProvider);
    final transactionNotifier = ref.read(transactionNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Error Handling Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => transactionNotifier.loadTransactions(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Example 1: Inline error display
          if (transactionState.hasError)
            ErrorDisplayWidget(
              error: transactionState.error,
              onRetry: () => transactionNotifier.loadTransactions(),
              showAsInline: true,
            ),

          // Example 2: Loading indicator
          if (transactionState.isLoading)
            const LoadingIndicatorWidget(
              isLoading: true,
              loadingText: 'Loading transactions...',
            ),

          // Example 3: Success state with data
          if (!transactionState.isLoading && !transactionState.hasError)
            Expanded(
              child: ListView.builder(
                itemCount: transactionState.transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactionState.transactions[index];
                  return ListTile(
                    title: Text(transaction.description),
                    subtitle: Text('\$${transaction.amount.toStringAsFixed(2)}'),
                    trailing: Text(
                      transaction.date.toString().split(' ')[0],
                    ),
                  );
                },
              ),
            ),

          // Example 4: Empty state
          if (!transactionState.isLoading && 
              !transactionState.hasError && 
              transactionState.transactions.isEmpty)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No transactions found',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Example 5: Manual error trigger for testing
          FloatingActionButton(
            heroTag: 'error',
            onPressed: () {
              // Simulate different types of errors for testing
              _showErrorExamples(context, ref);
            },
            child: const Icon(Icons.error),
          ),
          const SizedBox(height: 16),
          
          // Example 6: Snackbar error display
          FloatingActionButton(
            heroTag: 'snackbar',
            onPressed: () {
              if (transactionState.hasError) {
                ref.showErrorSnackbar(
                  transactionState.error!,
                  onRetry: () => transactionNotifier.loadTransactions(),
                );
              }
            },
            child: const Icon(Icons.message),
          ),
        ],
      ),
    );
  }

  void _showErrorExamples(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error Examples'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildErrorButton(
              'Network Error',
              () => _showError(ref, AppError.network(
                message: 'Failed to connect to server',
                isRetryable: true,
              )),
            ),
            _buildErrorButton(
              'Validation Error',
              () => _showError(ref, AppError.validation(
                message: 'Invalid input provided',
                field: 'amount',
              )),
            ),
            _buildErrorButton(
              'Auth Error',
              () => _showError(ref, AppError.auth(
                message: 'Session expired, please login again',
                code: 'TOKEN_EXPIRED',
              )),
            ),
            _buildErrorButton(
              'Timeout Error',
              () => _showError(ref, const AppError.timeout()),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorButton(String title, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          onPressed();
          Navigator.of(context).pop();
        },
        child: Text(title),
      ),
    );
  }

  void _showError(WidgetRef ref, AppError error) {
    ref.showErrorSnackbar(
      error,
      onRetry: error.isRetryable ? () {
        // Simulate retry action
        ref.read(transactionNotifierProvider.notifier).loadTransactions();
      } : null,
    );
  }
}

/// Example of using AsyncState for more complex state management
class AsyncStateExampleWidget extends ConsumerWidget {
  const AsyncStateExampleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Example of using AsyncState with StateDisplayWidget
    final asyncState = ref.watch(asyncTransactionProvider);

    return StateDisplayWidget<List<dynamic>>(
      state: asyncState,
      builder: (transactions) => ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Transaction ${index + 1}'),
            subtitle: Text('Amount: \$${(index + 1) * 10}'),
          );
        },
      ),
      onRetry: () => ref.read(asyncTransactionProvider.notifier).refresh(),
      loadingText: 'Loading async transactions...',
      emptyWidget: const Center(
        child: Text('No async transactions available'),
      ),
    );
  }
}

/// Example provider using AsyncState
final asyncTransactionProvider = StateNotifierProvider<AsyncTransactionNotifier, AsyncState<List<dynamic>>>((ref) {
  return AsyncTransactionNotifier();
});

class AsyncTransactionNotifier extends StateNotifier<AsyncState<List<dynamic>>> {
  AsyncTransactionNotifier() : super(const AsyncState.loading()) {
    _loadData();
  }

  Future<void> _loadData() async {
    state = const AsyncState.loading();
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Simulate success
      final data = List.generate(5, (index) => 'Transaction $index');
      state = AsyncState.data(data);
    } catch (e) {
      final error = ErrorHandler.fromException(e);
      state = AsyncState.error(error);
    }
  }

  Future<void> refresh() async {
    await _loadData();
  }
}