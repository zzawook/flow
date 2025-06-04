import 'package:flow_mobile/domain/manager/transaction_manager.dart';
import 'package:flow_mobile/service/local_source/local_secure_hive.dart';
import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/utils/date_time_util.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TransactionManagerImpl implements TransactionManager {
  final Box<Transaction> _transactionBox;
  final List<Transaction> _transactionList;

  // Private static instance
  static TransactionManagerImpl? _instance;

  // Private named constructor
  TransactionManagerImpl._(this._transactionBox, this._transactionList);

  // Public static getter method for the singleton instance
  static Future<TransactionManagerImpl> getInstance() async {
    if (_instance == null) {
      final box = await SecureHive.getBox<Transaction>('transaction');
      await box.clear();
      List<Transaction> transactionList = box.values.toList();
      _instance = TransactionManagerImpl._(box, transactionList);
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
