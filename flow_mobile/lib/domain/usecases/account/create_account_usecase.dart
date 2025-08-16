import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/domain/repositories/account_repository.dart';

/// Use case for creating bank accounts
abstract class CreateAccountUseCase {
  Future<BankAccount> execute(BankAccount bankAccount);
}

/// Implementation of create account use case
class CreateAccountUseCaseImpl implements CreateAccountUseCase {
  final AccountRepository _accountRepository;

  CreateAccountUseCaseImpl(this._accountRepository);

  @override
  Future<BankAccount> execute(BankAccount bankAccount) async {
    return await _accountRepository.createBankAccount(bankAccount);
  }
}