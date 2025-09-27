
import 'package:flow_mobile/generated/common/v1/transaction.pb.dart';
import 'package:flow_mobile/generated/transaction_history/v1/transaction_history.pbgrpc.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/service/api_service/grpc_interceptor.dart';
import 'package:grpc/grpc_connection_interface.dart';
import 'package:flow_mobile/generated/google/protobuf/timestamp.pb.dart' as gp;

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
}