import 'package:flow_mobile/domain/entities/transaction.dart';
import 'package:flow_mobile/domain/repositories/transaction_repository.dart';

/// Use case for getting transactions
abstract class GetTransactionsUseCase {
  Future<List<Transaction>> execute(DateTime date);
  Future<List<Transaction>> executeRange(DateTime fromDate, DateTime toDate);
  Future<List<Transaction>> executeAll();
}

/// Implementation of get transactions use case
class GetTransactionsUseCaseImpl implements GetTransactionsUseCase {
  final TransactionRepository _transactionRepository;

  GetTransactionsUseCaseImpl(this._transactionRepository);

  @override
  Future<List<Transaction>> execute(DateTime date) async {
    return await _transactionRepository.getTransactions(date);
  }

  @override
  Future<List<Transaction>> executeRange(DateTime fromDate, DateTime toDate) async {
    return await _transactionRepository.getTransactionsFromTo(fromDate, toDate);
  }

  @override
  Future<List<Transaction>> executeAll() async {
    return await _transactionRepository.getAllTransactions();
  }
}