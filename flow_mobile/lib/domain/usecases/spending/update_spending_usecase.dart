import 'package:flow_mobile/domain/entities/date_spending_statistics.dart';
import 'package:flow_mobile/domain/repositories/spending_repository.dart';

/// Use case for updating spending records
abstract class UpdateSpendingUseCase {
  Future<void> execute(DateSpendingStatistics spending);
}

/// Implementation of update spending use case
class UpdateSpendingUseCaseImpl implements UpdateSpendingUseCase {
  final SpendingRepository _spendingRepository;

  UpdateSpendingUseCaseImpl(this._spendingRepository);

  @override
  Future<void> execute(DateSpendingStatistics spending) async {
    await _spendingRepository.updateSpending(spending);
  }
}