import 'package:flow_mobile/domain/entities/transaction.dart';
import 'package:flow_mobile/domain/repositories/transaction_repository.dart';
import 'package:flow_mobile/data/datasources/local/transaction_local_datasource.dart';
import 'package:flow_mobile/data/datasources/remote/transaction_remote_datasource.dart';

/// Implementation of TransactionRepository using data sources
/// Maintains identical behavior to TransactionManagerImpl
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource _localDataSource;
  final TransactionRemoteDataSource _remoteDataSource;

  TransactionRepositoryImpl({
    required TransactionLocalDataSource localDataSource,
    required TransactionRemoteDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  @override
  Future<List<Transaction>> getTransactions(DateTime date) {
    return _localDataSource.getTransactions(date);
  }

  @override
  Future<List<Transaction>> getTransactionsFromTo(
    DateTime fromDate,
    DateTime toDate,
  ) {
    return _localDataSource.getTransactionsFromTo(fromDate, toDate);
  }

  @override
  Future<void> addTransaction(Transaction transaction) {
    return _localDataSource.addTransaction(transaction);
  }

  @override
  Future<void> clearTransactions() {
    return _localDataSource.clearTransactions();
  }

  @override
  Future<List<Transaction>> getAllTransactions() {
    return _localDataSource.getAllTransactions();
  }
}