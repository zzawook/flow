import 'package:flow_mobile/domain/entity/bank.dart';
import 'package:flow_mobile/domain/entity/bank_account.dart';
import 'package:flow_mobile/domain/entity/card.dart';
import 'package:flow_mobile/domain/entity/user.dart';
import 'package:flow_mobile/generated/account/v1/account.pb.dart';
import 'package:flow_mobile/generated/auth/v1/auth.pb.dart';
import 'package:flow_mobile/generated/card/v1/card.pb.dart';
import 'package:flow_mobile/generated/common/v1/transaction.pb.dart';
import 'package:flow_mobile/generated/refresh/v1/refresh.pb.dart';
import 'package:flow_mobile/generated/transaction_history/v1/transaction_history.pb.dart';
import 'package:flow_mobile/generated/user/v1/user.pb.dart';
import 'package:flow_mobile/service/api_service/account_api_service.dart';
import 'package:flow_mobile/service/api_service/auth_api_service.dart';
import 'package:flow_mobile/service/api_service/card_api_service.dart';
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
  late final CardApiService _cardApiService;

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
    _cardApiService = CardApiService(_channel);
  }

  Future<SetTransactionCategoryResponse> setTransactionCategory(
    String transactionId,
    String category,
  ) async {
    return await _transactionHistoryApiService.setTransactionCategory(
      transactionId,
      category,
    );
  }

  Future<SetTransactionInclusionResponse> setTransactionInclusion(
    String transactionId,
    bool newValue,
  ) async {
    return await _transactionHistoryApiService.setTransactionInclusion(
      transactionId,
      newValue,
    );
  }

  Future<TransactionHistoryList> getProcessedTransactions(
    List<String> transactionIds,
  ) async {
    return await _transactionHistoryApiService.getProcessedTransactions(
      transactionIds,
    );
  }

  Future<GetSpendingMedianResponse> getSpendingMedianForAgeGroup({
    int? year,
    int? month,
  }) async {
    return await _transactionHistoryApiService.getSpendingMedianForAgeGroup(
      year: year,
      month: month,
    );
  }

  Future<GetRecurringTransactionResponse> getRecurringTransactions() async {
    return await _transactionHistoryApiService.getRecurringTransactions();
  }

  Future<GetRelinkUrlResponse> getLinkUrl(Bank bank) async {
    return await _refreshApiService.getLinkUrl(bank);
  }

  Future<GetRefreshUrlResponse> getRefreshUrl(Bank bank) async {
    return await _refreshApiService.getRefreshUrl(bank);
  }

  Future<GetInstitutionAuthenticationResultResponse>
  getInstitutionAuthenticationResult(Bank bank) async {
    return await _refreshApiService.getInstitutionAuthenticationResult(bank);
  }

  Future<GetDataRetrievalResultResponse> getDataRetrievalResult(
    Bank bank,
  ) async {
    return await _refreshApiService.getDataRetrievalResult(bank);
  }

  Future<CanStartRefreshSessionResponse> canStartRefreshSession(
    int bankId,
  ) async {
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

  Future<TransactionHistoryList> getTransactionWithinRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final response = await _transactionHistoryApiService
        .getTransactionWithinRange(startDate, endDate);
    return response;
  }

  Future<UserProfile> getUserProfile() async {
    final response = await _userApiService.getUserProfile();
    return response;
  }

  Future<UserProfile> updateUserProfile(
    User user, {
    String? settingsJson,
  }) async {
    settingsJson ??= '';
    final response = await _userApiService.updateUserProfile(user, settingsJson: settingsJson);
    return response;
  }

  Future<GetBanksForLinkResponse> getBanksForLink() async {
    final response = await _refreshApiService.getBanksForLink();
    return response;
  }

  Future<TransactionHistoryList> fetchAccountTransactions(
    BankAccount account,
    int limit, {
    String? oldestTransactionId,
  }) async {
    return await _transactionHistoryApiService.getTransactionForAccount(
      account.accountNumber,
      account.bank.bankId,
      limit,
      oldestTransactionId: oldestTransactionId,
    );
  }

  Future<bool> sendVerificationEmail(String? loginEmail) async {
    final response = await _authApiService.sendVerificationEmail(loginEmail);
    return response.success;
  }

  Future<CheckEmailVerifiedResponse> checkEmailVerified(
    String loginEmail,
  ) async {
    final response = await _authApiService.checkEmailVerified(loginEmail);
    return response;
  }

  Future<MonitorEmailVerifiedResponse> monitorEmailVerified(
    String loginEmail,
  ) async {
    final response = await _authApiService.monitorEmailVerified(loginEmail);
    return response;
  }

  Future<GetCardsResponse> fetchCards() async {
    return await _cardApiService.fetchCards();
  }

  Future<TransactionHistoryList> fetchCardTransactions(
    Card card,
    int limit, {
    String? oldestTransactionId,
  }) async {
    return await _cardApiService.fetchCardTransaction(
      card,
      limit,
      oldestTransactionId,
    );
  }

  Future<GetLast6MonthsEndOfMonthAssetsResponse> getLast6MonthsAssets() async {
    return await _accountApiService.getLast6MonthsAssets();
  }

  Future<TransactionHistoryList> getTransactionsByIds(
    List<String> idsToFetch,
  ) async {
    return await _transactionHistoryApiService.getTransactionsByIds(idsToFetch);
  }

  Future<CanLinkBankResponse> checkUserCanLinkBank() async {
    return await _refreshApiService.checkUserCanLinkBank();
  }

  Future<SetConstantUserFieldsResponse> setConstantUserFields(
    DateTime dateOfBirth,
    bool isGenderMale,
  ) async {
    return await _userApiService.setConstantUserFields(
      dateOfBirth,
      isGenderMale,
    );
  }

  Future<GetLoginMemoForBankResponse> getLoginMemoForBank(Bank bank) async {
    return await _refreshApiService.getLoginMemoForBank(bank.bankId);
  }

  Future<UpdateLoginMemoForBankResponse> updateLoginMemoForBank(
    Bank bank,
    String newMemo,
  ) async {
    return await _refreshApiService.updateLoginMemoForBank(
      bank.bankId,
      newMemo,
    );
  }

  Future<GetUserPreferenceJsonResponse> getUserPreferenceJson() async {
    return await _userApiService.getUserPreferenceJson();
  }
}
