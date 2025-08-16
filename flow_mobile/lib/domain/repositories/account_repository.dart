import 'package:flow_mobile/domain/entities/bank_account.dart';

/// Repository interface for bank account operations
/// Matches existing BankAccountManager method signatures for compatibility
abstract class AccountRepository {
  /// Get all bank accounts
  Future<List<BankAccount>> getBankAccounts();
  
  /// Get a specific bank account by account number
  Future<BankAccount> getBankAccount(String accountNumber);
  
  /// Create a new bank account
  Future<BankAccount> createBankAccount(BankAccount bankAccount);
  
  /// Update an existing bank account
  Future<BankAccount> updateBankAccount(BankAccount bankAccount);
  
  /// Delete a bank account by ID
  Future<void> deleteBankAccount(int id);
  
  /// Clear all bank accounts
  Future<void> clearBankAccounts();
}