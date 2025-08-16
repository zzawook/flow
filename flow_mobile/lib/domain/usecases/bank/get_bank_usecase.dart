import 'package:flow_mobile/domain/entities/bank.dart';
import 'package:flow_mobile/domain/repositories/bank_repository.dart';

/// Use case for getting a specific bank
abstract class GetBankUseCase {
  Future<Bank> execute(String name);
}

/// Implementation of get bank use case
class GetBankUseCaseImpl implements GetBankUseCase {
  final BankRepository _bankRepository;

  GetBankUseCaseImpl(this._bankRepository);

  @override
  Future<Bank> execute(String name) async {
    return await _bankRepository.getBank(name);
  }
}