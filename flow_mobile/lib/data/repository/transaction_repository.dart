import 'package:flow_mobile/domain/entities/transaction.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> getTransactions(DateTime date);
  Future<List<Transaction>> getTransactionFromTo(
    DateTime fromDate,
    DateTime toDate,
  );
  Future<void> addTransaction(Transaction transaction);
  Future<void> clearTransactions();

  getAllTransactions() {}
}
