import 'package:flow_mobile/domain/entities/date_spending_statistics.dart';
import 'package:flow_mobile/domain/repositories/spending_repository.dart';

/// Use case for getting spending statistics
abstract class GetSpendingUseCase {
  Future<DateSpendingStatistics> execute(DateTime date);
  Future<List<DateSpendingStatistics>> executeRange(DateTime fromDate, DateTime toDate);
}

/// Implementation of get spending use case
class GetSpendingUseCaseImpl implements GetSpendingUseCase {
  final SpendingRepository _spendingRepository;

  GetSpendingUseCaseImpl(this._spendingRepository);

  @override
  Future<DateSpendingStatistics> execute(DateTime date) async {
    return await _spendingRepository.getSpending(date);
  }

  @override
  Future<List<DateSpendingStatistics>> executeRange(DateTime fromDate, DateTime toDate) async {
    return await _spendingRepository.getSpendingRange(fromDate, toDate);
  }
}