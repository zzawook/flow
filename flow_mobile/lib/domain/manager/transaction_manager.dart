import 'package:flow_mobile/domain/entity/transaction.dart';

abstract class TransactionManager {
  Future<List<Transaction>> getTransactions(DateTime date);
  Future<List<Transaction>> getTransactionsFromTo(
    DateTime fromDate,
    DateTime toDate,
  );
  Future<void> addTransaction(Transaction transaction);
  Future<void> clearTransactions();

  getAllTransactions() {}
}
