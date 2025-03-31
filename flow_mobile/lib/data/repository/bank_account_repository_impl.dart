import 'package:flow_mobile/data/repository/bank_account_repository.dart';
import 'package:flow_mobile/data/source/local_secure_hive.dart';
import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BankAccountRepositoryImpl implements BankAccountRepository {
  final Box<BankAccount> _bankAccountBox;

  // Private static instance
  static BankAccountRepositoryImpl? _instance;

  // Private named constructor
  BankAccountRepositoryImpl._(this._bankAccountBox);

  // Public static getter method for the singleton instance
  static Future<BankAccountRepositoryImpl> getInstance() async {
    if (_instance == null) {
      final box = await SecureHive.getBox<BankAccount>('bankAccount');
      _instance = BankAccountRepositoryImpl._(box);
    }
    return _instance!;
  }

  @override
  Future<BankAccount> createBankAccount(BankAccount bankAccount) async {
    await _bankAccountBox.add(bankAccount);
    // Optionally update bankAccount with key if needed
    return bankAccount;
  }

  @override
  Future<void> deleteBankAccount(int id) async {
    await _bankAccountBox.delete(id);
  }

  @override
  Future<BankAccount> getBankAccount(int id) async {
    final bankAccount = _bankAccountBox.get(id);
    if (bankAccount == null) {
      throw Exception('Bank account not found for id $id');
    }
    return bankAccount;
  }

  @override
  Future<List<BankAccount>> getBankAccounts() async {
    return _bankAccountBox.values.toList();
  }

  @override
  Future<BankAccount> updateBankAccount(BankAccount bankAccount) async {
    await _bankAccountBox.put(bankAccount.id, bankAccount);
    return bankAccount;
  }

  @override
  Future<void> clearBankAccounts() async {
    await _bankAccountBox.clear();
  }
}
