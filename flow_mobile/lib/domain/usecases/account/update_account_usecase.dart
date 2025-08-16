import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/domain/repositories/account_repository.dart';

/// Use case for updating bank accounts
abstract class UpdateAccountUseCase {
  Future<BankAccount> execute(BankAccount bankAccount);
}

/// Implementation of update account use case
class UpdateAccountUseCaseImpl implements UpdateAccountUseCase {
  final AccountRepository _accountRepository;

  UpdateAccountUseCaseImpl(this._accountRepository);

  @override
  Future<BankAccount> execute(BankAccount bankAccount) async {
    return await _accountRepository.updateBankAccount(bankAccount);
  }
}