import 'package:flow_mobile/domain/repositories/account_repository.dart';

/// Use case for deleting bank accounts
abstract class DeleteAccountUseCase {
  Future<void> execute(int id);
  Future<void> executeAll();
}

/// Implementation of delete account use case
class DeleteAccountUseCaseImpl implements DeleteAccountUseCase {
  final AccountRepository _accountRepository;

  DeleteAccountUseCaseImpl(this._accountRepository);

  @override
  Future<void> execute(int id) async {
    await _accountRepository.deleteBankAccount(id);
  }

  @override
  Future<void> executeAll() async {
    await _accountRepository.clearBankAccounts();
  }
}