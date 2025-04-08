import 'package:flow_mobile/data/repository/transaction_repository.dart';
import 'package:flow_mobile/data/source/local_secure_hive.dart';
import 'package:flow_mobile/domain/entities/transaction.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final Box<Transaction> _transactionBox;

  // Private static instance
  static TransactionRepositoryImpl? _instance;

  // Private named constructor
  TransactionRepositoryImpl._(this._transactionBox);

  // Public static getter method for the singleton instance
  static Future<TransactionRepositoryImpl> getInstance() async {
    if (_instance == null) {
      final box = await SecureHive.getBox<Transaction>('transaction');
      box.clear();
      _instance = TransactionRepositoryImpl._(box);
    }
    return _instance!;
  }

  @override
  Future<List<Transaction>> getTransactionsFromTo(
    DateTime fromDate,
    DateTime toDate,
  ) {
    return Future.value(
      _transactionBox.values
          .where(
            (element) =>
                element.date.isAfter(fromDate) && element.date.isBefore(toDate),
          )
          .toList(),
    );
  }

  @override
  Future<List<Transaction>> getTransactions(DateTime date) {
    return Future.value(
      _transactionBox.values.where((element) {
        if (element.date.year == date.year &&
            element.date.month == date.month &&
            element.date.day == date.day) {
          return true;
        } else {
          return false;
        }
      }).toList(),
    );
  }

  @override
  Future<void> addTransaction(Transaction transaction) {
    return _transactionBox.add(transaction);
  }

  @override
  Future<void> clearTransactions() {
    return _transactionBox.clear();
  }

  @override
  Future<List<Transaction>> getAllTransactions() {
    return Future.value(_transactionBox.values.toList());
  }
}
