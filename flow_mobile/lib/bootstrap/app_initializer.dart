import 'package:flow_mobile/bootstrap/bootstrap.dart';
import 'package:flow_mobile/data/repository/auth_repository_impl.dart';
import 'package:flow_mobile/data/repository/bank_account_repository.dart';
import 'package:flow_mobile/data/repository/bank_account_repository_impl.dart';
import 'package:flow_mobile/data/repository/notification_repository.dart';
import 'package:flow_mobile/data/repository/notification_repository_impl.dart';
import 'package:flow_mobile/data/repository/setting_repository.dart';
import 'package:flow_mobile/data/repository/setting_repository_impl.dart';
import 'package:flow_mobile/data/repository/transaction_repository.dart';
import 'package:flow_mobile/data/repository/transaction_repository_impl.dart';
import 'package:flow_mobile/data/repository/transfer_receiveble_repository.dart';
import 'package:flow_mobile/data/repository/transfer_receiveble_repository_impl.dart';
import 'package:flow_mobile/data/repository/user_repository.dart';
import 'package:flow_mobile/data/repository/user_repository_impl.dart';
import 'package:flow_mobile/data/source/local_secure_hive.dart';
import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/domain/entities/notification.dart';
import 'package:flow_mobile/domain/entities/notification_setting.dart';
import 'package:flow_mobile/domain/entities/setting_v1.dart';
import 'package:flow_mobile/domain/entities/transaction.dart';
import 'package:flow_mobile/domain/entities/transfer_receivable.dart';
import 'package:flow_mobile/domain/entities/user.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/bank_account_state.dart';
import 'package:flow_mobile/domain/redux/states/notification_state.dart';
import 'package:flow_mobile/domain/redux/states/screen_state.dart';
import 'package:flow_mobile/domain/redux/states/setting_state.dart';
import 'package:flow_mobile/domain/redux/states/transaction_state.dart';
import 'package:flow_mobile/domain/redux/states/transfer_receivable_state.dart';
import 'package:flow_mobile/domain/redux/states/transfer_state.dart';
import 'package:flow_mobile/domain/redux/states/user_state.dart';

class AppInitializer {
  static Future<FlowState> initializeServices() async {
    final hiveOk = await SecureHive.initHive();
    if (!hiveOk) throw Exception('Hive initialization failed');

    await _initRepositories();
    final bootstrapped = await _bootstrapTestData();
    if (!bootstrapped) {
      throw Exception('Failed to bootstrap Hive with test data');
    }

    return _buildInitialState();
  }

  static Future<void> _initRepositories() async {
    await AuthRepositoryImpl.getInstance();
    await BankAccountRepositoryImpl.getInstance();
    await SettingRepositoryImpl.getInstance();
    await UserRepositoryImpl.getInstance();
    await TransactionRepositoryImpl.getInstance();
    await TransferReceivebleRepositoryImpl.getInstance();
    await NotificationRepositoryImpl.getInstance();
  }

  static Future<bool> _bootstrapTestData() async {
    // Note: these bootstrap methods all return Future<bool> or void
    bootstrapUserData();
    final bankOk = await bootstrapBankAccountData();
    bootstrapSettingData();
    bootstrapTransferReceivableData();
    final txOk = await bootstrapTransactionData();
    final notifOk = await bootstrapNotificationData();
    return bankOk && txOk && notifOk;
  }

  static Future<FlowState> _buildInitialState() async {
    final bankState = await getBankAccountState();
    return FlowState(
      transferState: TransferState.initial(),
      userState: await getUserState(),
      settingsState: await getSettingState(),
      screenState: ScreenState.initial(),
      bankAccountState: bankState,
      transactionState: await getTransactionState(),
      transferReceivableState: await getTransferReceivableState(bankState),
      notificationState: await getNotificationState(),
    );
  }
}

Future<UserState> getUserState() async {
  UserRepository userRepository = await UserRepositoryImpl.getInstance();
  User user = await userRepository.getUser();
  return UserState(user: user);
}

Future<SettingsState> getSettingState() async {
  SettingRepository settingRepository =
      await SettingRepositoryImpl.getInstance();
  return SettingsState(
    settings: SettingsV1(
      fontScale: await settingRepository.getFontScale(),
      language: await settingRepository.getLanguage(),
      theme: await settingRepository.getTheme(),
      notification: await settingRepository.getNotificationSetting(),
    ),
  );
}

Future<BankAccountState> getBankAccountState() async {
  BankAccountRepository bankAccountRepository =
      await BankAccountRepositoryImpl.getInstance();
  List<BankAccount> bankAccounts =
      await bankAccountRepository.getBankAccounts();
  return BankAccountState(bankAccounts: bankAccounts);
}

Future<TransactionState> getTransactionState() async {
  TransactionRepository transactionRepository =
      await TransactionRepositoryImpl.getInstance();
  List<Transaction> transactions =
      await transactionRepository.getAllTransactions();
  return TransactionState(transactions: transactions);
}

Future<TransferReceivableState> getTransferReceivableState(
  BankAccountState bankAccountState,
) async {
  TransferReceivebleRepository transferReceivableRepository =
      await TransferReceivebleRepositoryImpl.getInstance();
  List<TransferReceivable> transferReceivables =
      await transferReceivableRepository.getTransferReceivables();
  List<BankAccount> myBankAccounts = bankAccountState.bankAccounts;
  return TransferReceivableState(
    transferReceivables: transferReceivables,
    myBankAccounts: myBankAccounts,
  );
}

Future<NotificationState> getNotificationState() async {
  NotificationRepository notificationRepository =
      await NotificationRepositoryImpl.getInstance();

  List<Notification> notifications =
      await notificationRepository.getNotifications();
  return NotificationState(notifications: notifications);
}

Future<bool> bootstrapHiveWithTestData() async {
  bootstrapUserData();
  bool bankAccountDataSuccess = await bootstrapBankAccountData();
  bootstrapSettingData();
  bootstrapTransferReceivableData();
  bool transactionBootstrapSuccess = await bootstrapTransactionData();
  bool notificationBootstrapSuccess = await bootstrapNotificationData();

  return bankAccountDataSuccess &&
      transactionBootstrapSuccess &&
      notificationBootstrapSuccess;
}

void bootstrapTransferReceivableData() async {
  TransferReceivebleRepository transferReceivableRepository =
      await TransferReceivebleRepositoryImpl.getInstance();

  await transferReceivableRepository.clearTransferReceivables();

  Bootstrap.populateTransferReceiableRepositoryWithTestData(
    transferReceivableRepository,
  );
}

Future<bool> bootstrapNotificationData() async {
  NotificationRepository notificationRepository =
      await NotificationRepositoryImpl.getInstance();

  await notificationRepository.clearNotifications();

  return Bootstrap.populateNotificationRepositoryWithTestData(
    notificationRepository,
  );
}

void bootstrapUserData() async {
  UserRepository userRepository = await UserRepositoryImpl.getInstance();

  userRepository.updateUser(
    User(
      name: "Kim Jae Hyeok",
      email: 'kjaehyeok21@gmail.com',
      dateOfBirth: DateTime(2002, 1, 25),
      phoneNumber: '88197184',
    ),
  );
}

Future<bool> bootstrapBankAccountData() async {
  bool success = await Bootstrap.populateBankAccountRepositoryWithTestData();
  return success;
}

void bootstrapSettingData() async {
  SettingRepository settingRepository =
      await SettingRepositoryImpl.getInstance();

  settingRepository.setFontScale(16);
  settingRepository.setLanguage('en');
  settingRepository.setTheme('dark');
  settingRepository.setNotificationSetting(NotificationSetting.initial());
}

Future<bool> bootstrapTransactionData() async {
  bool success = await Bootstrap.populateTransactionRepositoryWithTestData();
  return success;
}
