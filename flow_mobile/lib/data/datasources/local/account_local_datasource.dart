import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Local data source interface for bank account operations
/// Abstracts Hive storage operations
abstract class AccountLocalDataSource {
  /// Get all bank accounts from local storage
  Future<List<BankAccount>> getBankAccounts();
  
  /// Get a specific bank account by account number
  Future<BankAccount> getBankAccount(String accountNumber);
  
  /// Create a new bank account in local storage
  Future<BankAccount> createBankAccount(BankAccount bankAccount);
  
  /// Update an existing bank account in local storage
  Future<BankAccount> updateBankAccount(BankAccount bankAccount);
  
  /// Delete a bank account by ID from local storage
  Future<void> deleteBankAccount(int id);
  
  /// Clear all bank accounts from local storage
  Future<void> clearBankAccounts();
}

/// Implementation of AccountLocalDataSource using Hive
class AccountLocalDataSourceImpl implements AccountLocalDataSource {
  final Box<BankAccount> _bankAccountBox;

  AccountLocalDataSourceImpl({required Box<BankAccount> bankAccountBox}) 
      : _bankAccountBox = bankAccountBox;

  @override
  Future<BankAccount> createBankAccount(BankAccount bankAccount) async {
    await _bankAccountBox.put(bankAccount.accountNumber, bankAccount);
    return bankAccount;
  }

  @override
  Future<void> deleteBankAccount(int id) async {
    await _bankAccountBox.delete(id);
  }

  @override
  Future<BankAccount> getBankAccount(String accountNumber) async {
    final bankAccount = _bankAccountBox.get(accountNumber);
    if (bankAccount == null) {
      throw Exception('Bank account not found for id $accountNumber');
    }
    return bankAccount;
  }

  @override
  Future<List<BankAccount>> getBankAccounts() async {
    return _bankAccountBox.values.toList();
  }

  @override
  Future<BankAccount> updateBankAccount(BankAccount bankAccount) async {
    await _bankAccountBox.put(bankAccount.accountNumber, bankAccount);
    return bankAccount;
  }

  @override
  Future<void> clearBankAccounts() async {
    await _bankAccountBox.clear();
  }
}