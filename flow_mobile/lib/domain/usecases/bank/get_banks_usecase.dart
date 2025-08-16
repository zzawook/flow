import 'package:flow_mobile/domain/entities/bank.dart';
import 'package:flow_mobile/domain/repositories/bank_repository.dart';

/// Use case for getting all banks
abstract class GetBanksUseCase {
  Future<List<Bank>> execute();
}

/// Implementation of get banks use case
class GetBanksUseCaseImpl implements GetBanksUseCase {
  final BankRepository _bankRepository;

  GetBanksUseCaseImpl(this._bankRepository);

  @override
  Future<List<Bank>> execute() async {
    return await _bankRepository.getBanks();
  }
}