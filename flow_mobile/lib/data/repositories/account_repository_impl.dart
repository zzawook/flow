import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/domain/repositories/account_repository.dart';
import 'package:flow_mobile/data/datasources/local/account_local_datasource.dart';
import 'package:flow_mobile/data/datasources/remote/account_remote_datasource.dart';

/// Implementation of AccountRepository using data sources
/// Maintains identical behavior to BankAccountManagerImpl
class AccountRepositoryImpl implements AccountRepository {
  final AccountLocalDataSource _localDataSource;
  final AccountRemoteDataSource _remoteDataSource;

  AccountRepositoryImpl({
    required AccountLocalDataSource localDataSource,
    required AccountRemoteDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  @override
  Future<List<BankAccount>> getBankAccounts() {
    return _localDataSource.getBankAccounts();
  }

  @override
  Future<BankAccount> getBankAccount(String accountNumber) {
    return _localDataSource.getBankAccount(accountNumber);
  }

  @override
  Future<BankAccount> createBankAccount(BankAccount bankAccount) {
    return _localDataSource.createBankAccount(bankAccount);
  }

  @override
  Future<BankAccount> updateBankAccount(BankAccount bankAccount) {
    return _localDataSource.updateBankAccount(bankAccount);
  }

  @override
  Future<void> deleteBankAccount(int id) {
    return _localDataSource.deleteBankAccount(id);
  }

  @override
  Future<void> clearBankAccounts() {
    return _localDataSource.clearBankAccounts();
  }
}