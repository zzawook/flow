import 'dart:developer';

import 'package:flow_mobile/domain/entity/bank.dart';
import 'package:flow_mobile/domain/entity/bank_account.dart';
import 'package:flow_mobile/domain/manager/transaction_manager.dart';
import 'package:flow_mobile/generated/common/v1/transaction.pb.dart';
import 'package:flow_mobile/initialization/manager_registry.dart';
import 'package:flow_mobile/service/api_service/api_service.dart';
import 'package:flow_mobile/service/local_source/local_secure_hive.dart';
import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/utils/date_time_util.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TransactionManagerImpl implements TransactionManager {
  final Box<Transaction> _transactionBox;
  final List<Transaction> _transactionList;

  final List<Transaction> _pastOverYearTransactionList = [];

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
  Future<List<Transaction>> fetchPastOverYearTransactionsAroundFromRemote(
    DateTime month,
  ) {
    ApiService apiService = getIt<ApiService>();
    DateTime startDate = DateTime(
      month.year,
      month.month - 1,
      1,
    ); // Last month's first day
    DateTime endDate = DateTime(
      month.year,
      month.month + 2,
      0,
    ); // Next month's last day
    return apiService.getTransactionWithinRange(startDate, endDate).then((
      transactions,
    ) {
      List<Transaction> fetchedTransactions = [];
      for (var transactionHistoryDetail in transactions.transactions) {
        Transaction transaction = fromTransactionHistoryDetail(
          transactionHistoryDetail,
        );
        fetchedTransactions.add(transaction);
      }
      _pastOverYearTransactionList.clear();
      _pastOverYearTransactionList.addAll(fetchedTransactions);
      return fetchedTransactions;
    });
  }

  void loadTransactionsToList() {
    _transactionList.clear();
    _transactionList.addAll(_transactionBox.values);
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

  @override
  Future<void> fetchLastYearTransactionsFromRemote() async {
    ApiService apiService = getIt<ApiService>();
    DateTime now = DateTime.now();
    DateTime startDate = DateTime(now.year - 1, now.month, now.day);
    apiService
        .getTransactionWithinRange(startDate, now)
        .then((transactions) async {
          for (var transactionHistoryDetail in transactions.transactions) {
            Transaction transaction = fromTransactionHistoryDetail(
              transactionHistoryDetail,
            );
            String id = transactionHistoryDetail.id.toString();
            await putTransaction(id, transaction);
          }
        })
        .then((_) {
          loadTransactionsToList();
        })
        .catchError((error) {
          log("Error fetching transactions: $error");
        });
  }

  @override
  Transaction fromTransactionHistoryDetail(TransactionHistoryDetail detail) {
    return Transaction(
      id: detail.id.toInt(),
      name: detail.friendlyDescription.isNotEmpty
          ? detail.friendlyDescription
          : detail.description,
      date: detail.revisedTransactionTimestamp.seconds == 0
          ? detail.transactionTimestamp.toDateTime()
          : detail.revisedTransactionTimestamp.toDateTime(),
      amount: detail.amount,
      category: detail.transactionCategory.isEmpty
          ? "Analyzing"
          : detail.transactionCategory,
      method: "",
      isIncludedInSpendingOrIncome: detail.isIncludedInSpendingOrIncome,
      brandDomain: detail.brandDomain,
      brandName: detail.brandName,
      note: "",
      bankAccount: BankAccount(
        accountNumber: detail.account.accountNumber,
        accountHolder: "",
        accountName: detail.account.accountName,
        accountType: detail.account.accountType,
        bank: Bank(
          name: detail.account.bank.name,
          bankId: detail.account.bank.id,
        ),
        transferCount: 0,
      ),
    );
  }

  @override
  Future<void> putTransaction(String id, Transaction transaction) {
    return _transactionBox.put(id, transaction);
  }

  @override
  Future<List<Transaction>> fetchProcessedTransactionFromRemote() async {
    ApiService apiService = getIt<ApiService>();
    List<String> unprocessedTransactionIds = getUnprocessedTransaction()
        .map((transaction) => transaction.id.toString())
        .toList();
    if (unprocessedTransactionIds.isEmpty) {
      return Future.value([]);
    }
    log("Fetching processed transactions for IDs: $unprocessedTransactionIds");
    List<Transaction> fetchedTransactions = [];
    final transactionList = await apiService
        .getProcessedTransactions(unprocessedTransactionIds)
        .then((transactions) async {
          for (var transactionHistoryDetail in transactions.transactions) {
            Transaction transaction = fromTransactionHistoryDetail(
              transactionHistoryDetail,
            );
            if (_transactionList.any((t) => t.id == transaction.id)) {
              await putTransaction(transaction.id.toString(), transaction);
            } else {
              _pastOverYearTransactionList.removeWhere(
                (t) => t.id == transaction.id,
              );
              _pastOverYearTransactionList.add(transaction);
            }

            fetchedTransactions.add(transaction);
          }
          loadTransactionsToList();
          return fetchedTransactions;
        })
        .catchError((error) {
          log("Error fetching processed transactions: $error");
          return List<Transaction>.empty();
        });

    return transactionList;
  }

  List<Transaction> getUnprocessedTransaction() {
    return _transactionList
        .where((transaction) => transaction.category == "Analyzing")
        .toList()
      ..addAll(
        _pastOverYearTransactionList.where(
          (transaction) => transaction.category == "Analyzing",
        ),
      );
  }

  @override
  Future<bool> setTransactionCategory(
    Transaction transaction,
    String category,
  ) async {
    ApiService apiService = getIt<ApiService>();
    final response = await apiService.setTransactionCategory(
      transaction.id.toString(),
      category,
    );
    if (!response.success) {
      log("Failed to set transaction category: ${response.message}");
      return false;
    } else {
      transaction = transaction.copyWith(category: category);
      await putTransaction(transaction.id.toString(), transaction);
      loadTransactionsToList();
      return true;
    }
  }

  @override
  Future<bool> toggleTransactionIncludeInSpendingOrIncome(
    Transaction transaction,
  ) {
    ApiService apiService = getIt<ApiService>();
    final newValue = !transaction.isIncludedInSpendingOrIncome;
    return apiService
        .setTransactionInclusion(transaction.id.toString(), newValue)
        .then((response) async {
          if (!response.success) {
            log("Failed to toggle transaction inclusion: ${response.message}");
            return false;
          } else {
            transaction = transaction.copyWith(
              isIncludedInSpendingOrIncome: newValue,
            );
            await putTransaction(transaction.id.toString(), transaction);
            loadTransactionsToList();
            return true;
          }
        })
        .catchError((error) {
          log("Error toggling transaction inclusion: $error");
          return false;
        });
  }
  
  @override
  Future<List<Transaction>> getTransactionForAccount(
    BankAccount account,
    int limit, {
    String? oldestTransactionId,
  }) {
    ApiService apiService = getIt<ApiService>();
    return apiService
        .fetchAccountTransactions(
          account,
          limit,
          oldestTransactionId: oldestTransactionId,
        )
        .then((response) {
          List<Transaction> fetchedTransactions = [];
          for (var transactionHistoryDetail in response.transactions) {
            Transaction transaction = fromTransactionHistoryDetail(
              transactionHistoryDetail,
            );
            fetchedTransactions.add(transaction);
          }
          return fetchedTransactions;
        })
        .catchError((error) {
          log("Error fetching transactions for account: $error");
          return List<Transaction>.empty();
        });
  }
}
