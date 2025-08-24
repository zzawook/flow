import 'package:flow_mobile/generated/account/v1/account.pbgrpc.dart';
import 'package:flow_mobile/generated/common/v1/account.pb.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/service/api_service/grpc_interceptor.dart';
import 'package:grpc/grpc_connection_interface.dart';
import 'package:fixnum/fixnum.dart' as fx;

class AccountApiService {
  final AccountServiceClient _client;

  AccountApiService(ClientChannel channel)
    : _client = AccountServiceClient(channel, interceptors: [getIt<GrpcInterceptor>()]);

  Future<GetAccountsResponse> getBankAccounts() async {
    final request = GetAccountsRequest();

    try {
      final response = await _client.getAccounts(request);
      return response;
    } catch (e) {
      throw Exception('Failed to fetch bank accounts: $e');
    }
  }

  Future<GetAccountsWithTransactionHistoryResponse>
  getBankAccountsWithTransactionHistory() async {
    final request = GetAccountsWithTransactionHistoryRequest();

    try {
      final response = await _client.getAccountsWithTransactionHistory(request);
      return response;
    } catch (e) {
      throw Exception(
        'Failed to fetch bank accounts with transaction history: $e',
      );
    }
  }

  Future<Account> getBankAccount(int accountId) async {
    final request = GetAccountRequest(accountId: fx.Int64(accountId));

    try {
      final response = await _client.getAccount(request);
      return response;
    } catch (e) {
      throw Exception('Failed to fetch bank account: $e');
    }
  }

  Future<AccountWithTransactionHistory> getBankAccountWithTransactionHistory(
    int accountId,
  ) async {
    final request = GetAccountWithTransactionHistoryRequest(
      accountId: fx.Int64(accountId),
    );

    try {
      final response = await _client.getAccountWithTransactionHistory(request);
      return response;
    } catch (e) {
      throw Exception(
        'Failed to fetch bank account with transaction history: $e',
      );
    }
  }
}
