import 'package:flow_mobile/domain/entity/bank.dart';
import 'package:flow_mobile/domain/entity/bank_account.dart';

/// Test data for bank accounts
/// Provides mock bank accounts for testing without backend dependency
class BankAccountTestData {
  /// Get DBS Savings Account
  static BankAccount getDBSSavingsAccount() {
    return BankAccount(
      accountNumber: '1234567890',
      accountHolder: 'Test User',
      balance: 8500.00,
      accountName: 'DBS Savings Account',
      bank: Bank(name: 'DBS', bankId: 1),
      transferCount: 0,
      isHidden: false,
      accountType: 'SAVINGS',
    );
  }

  /// Get OCBC Checking Account
  static BankAccount getOCBCCheckingAccount() {
    return BankAccount(
      accountNumber: '9876543210',
      accountHolder: 'Test User',
      balance: 3200.00,
      accountName: 'OCBC 360 Account',
      bank: Bank(name: 'OCBC', bankId: 2),
      transferCount: 0,
      isHidden: false,
      accountType: 'CURRENT',
    );
  }

  /// Get all test bank accounts
  static List<BankAccount> getAllTestAccounts() {
    return [getDBSSavingsAccount(), getOCBCCheckingAccount()];
  }
}

