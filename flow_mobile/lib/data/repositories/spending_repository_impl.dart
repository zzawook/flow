import 'package:flow_mobile/domain/entities/date_spending_statistics.dart';
import 'package:flow_mobile/domain/repositories/spending_repository.dart';
import 'package:flow_mobile/data/datasources/local/spending_local_datasource.dart';
import 'package:flow_mobile/data/datasources/remote/spending_remote_datasource.dart';

/// Implementation of SpendingRepository using data sources
/// Provides spending statistics operations
class SpendingRepositoryImpl implements SpendingRepository {
  final SpendingLocalDataSource _localDataSource;
  final SpendingRemoteDataSource _remoteDataSource;

  SpendingRepositoryImpl({
    required SpendingLocalDataSource localDataSource,
    required SpendingRemoteDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  @override
  Future<DateSpendingStatistics> getSpending(DateTime date) async {
    final spending = await _localDataSource.getSpending(date);
    if (spending == null) {
      throw Exception('Spending data not found for date: $date');
    }
    return spending;
  }

  @override
  Future<List<DateSpendingStatistics>> getSpendingRange(
    DateTime fromDate,
    DateTime toDate,
  ) {
    return _localDataSource.getSpendingRange(fromDate, toDate);
  }

  @override
  Future<void> createSpending(DateSpendingStatistics spending) {
    return _localDataSource.createSpending(spending);
  }

  @override
  Future<void> updateSpending(DateSpendingStatistics spending) {
    return _localDataSource.updateSpending(spending);
  }

  @override
  Future<void> deleteSpending(DateTime date) {
    return _localDataSource.deleteSpending(date);
  }

  @override
  Future<List<String>> getSpendingCategories() {
    return _localDataSource.getSpendingCategories();
  }
}