import 'package:flow_mobile/domain/entity/bank_account.dart';
import 'package:flow_mobile/domain/entity/notification.dart';
import 'package:flow_mobile/domain/entity/setting_v1.dart';
import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/domain/entity/transfer_receivable.dart';
import 'package:flow_mobile/domain/entity/user.dart';
import 'package:flow_mobile/domain/manager/bank_account_manager.dart';
import 'package:flow_mobile/domain/manager/bank_account_manager_impl.dart';
import 'package:flow_mobile/domain/manager/notification_manager.dart';
import 'package:flow_mobile/domain/manager/notification_manager_impl.dart';
import 'package:flow_mobile/domain/manager/setting_manager.dart';
import 'package:flow_mobile/domain/manager/setting_manager_impl.dart';
import 'package:flow_mobile/domain/manager/transaction_manager.dart';
import 'package:flow_mobile/domain/manager/transaction_manager_impl.dart';
import 'package:flow_mobile/domain/manager/transfer_receiveble_manager.dart';
import 'package:flow_mobile/domain/manager/transfer_receiveble_manager_impl.dart';
import 'package:flow_mobile/domain/manager/user_manager.dart';
import 'package:flow_mobile/domain/manager/user_manager_impl.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/auth_state.dart';
import 'package:flow_mobile/domain/redux/states/bank_account_state.dart';
import 'package:flow_mobile/domain/redux/states/notification_state.dart';
import 'package:flow_mobile/domain/redux/states/screen_state.dart';
import 'package:flow_mobile/domain/redux/states/setting_state.dart';
import 'package:flow_mobile/domain/redux/states/transaction_state.dart';
import 'package:flow_mobile/domain/redux/states/transfer_receivable_state.dart';
import 'package:flow_mobile/domain/redux/states/transfer_state.dart';
import 'package:flow_mobile/domain/redux/states/user_state.dart';

class FlowStateInitializer {
    static Future<FlowState> buildInitialState() async {
    final bankState = await _getBankAccountState();
    return FlowState(
      transferState: TransferState.initial(),
      userState: await _getUserState(),
      settingsState: await _getSettingState(),
      screenState: ScreenState.initial(),
      bankAccountState: bankState,
      transactionState: await _getTransactionState(),
      transferReceivableState: await _getTransferReceivableState(bankState),
      notificationState: await _getNotificationState(),
      authState: AuthState.initial()
    );
  }

  static Future<UserState> _getUserState() async {
    UserManager userManager = await UserManagerImpl.getInstance();
    User user = await userManager.getUser();
    return UserState(user: user);
  }

  static Future<SettingsState> _getSettingState() async {
    SettingManager settingManager = await SettingManagerImpl.getInstance();
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

  static Future<BankAccountState> _getBankAccountState() async {
    BankAccountManager bankAccountManager =
        await BankAccountManagerImpl.getInstance();
    List<BankAccount> bankAccounts = await bankAccountManager.getBankAccounts();
    return BankAccountState(bankAccounts: bankAccounts);
  }

  static Future<TransactionState> _getTransactionState() async {
    TransactionManager transactionManager =
        await TransactionManagerImpl.getInstance();
    List<Transaction> transactions =
        await transactionManager.getAllTransactions();
    return TransactionState(transactions: transactions);
  }

  static Future<TransferReceivableState> _getTransferReceivableState(
    BankAccountState bankAccountState,
  ) async {
    TransferReceivebleManager transferReceivableManager =
        await TransferReceivebleManagerImpl.getInstance();
    List<TransferReceivable> transferReceivables =
        await transferReceivableManager.getTransferReceivables();
    List<BankAccount> myBankAccounts = bankAccountState.bankAccounts;
    return TransferReceivableState(
      transferReceivables: transferReceivables,
      myBankAccounts: myBankAccounts,
    );
  }

  static Future<NotificationState> _getNotificationState() async {
    NotificationManager notificationManager =
        await NotificationManagerImpl.getInstance();

    List<Notification> notifications =
        await notificationManager.getNotifications();
    return NotificationState(notifications: notifications);
  }
}
