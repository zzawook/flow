import 'package:flow_mobile/bootstrap/bootstrap.dart';
import 'package:flow_mobile/data/repository/auth_repository_impl.dart';
import 'package:flow_mobile/data/repository/bank_account_repository.dart';
import 'package:flow_mobile/data/repository/bank_account_repository_impl.dart';
import 'package:flow_mobile/data/repository/bank_repository.dart';
import 'package:flow_mobile/data/repository/bank_repository_impl.dart';
import 'package:flow_mobile/data/repository/setting_repository.dart';
import 'package:flow_mobile/data/repository/setting_repository_impl.dart';
import 'package:flow_mobile/data/repository/transaction_repository.dart';
import 'package:flow_mobile/data/repository/transaction_repository_impl.dart';
import 'package:flow_mobile/data/repository/transfer_receiveble_repository.dart';
import 'package:flow_mobile/data/repository/transfer_receiveble_repository_impl.dart';
import 'package:flow_mobile/data/repository/user_repository.dart';
import 'package:flow_mobile/data/repository/user_repository_impl.dart';
import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/domain/entities/setting.dart';
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
import 'package:flow_mobile/domain/redux/store.dart';
import 'package:flow_mobile/flow_app.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'data/source/local_secure_hive.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  FlowState initialState = await initialize();

  FlutterNativeSplash.remove();

  runApp(
    StoreProvider<FlowState>(
      store: flowStateStore(initialState),
      child: const FlowApplication(),
    ),
  );
}

class FlowApplication extends StatelessWidget {
  const FlowApplication({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flow',
      builder: (context, child) => FlowApp(),
      color: const Color(0xFFFFFFFF),
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF50C878),
          secondary: const Color(0xFF50C878),
        ),
      ),
    );
  }
}

Future<FlowState> initialize() async {
  bool hiveInited = await SecureHive.initHive();
  bool reposInited = false;
  if (hiveInited) {
    reposInited = await initializeRepositories();
  }

  bool bootstrapped = false;
  if (reposInited) {
    bootstrapped = await bootstrapHiveWithTestData();
  }
  if (!bootstrapped) {
    throw Exception('Failed to bootstrap Hive with test data');
  }
  return initializeFlowState();
}

// Fetch repositories to initialize them
Future<bool> initializeRepositories() async {
  await AuthRepositoryImpl.getInstance();
  await BankAccountRepositoryImpl.getInstance();
  await SettingRepositoryImpl.getInstance();
  await UserRepositoryImpl.getInstance();
  await TransactionRepositoryImpl.getInstance();
  await TransferReceivebleRepositoryImpl.getInstance();

  return true;
}

Future<FlowState> initializeFlowState() async {
  BankAccountState bankAccountState = await getBankAccountState();
  return FlowState(
    transferState: TransferState.initial(),
    userState: await getUserState(),
    settingsState: await getSettingState(),
    screenState: ScreenState.initial(),
    bankAccountState: bankAccountState,
    transactionState: await getTransactionState(),
    transferReceivableState: await getTransferReceivableState(bankAccountState),
    notificationState: NotificationState.initial(),
  );
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
    settings: Settings(
      fontScale: await settingRepository.getFontScale(),
      language: await settingRepository.getLanguage(),
      theme: await settingRepository.getTheme(),
      notification: await settingRepository.getNotification(),
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

Future<bool> bootstrapHiveWithTestData() async {
  bootstrapUserData();
  bootstrapBankAccountData();
  bootstrapSettingData();
  bootstrapTransferReceivableData();
  bool success = await bootstrapTransactionData();

  return success;
}

void bootstrapTransferReceivableData() async {
  TransferReceivebleRepository transferReceivableRepository =
      await TransferReceivebleRepositoryImpl.getInstance();

  await transferReceivableRepository.clearTransferReceivables();

  Bootstrap.populateTransferReceiableStateWithTestData(
    transferReceivableRepository,
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

void bootstrapBankAccountData() async {
  BankAccountRepository bankAccountRepository =
      await BankAccountRepositoryImpl.getInstance();
  BankRepository bankRepository = await BankRepositoryImpl.getInstance();

  await bankAccountRepository.clearBankAccounts();

  bankAccountRepository.createBankAccount(
    BankAccount(
      accountNumber: '1234567890',
      balance: 1000,
      id: '1',
      accountHolder: 'Kim Jae Hyeok',
      accountName: 'Savings Account',
      bank: await bankRepository.getBank('DBS'),
      transferCount: 0,
    ),
  );

  bankAccountRepository.createBankAccount(
    BankAccount(
      accountNumber: '23456788901',
      balance: 505.1,
      id: '2',
      accountHolder: 'Kim Jae Hyeok',
      accountName: 'Savings Account',
      bank: await bankRepository.getBank('UOB'),
      transferCount: 0,
    ),
  );

  bankAccountRepository.createBankAccount(
    BankAccount(
      accountNumber: '3456789012',
      balance: 249.11,
      id: '3',
      accountHolder: 'Kim Jae Hyeok',
      accountName: 'Savings Account',
      bank: await bankRepository.getBank('Maybank'),
      transferCount: 0,
    ),
  );
}

void bootstrapSettingData() async {
  SettingRepository settingRepository =
      await SettingRepositoryImpl.getInstance();

  settingRepository.setFontScale(16);
  settingRepository.setLanguage('en');
  settingRepository.setTheme('light');
  settingRepository.setNotification(true);
}

Future<bool> bootstrapTransactionData() async {
  TransactionRepository transactionRepository =
      await TransactionRepositoryImpl.getInstance();

  await transactionRepository.clearTransactions();
  bool success = await Bootstrap.populateTransactionRepositoryWithTestData(
    transactionRepository,
  );
  return success;
}
