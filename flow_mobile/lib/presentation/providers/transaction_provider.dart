import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/presentation/providers/state_models/state_models.dart';
import 'package:flow_mobile/domain/usecases/usecases.dart';
import 'package:flow_mobile/domain/entities/entities.dart';
import 'package:flow_mobile/core/providers/providers.dart';
import 'package:flow_mobile/core/errors/errors.dart';

/// StateNotifier for Transaction state management with enhanced error handling
class TransactionNotifier extends StateNotifier<TransactionStateModel> with ErrorRecoveryMixin {
  final GetTransactionsUseCase _getTransactionsUseCase;
  final CreateTransactionUseCase _createTransactionUseCase;
  final UpdateTransactionUseCase _updateTransactionUseCase;
  final DeleteTransactionUseCase _deleteTransactionUseCase;

  TransactionNotifier(
    this._getTransactionsUseCase,
    this._createTransactionUseCase,
    this._updateTransactionUseCase,
    this._deleteTransactionUseCase,
  ) : super(TransactionStateModel.initial());

  /// Load all transactions with enhanced error handling
  Future<void> loadTransactions() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final transactions = await executeWithRecovery(
        () => _getTransactionsUseCase.executeAll(),
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

  /// Create a new transaction with enhanced error handling
  Future<void> createTransaction(Transaction transaction) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await executeWithRecovery(
        () => _createTransactionUseCase.execute(transaction),
      );
      
      // Reload transactions to get the updated list
      await loadTransactions();
    } catch (e) {
      final appError = ErrorHandler.fromException(e);
      state = state.copyWith(
        isLoading: false,
        error: appError,
      );
    }
  }

  /// Update an existing transaction with enhanced error handling
  Future<void> updateTransaction(Transaction transaction) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await executeWithRecovery(
        () => _updateTransactionUseCase.execute(transaction),
      );
      
      // Reload transactions to get the updated list
      await loadTransactions();
    } catch (e) {
      final appError = ErrorHandler.fromException(e);
      state = state.copyWith(
        isLoading: false,
        error: appError,
      );
    }
  }

  /// Delete all transactions with enhanced error handling
  Future<void> deleteAllTransactions() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await executeWithRecovery(
        () => _deleteTransactionUseCase.executeAll(),
      );
      
      state = state.copyWith(
        transactions: [],
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

  /// Clear error state
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Retry last failed operation
  Future<void> retryLastOperation() async {
    if (state.error != null && state.error!.isRetryable) {
      // For now, retry loading transactions as the most common operation
      await loadTransactions();
    }
  }
}

/// Provider for TransactionNotifier
final transactionNotifierProvider = StateNotifierProvider<TransactionNotifier, TransactionStateModel>((ref) {
  return TransactionNotifier(
    ref.read(getTransactionsUseCaseProvider).value!,
    ref.read(createTransactionUseCaseProvider).value!,
    ref.read(updateTransactionUseCaseProvider).value!,
    ref.read(deleteTransactionUseCaseProvider).value!,
  );
});

/// Convenience provider for accessing transaction state
final transactionStateProvider = Provider<TransactionStateModel>((ref) {
  return ref.watch(transactionNotifierProvider);
});

/// Convenience provider for accessing transactions list
final transactionsProvider = Provider<List<Transaction>>((ref) {
  return ref.watch(transactionNotifierProvider).transactions;
});

/// Convenience provider for accessing loading state
final transactionLoadingProvider = Provider<bool>((ref) {
  return ref.watch(transactionNotifierProvider).isLoading;
});

/// Convenience provider for accessing error state
final transactionErrorProvider = Provider<AppError?>((ref) {
  return ref.watch(transactionNotifierProvider).error;
});

/// Convenience provider for accessing error message as string (for compatibility)
final transactionErrorMessageProvider = Provider<String>((ref) {
  return ref.watch(transactionNotifierProvider).errorMessage;
});