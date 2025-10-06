import 'package:flow_mobile/domain/entity/bank_account.dart';
import 'package:flow_mobile/domain/entity/transaction.dart';

import '../../generated/common/v1/transaction.pb.dart';

abstract class TransactionManager {
  Future<List<Transaction>> getTransactions(DateTime date);
  Future<List<Transaction>> getTransactionsFromTo(
    DateTime fromDate,
    DateTime toDate,
  );
  Future<void> addTransaction(Transaction transaction);
  Future<void> putTransaction(String id, Transaction transaction);
  Future<void> clearTransactions();

  Future<List<Transaction>> getAllTransactions();

  Future<void> fetchLastYearTransactionsFromRemote() async {}
  Future<List<Transaction>> fetchProcessedTransactionFromRemote();
  Future<List<Transaction>> fetchPastOverYearTransactionsAroundFromRemote(
    DateTime month,
  );
  Transaction fromTransactionHistoryDetail(TransactionHistoryDetail detail);
  Future<bool> setTransactionCategory(Transaction transaction, String category);

  Future<bool> toggleTransactionIncludeInSpendingOrIncome(
    Transaction transaction,
  );

  Future<List<Transaction>> getTransactionForAccount(
    BankAccount account,
    int limit, {
    String? oldestTransactionId,
  });

  Future<List<Transaction>> fetchTransactionsByIdsFromRemote(List<String> idsToFetch);
}
