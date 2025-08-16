import 'package:flow_mobile/domain/entities/transaction.dart';

/// Remote data source interface for transaction operations
/// Abstracts HTTP API operations
abstract class TransactionRemoteDataSource {
  /// Sync transactions with remote server
  Future<List<Transaction>> syncTransactions();
  
  /// Upload transaction to remote server
  Future<void> uploadTransaction(Transaction transaction);
  
  /// Download transactions from remote server
  Future<List<Transaction>> downloadTransactions();
  
  /// Delete transaction from remote server
  Future<void> deleteTransaction(String transactionId);
}

/// Implementation of TransactionRemoteDataSource using HTTP API
class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  // Note: This is a placeholder implementation
  // In a real app, this would use HTTP client to communicate with backend
  
  @override
  Future<List<Transaction>> syncTransactions() async {
    // Placeholder: In real implementation, this would sync with backend
    return [];
  }
  
  @override
  Future<void> uploadTransaction(Transaction transaction) async {
    // Placeholder: In real implementation, this would upload to backend
  }
  
  @override
  Future<List<Transaction>> downloadTransactions() async {
    // Placeholder: In real implementation, this would download from backend
    return [];
  }
  
  @override
  Future<void> deleteTransaction(String transactionId) async {
    // Placeholder: In real implementation, this would delete from backend
  }
}