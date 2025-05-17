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
import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/domain/entities/notification.dart';
import 'package:flow_mobile/domain/entities/setting.dart';
import 'package:flow_mobile/domain/entities/transaction.dart';
import 'package:flow_mobile/domain/entities/transfer_receivable.dart';
import 'package:flow_mobile/domain/entities/user.dart';
import 'package:flow_mobile/domain/redux/actions/screen_actions.dart';
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
import 'package:flow_mobile/presentation/account_detail_screen/account_detail_screen.dart';
import 'package:flow_mobile/presentation/fixed_spending_screen/fixed_spending_screen.dart';
import 'package:flow_mobile/presentation/home_screen/flow_home_screen.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/notification_screen/notification_screen.dart';
import 'package:flow_mobile/presentation/refresh_screen/refresh_init_screen.dart';
import 'package:flow_mobile/presentation/spending_calendar_screen/spending_calendar_screen.dart';
import 'package:flow_mobile/presentation/spending_category_detail_screen/spending_category_detail_screen.dart';
import 'package:flow_mobile/presentation/spending_category_screen/spending_category_screen.dart';
import 'package:flow_mobile/presentation/spending_screen/spending_screen.dart';
import 'package:flow_mobile/presentation/transfer_screen/transfer_amount_screen.dart';
import 'package:flow_mobile/presentation/transfer_screen/transfer_confirm.dart';
import 'package:flow_mobile/presentation/transfer_screen/transfer_result_screen.dart';
import 'package:flow_mobile/presentation/transfer_screen/transfer_screen.dart';
import 'package:flow_mobile/presentation/transfer_screen/transfer_to_screen/transfer_to_screen.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'data/source/local_secure_hive.dart';

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
    void updateScreenState(String screenName) {
      StoreProvider.of<FlowState>(
        context,
      ).dispatch(NavigateToScreenAction(screenName));
    }

    return MaterialApp(
      title: 'Flow',
      color: const Color(0xFFFFFFFF),
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF50C878),
          secondary: const Color(0xFF50C878),
        ),
      ),
      initialRoute: '/home',
      onGenerateRoute: (RouteSettings settings) {
        Widget page;
        updateScreenState(settings.name?.toString() ?? "/home");
        switch (settings.name) {
          case '/home':
            page = FlowHomeScreen();
            break;
          case '/spending':
            page = SpendingScreen();
            break;
          case '/spending/detail':
            CustomPageRouteArguments args =
                settings.arguments as CustomPageRouteArguments;
            DateTime month = args.extraData as DateTime;
            page = SpendingCalendarScreen(displayedMonth: month);
            break;
          case '/spending/category':
            CustomPageRouteArguments args =
                settings.arguments as CustomPageRouteArguments;
            DateTime month = args.extraData as DateTime;
            page = SpendingCategoryScreen(displayMonthYear: month);
            break;
          case '/spending/category/detail':
            CustomPageRouteArguments args =
                settings.arguments as CustomPageRouteArguments;
            SpendingCategoryDetailScreenArguments data =
                args.extraData as SpendingCategoryDetailScreenArguments;
            page = SpendingCategoryDetailScreen(
              category: data.category,
              displayMonthYear: data.displayMonthYear,
            );
            break;
          case '/fixed_spending/details':
            CustomPageRouteArguments args =
                settings.arguments as CustomPageRouteArguments;
            DateTime month = args.extraData as DateTime;
            page = FixedSpendingDetailsScreen(month: month);
            break;
          case '/account_detail':
            CustomPageRouteArguments args =
                settings.arguments as CustomPageRouteArguments;
            BankAccount bankAccount = args.extraData as BankAccount;
            page = BankAccountDetailScreen(bankAccount: bankAccount);
            break;
          case '/transfer':
            page = TransferScreen();
            break;
          case '/transfer/amount':
            page = TransferAmountScreen();
            break;
          case '/transfer/to':
            page = TransferToScreen();
            break;
          case '/transfer/confirm':
            page = TransferConfirmationScreen();
            break;
          case '/transfer/result':
            page = TransferResultScreen();
            break;
          case '/notification':
            page = NotificationScreen();
            break;
          case '/refresh':
            page = RefreshInitScreen();
            break;
          default:
            page = FlowHomeScreen();
        }

        // Read the custom arguments if any.
        final args = settings.arguments as CustomPageRouteArguments?;
        // Use a default transition if none is passed.
        final transition = args?.transitionType ?? TransitionType.slideLeft;

        return PageRouteBuilder(
          settings: settings,
          transitionDuration: Duration(milliseconds: 150),
          pageBuilder:
              (context, animation, secondaryAnimation) => DefaultTextStyle(
                style: const TextStyle(
                  fontFamily: 'Inter',
                  color: Color(0xFF000000),
                ),
                child: page,
              ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Choose the transition effect based on the argument.
            switch (transition) {
              case TransitionType.slideLeft:
                // Slide in from the right side (moves leftward to center)
                final tween = Tween(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeInOut));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              case TransitionType.slideRight:
                // Slide in from the left side (moves rightward to center)
                final tween = Tween(
                  begin: const Offset(-1.0, 0.0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeInOut));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              case TransitionType.slideTop:
                // Slide in from the top (moves downward to center)
                final tween = Tween(
                  begin: const Offset(0.0, -1.0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeInOut));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              case TransitionType.slideBottom:
                // Slide in from the bottom (moves upward to center)
                final tween = Tween(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeInOut));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
            }
          },
        );
      },
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
  await NotificationRepositoryImpl.getInstance();

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
    notificationState: await getNotificationState(),
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
  settingRepository.setTheme('light');
  settingRepository.setNotification(true);
}

Future<bool> bootstrapTransactionData() async {
  bool success = await Bootstrap.populateTransactionRepositoryWithTestData();
  return success;
}
