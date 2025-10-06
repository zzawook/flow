import 'package:flow_mobile/generated/common/v1/transaction.pb.dart';
import 'package:flow_mobile/generated/transaction_history/v1/transaction_history.pbgrpc.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/service/api_service/grpc_interceptor.dart';
import 'package:grpc/grpc_connection_interface.dart';
import 'package:flow_mobile/generated/google/protobuf/timestamp.pb.dart' as gp;
import 'package:fixnum/fixnum.dart' as fx;

class TransactionHistoryApiService {

  final TransactionHistoryServiceClient _channel;

  TransactionHistoryApiService(ClientChannel channel)
      : _channel = TransactionHistoryServiceClient(channel, interceptors: [getIt<GrpcInterceptor>()]);

  gp.Timestamp ts(DateTime dt) => gp.Timestamp.fromDateTime(dt.toUtc());

  Future<TransactionHistoryList> getTransactionWithinRange(DateTime startDate, DateTime endDate) async {
    final response = await _channel.getTransactionWithinRange(GetTransactionWithinRangeRequest(
      startTimestamp: ts(startDate),
      endTimestamp: ts(endDate),
    ));
    return response;
  }

  Future<TransactionHistoryList> getMonthlyTransaction(DateTime date) async {
    final response = await _channel.getMonthlyTransaction(GetMonthlyTransactionRequest(
      month: date.month,
      year: date.year,
    ));
    return response;
  }

  Future<TransactionHistoryList> getDailyTransaction(DateTime date) async {
    final response = await _channel.getDailyTransaction(GetDailyTransactionRequest(
      month: date.month,
      year: date.year,
      day: date.day,
    ));
    return response;
  }

  Future<TransactionHistoryList> getProcessedTransactions(List<String> transactionIds) async {
    final response = await _channel.getProcessedTransaction(GetProcessedTransactionRequest(
      transactionIds: transactionIds,
    ));
    return response;
  }

  Future<SetTransactionCategoryResponse> setTransactionCategory(String transactionId, String category) async {
    final response = await _channel.setTransactionCategory(SetTransactionCategoryRequest(
      transactionId: transactionId,
      category: category,
    ));
    return response;
  }

  Future<SetTransactionInclusionResponse> setTransactionInclusion(String transactionId, bool newValue) async {
    final response = await _channel.setTransactionInclusion(SetTransactionInclusionRequest(
      transactionId: transactionId,
      includeInSpendingOrIncome: newValue,
    ));
    return response;
  }

  Future<TransactionHistoryList> getTransactionForAccount(
    String accountNumber,
    int bankId,
    int limit, {
    String? oldestTransactionId,
  }) async {
    final response = await _channel.getTransactionForAccount(
      GetTransactionForAccountRequest(
        accountNumber: accountNumber,
        bankId: bankId.toString(),
        limit: fx.Int64(limit),
        oldestTransactionId: oldestTransactionId ?? '',
      ),
    );
    return response;
  }

  Future<GetSpendingMedianResponse> getSpendingMedianForAgeGroup({
    int? year,
    int? month,
  }) async {
    final request = GetSpendingMedianRequest();
    if (year != null) {
      request.year = year;
    }
    if (month != null) {
      request.month = month;
    }

    final response = await _channel.getSpendingMedianForAgeGroup(request);
    return response;
  }

  Future<GetRecurringTransactionResponse> getRecurringTransactions() async {
    final request = GetRecurringTransactionRequest();
    final response = await _channel.getRecurringTransaction(request);
    return response;
  }

  Future<TransactionHistoryList> getTransactionsByIds(List<String> idsToFetch) async {
    final response = await _channel.getTransactionsByIds(GetTransactionsByIdRequest(
      transactionIds: idsToFetch.map((e) => fx.Int64(int.parse(e))).toList(),
    ));
    return response;
  }
}