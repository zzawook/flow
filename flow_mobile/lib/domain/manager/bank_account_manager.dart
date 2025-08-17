import 'package:flow_mobile/domain/entity/bank_account.dart';

abstract class BankAccountManager {
  Future<List<BankAccount>> getBankAccounts();
  Future<BankAccount> getBankAccount(String accountNumber);
  Future<BankAccount> createBankAccount(BankAccount bankAccount);
  Future<BankAccount> updateBankAccount(BankAccount bankAccount);
  Future<void> deleteBankAccount(int id);
  Future<void> clearBankAccounts();
  Future<void> fetchBankAccountsFromRemote();
}
