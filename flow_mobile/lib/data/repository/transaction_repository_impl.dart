import 'package:flow_mobile/data/repository/transaction_repository.dart';
import 'package:flow_mobile/data/source/local_secure_hive.dart';
import 'package:flow_mobile/domain/entities/transaction.dart';
import 'package:flow_mobile/shared/utils/date_time_util.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final Box<Transaction> _transactionBox;
  final List<Transaction> _transactionList;

  // Private static instance
  static TransactionRepositoryImpl? _instance;

  // Private named constructor
  TransactionRepositoryImpl._(this._transactionBox, this._transactionList);

  // Public static getter method for the singleton instance
  static Future<TransactionRepositoryImpl> getInstance() async {
    if (_instance == null) {
      final box = await SecureHive.getBox<Transaction>('transaction');
      await box.clear();
      List<Transaction> transactionList = box.values.toList();
      _instance = TransactionRepositoryImpl._(box, transactionList);
    }
    return _instance!;
  }

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
