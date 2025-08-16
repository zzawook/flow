import 'package:flow_mobile/domain/entities/transaction.dart';

/// Repository interface for transaction operations
/// Matches existing TransactionManager method signatures for compatibility
abstract class TransactionRepository {
  /// Get transactions for a specific date
  Future<List<Transaction>> getTransactions(DateTime date);
  
  /// Get transactions within a date range
  Future<List<Transaction>> getTransactionsFromTo(
    DateTime fromDate,
    DateTime toDate,
  );
  
  /// Add a new transaction
  Future<void> addTransaction(Transaction transaction);
  
  /// Clear all transactions
  Future<void> clearTransactions();

  /// Get all transactions
  Future<List<Transaction>> getAllTransactions();
}