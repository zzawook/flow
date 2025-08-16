import 'package:flow_mobile/domain/entities/bank_account.dart';

/// Remote data source interface for bank account operations
/// Abstracts HTTP API operations
abstract class AccountRemoteDataSource {
  /// Get all bank accounts from remote server
  Future<List<BankAccount>> getBankAccounts();
  
  /// Get a specific bank account from remote server
  Future<BankAccount> getBankAccount(String accountNumber);
  
  /// Create a new bank account on remote server
  Future<BankAccount> createBankAccount(BankAccount bankAccount);
  
  /// Update an existing bank account on remote server
  Future<BankAccount> updateBankAccount(BankAccount bankAccount);
  
  /// Delete a bank account from remote server
  Future<void> deleteBankAccount(int id);
  
  /// Sync bank accounts with remote server
  Future<List<BankAccount>> syncBankAccounts();
}

/// Implementation of AccountRemoteDataSource using HTTP API
class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  // Note: This is a placeholder implementation
  // In a real app, this would use HTTP client to communicate with backend
  
  @override
  Future<List<BankAccount>> getBankAccounts() async {
    // Placeholder: In real implementation, this would fetch from backend
    return [];
  }
  
  @override
  Future<BankAccount> getBankAccount(String accountNumber) async {
    // Placeholder: In real implementation, this would fetch from backend
    throw UnimplementedError('Remote account operations not implemented');
  }
  
  @override
  Future<BankAccount> createBankAccount(BankAccount bankAccount) async {
    // Placeholder: In real implementation, this would create on backend
    return bankAccount;
  }
  
  @override
  Future<BankAccount> updateBankAccount(BankAccount bankAccount) async {
    // Placeholder: In real implementation, this would update on backend
    return bankAccount;
  }
  
  @override
  Future<void> deleteBankAccount(int id) async {
    // Placeholder: In real implementation, this would delete from backend
  }
  
  @override
  Future<List<BankAccount>> syncBankAccounts() async {
    // Placeholder: In real implementation, this would sync with backend
    return [];
  }
}