import 'package:flow_mobile/domain/entity/bank.dart';
import 'package:flow_mobile/domain/entity/user.dart';
import 'package:flow_mobile/generated/account/v1/account.pb.dart';
import 'package:flow_mobile/generated/auth/v1/auth.pb.dart';
import 'package:flow_mobile/generated/common/v1/transaction.pb.dart';
import 'package:flow_mobile/generated/refresh/v1/refresh.pb.dart';
import 'package:flow_mobile/generated/user/user.pb.dart';
import 'package:flow_mobile/service/api_service/account_api_service.dart';
import 'package:flow_mobile/service/api_service/auth_api_service.dart';
import 'package:flow_mobile/service/api_service/refresh_api_service.dart';
import 'package:flow_mobile/service/api_service/transaction_history_api_service.dart';
import 'package:flow_mobile/service/api_service/user_api_service.dart';
import 'package:flow_mobile/service/connection_service.dart';
import 'package:flow_mobile/utils/env.dart';
import 'package:grpc/grpc.dart';

class ApiService {
  final ConnectionService connectionService;

  ApiService({required this.connectionService}) {
    _initialize();
  }

  final int _portNumber = Env.apiPort;
  final bool _useSecureConnection = Env.useSecureConnection;
  final String _host = Env.apiHost;

  late final ClientChannel _channel;
  late final AuthApiService _authApiService;
  late final RefreshApiService _refreshApiService;
  late final UserApiService _userApiService;
  late final AccountApiService _accountApiService;
  late final TransactionHistoryApiService _transactionHistoryApiService;

  Future<void> _initialize() async {
    await connectionService.initialize();
    

    _channel = ClientChannel(
      _host,
      port: _portNumber,
      options: ChannelOptions(
        credentials: _useSecureConnection
            ? ChannelCredentials.secure()
            : ChannelCredentials.insecure(),
      ),
    );

    _authApiService = AuthApiService(_channel);
    _refreshApiService = RefreshApiService(_channel);
    _userApiService = UserApiService(_channel);
    _accountApiService = AccountApiService(_channel);
    _transactionHistoryApiService = TransactionHistoryApiService(_channel);
  }
  Future<GetRelinkUrlResponse> getLinkUrl(Bank bank) async {
    return await _refreshApiService.getLinkUrl(bank);
  }

  Future<GetRefreshUrlResponse> getRefreshUrl(Bank bank) async {
    return await _refreshApiService.getRefreshUrl(bank);
  }

  Future<GetInstitutionAuthenticationResultResponse> getInstitutionAuthenticationResult(Bank bank) async {
    return await _refreshApiService.getInstitutionAuthenticationResult(bank);
  }

  Future<GetDataRetrievalResultResponse> getDataRetrievalResult(Bank bank) async {
    return await _refreshApiService.getDataRetrievalResult(bank);
  }

  Future<CanStartRefreshSessionResponse> canStartRefreshSession(int bankId) async {
    return await _refreshApiService.canStartRefreshSession(bankId);
  }

  Future<GetAccountsResponse> getBankAccounts() async {
    return await _accountApiService.getBankAccounts();
  }

  Future<CheckUserExistsResponse> checkUserExists(String email) async {
    return await _authApiService.checkUserExists(email);
  }

  Future<TokenSet> signin(String email, String password) async {
    return await _authApiService.login(email, password);
  }

  Future<TokenSet> signup(String email, String password, String name) async {
    return await _authApiService.signup(email, password, name);
  }

  Future<SignOutResponse> signout() async {
    return await _authApiService.signout();
  }

  Future<TokenSet> refreshAccessToken(String refreshToken) async {
    return await _authApiService.refreshAccessToken(refreshToken);
  }

  Future<void> close() async {
    await _channel.shutdown();
  }

  Future<TransactionHistoryList> getTransactionWithinRange(DateTime startDate, DateTime endDate) async {
    final response = await _transactionHistoryApiService.getTransactionWithinRange(startDate, endDate);
    return response;
  }

  Future<UserProfile> getUserProfile() async {
    final response = await _userApiService.getUserProfile();
    return response;
  }

  Future<UserProfile> updateUserProfile(User user) async {
    final response = await _userApiService.updateUserProfile(user);
    return response;
  }

  Future<GetBanksForLinkResponse> getBanksForLink() async {
    final response = await _refreshApiService.getBanksForLink();
    return response;
  }
}