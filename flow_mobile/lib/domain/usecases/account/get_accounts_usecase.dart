import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/domain/repositories/account_repository.dart';

/// Use case for getting bank accounts
abstract class GetAccountsUseCase {
  Future<List<BankAccount>> execute();
  Future<BankAccount> executeById(String accountNumber);
}

/// Implementation of get accounts use case
class GetAccountsUseCaseImpl implements GetAccountsUseCase {
  final AccountRepository _accountRepository;

  GetAccountsUseCaseImpl(this._accountRepository);

  @override
  Future<List<BankAccount>> execute() async {
    return await _accountRepository.getBankAccounts();
  }

  @override
  Future<BankAccount> executeById(String accountNumber) async {
    return await _accountRepository.getBankAccount(accountNumber);
  }
}