import 'package:flow_mobile/domain/repositories/spending_repository.dart';

/// Use case for deleting spending records
abstract class DeleteSpendingUseCase {
  Future<void> execute(DateTime date);
}

/// Implementation of delete spending use case
class DeleteSpendingUseCaseImpl implements DeleteSpendingUseCase {
  final SpendingRepository _spendingRepository;

  DeleteSpendingUseCaseImpl(this._spendingRepository);

  @override
  Future<void> execute(DateTime date) async {
    await _spendingRepository.deleteSpending(date);
  }
}