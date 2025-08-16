import 'package:flow_mobile/domain/entities/transaction.dart';
import 'package:flow_mobile/utils/date_time_util.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Local data source interface for transaction operations
/// Abstracts Hive storage operations
abstract class TransactionLocalDataSource {
  /// Get transactions for a specific date
  Future<List<Transaction>> getTransactions(DateTime date);
  
  /// Get transactions within a date range
  Future<List<Transaction>> getTransactionsFromTo(
    DateTime fromDate,
    DateTime toDate,
  );
  
  /// Add a new transaction to local storage
  Future<void> addTransaction(Transaction transaction);
  
  /// Clear all transactions from local storage
  Future<void> clearTransactions();

  /// Get all transactions from local storage
  Future<List<Transaction>> getAllTransactions();
}

/// Implementation of TransactionLocalDataSource using Hive
class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final Box<Transaction> _transactionBox;
  final List<Transaction> _transactionList;

  TransactionLocalDataSourceImpl({
    required Box<Transaction> transactionBox,
    required List<Transaction> transactionList,
  }) : _transactionBox = transactionBox,
       _transactionList = transactionList;

  @override
  Future<List<Transaction>> getTransactionsFromTo(
    DateTime fromDate,
    DateTime toDate,
  ) {
    return Future.value(
      _transactionList.isNotEmpty
          ? _transactionList.where((element) {
            return element.date.isAfter(fromDate) &&
                element.date.isBefore(toDate);
          }).toList()
          : _transactionBox.values
              .where(
                (element) =>
                    element.date.isAfter(fromDate) &&
                    element.date.isBefore(toDate),
              )
              .toList(),
    );
  }

  @override
  Future<List<Transaction>> getTransactions(DateTime date) {
    return Future.value(
      _transactionList.isNotEmpty
          ? _transactionList
          : _transactionBox.values
              .where((element) => DateTimeUtil.isSameDate(element.date, date))
              .toList(),
    );
  }

  @override
  Future<void> addTransaction(Transaction transaction) {
    _transactionList.add(transaction);
    return _transactionBox.add(transaction);
  }

  @override
  Future<void> clearTransactions() {
    _transactionList.clear();
    return _transactionBox.clear();
  }

  @override
  Future<List<Transaction>> getAllTransactions() {
    return Future.value(_transactionList);
  }


}