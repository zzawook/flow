import 'package:flow_mobile/domain/entity/bank.dart';
import 'package:flow_mobile/domain/entity/bank_account.dart';
import 'package:flow_mobile/domain/manager/bank_account_manager.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/service/api_service/api_service.dart';
import 'package:flow_mobile/service/local_source/local_secure_hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BankAccountManagerImpl implements BankAccountManager {
  final Box<BankAccount> _bankAccountBox;

  // Private static instance
  static BankAccountManagerImpl? _instance;

  // Private named constructor
  BankAccountManagerImpl._(this._bankAccountBox);

  // Public static getter method for the singleton instance
  static Future<BankAccountManagerImpl> getInstance() async {
    if (_instance == null) {
      final box = await SecureHive.getBox<BankAccount>('bankAccount');
      _instance = BankAccountManagerImpl._(box);
    }
    return _instance!;
  }

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

  @override
  Future<void> fetchBankAccountsFromRemote() {
    ApiService apiService = getIt<ApiService>();
    // Implement the API call to fetch bank accounts
    return apiService.getBankAccounts().then((bankAccounts) async {
      await _bankAccountBox.clear();
      for (var account in bankAccounts.accounts) {
        var bankAccount = BankAccount.initial();
        bankAccount = bankAccount.copyWith(
          accountNumber: account.accountNumber,
          accountHolder: account.accountName,
          accountType: account.accountType,
          accountName: account.accountName,
          balance: account.balance,
          bank: Bank(
            name: account.bank.name,
            bankId: account.bank.id,
            // logoPath: 'assets/bank_logos/DBS.png',
          ),
        );
        await _bankAccountBox.put(bankAccount.accountNumber, bankAccount);
      }
    });
  }
}
