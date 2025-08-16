import 'package:flow_mobile/domain/entities/date_spending_statistics.dart';
import 'package:flow_mobile/domain/repositories/spending_repository.dart';

/// Use case for creating spending records
abstract class CreateSpendingUseCase {
  Future<void> execute(DateSpendingStatistics spending);
}

/// Implementation of create spending use case
class CreateSpendingUseCaseImpl implements CreateSpendingUseCase {
  final SpendingRepository _spendingRepository;

  CreateSpendingUseCaseImpl(this._spendingRepository);

  @override
  Future<void> execute(DateSpendingStatistics spending) async {
    await _spendingRepository.createSpending(spending);
  }
}