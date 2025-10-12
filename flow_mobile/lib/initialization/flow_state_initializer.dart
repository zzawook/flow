import 'package:flow_mobile/domain/entity/bank_account.dart';
import 'package:flow_mobile/domain/entity/notification.dart';
import 'package:flow_mobile/domain/entity/setting_v1.dart';
import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/domain/entity/transfer_receivable.dart';
import 'package:flow_mobile/domain/entity/user.dart';
import 'package:flow_mobile/domain/manager/auth_manager.dart';
import 'package:flow_mobile/domain/manager/bank_account_manager.dart';
import 'package:flow_mobile/domain/manager/card_manager.dart';
import 'package:flow_mobile/domain/manager/notification_manager.dart';
import 'package:flow_mobile/domain/manager/setting_manager.dart';
import 'package:flow_mobile/domain/manager/transaction_manager.dart';
import 'package:flow_mobile/domain/manager/transfer_receiveble_manager.dart';
import 'package:flow_mobile/domain/manager/user_manager.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/auth_state.dart';
import 'package:flow_mobile/domain/redux/states/bank_account_state.dart';
import 'package:flow_mobile/domain/redux/states/card_state.dart';
import 'package:flow_mobile/domain/redux/states/notification_state.dart';
import 'package:flow_mobile/domain/redux/states/screen_state.dart';
import 'package:flow_mobile/domain/redux/states/setting_state.dart';
import 'package:flow_mobile/domain/redux/states/transaction_state.dart';
import 'package:flow_mobile/domain/redux/states/transfer_receivable_state.dart';
import 'package:flow_mobile/domain/redux/states/transfer_state.dart';
import 'package:flow_mobile/domain/redux/states/user_state.dart';
import 'package:flow_mobile/initialization/manager_registry.dart';
import 'package:flow_mobile/service/api_service/grpc_interceptor.dart';

class FlowStateInitializer {
  static Future<FlowState> buildInitialState() async {
    final bankState = await getBankAccountState();
    return FlowState(
      transferState: TransferState.initial(),
      userState: await getUserState(),
      settingsState: await getSettingState(),
      screenState: ScreenState.initial(),
      bankAccountState: bankState,
      cardState: await getCardState(),
      transactionState: await getTransactionState(),
      transferReceivableState: await getTransferReceivableState(bankState),
      notificationState: await getNotificationState(),
      authState: await getAuthState(),
    );
  }

  static Future<CardState> getCardState() async {
    final cardManager = getIt<CardManager>();
    final cards = cardManager.getCards();
    return CardState(cards: await cards);
  }

  static Future<AuthState> getAuthState() async {
    final authManager = getIt<AuthManager>();
    final usermanager = getIt<UserManager>();

    final credentialCheck = await authManager.attemptTokenValidation();
    if (credentialCheck) {
      final accessToken = await authManager.getAccessTokenFromLocal();
      if (accessToken != null) {
        GrpcInterceptor.setAccessToken(accessToken);
      }
      final loginEmail = await usermanager.getUser().then(
        (user) => user?.email ?? '',
      );
      final isEmailVerified = await authManager.isEmailVerified(loginEmail);
      if (!isEmailVerified) {
        return AuthState(
          isAuthenticated: true,
          isEmailVerified: false,
          loginEmail: loginEmail,
        );
      }
      return AuthState(isAuthenticated: true, isEmailVerified: true);
    } else {
      return AuthState(isAuthenticated: false, isEmailVerified: false);
    }
  }

  static Future<UserState> getUserState() async {
    UserManager userManager = getIt<UserManager>();
    User? user = await userManager.getUser();
    return UserState(user: user);
  }

  static Future<SettingsState> getSettingState() async {
    SettingManager settingManager = getIt<SettingManager>();
    return SettingsState(
      settings: SettingsV1(
        fontScale: await settingManager.getFontScale(),
        language: await settingManager.getLanguage(),
        theme: await settingManager.getTheme(),
        notification: await settingManager.getNotificationSetting(),
        displayBalanceOnHome: await settingManager.getDisplayBalanceOnHome(),
      ),
    );
  }

  static Future<BankAccountState> getBankAccountState() async {
    BankAccountManager bankAccountManager = getIt<BankAccountManager>();
    List<BankAccount> bankAccounts = await bankAccountManager.getBankAccounts();
    return BankAccountState(bankAccounts: bankAccounts);
  }

  static Future<TransactionState> getTransactionState() async {
    TransactionManager transactionManager = getIt<TransactionManager>();
    List<Transaction> transactions = await transactionManager
        .getAllTransactions();
    return TransactionState(transactions: transactions);
  }

  static Future<TransferReceivableState> getTransferReceivableState(
    BankAccountState bankAccountState,
  ) async {
    TransferReceivebleManager transferReceivableManager =
        getIt<TransferReceivebleManager>();
    List<TransferReceivable> transferReceivables =
        await transferReceivableManager.getTransferReceivables();
    List<BankAccount> myBankAccounts = bankAccountState.bankAccounts;
    return TransferReceivableState(
      transferReceivables: transferReceivables,
      myBankAccounts: myBankAccounts,
    );
  }

  static Future<NotificationState> getNotificationState() async {
    NotificationManager notificationManager = getIt<NotificationManager>();

    List<Notification> notifications = await notificationManager
        .getNotifications();
    return NotificationState(notifications: notifications);
  }
}
