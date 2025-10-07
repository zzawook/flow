import 'package:flow_mobile/domain/entity/bank.dart';
import 'package:flow_mobile/domain/entity/card.dart' as BankCard;
import 'package:flow_mobile/domain/entity/recurring_spending.dart';
import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/presentation/add_account_screen/add_account_screen.dart';
import 'package:flow_mobile/presentation/asset_screen/asset_screen.dart';
import 'package:flow_mobile/presentation/card_detail_screen/card_detail_screen.dart';
import 'package:flow_mobile/presentation/link_bank_screen/all_link_success_screen.dart';
import 'package:flow_mobile/presentation/link_bank_screen/link_bank_screen.dart';
import 'package:flow_mobile/presentation/link_bank_screen/link_bank_screen_argument.dart';
import 'package:flow_mobile/presentation/link_bank_screen/link_failed_screen.dart';
import 'package:flow_mobile/presentation/link_bank_screen/link_success_screen.dart';
import 'package:flow_mobile/presentation/login_screen/email_validation_screen.dart';
import 'package:flow_mobile/presentation/login_screen/login_password_screen.dart';
import 'package:flow_mobile/presentation/login_screen/login_screen.dart';
import 'package:flow_mobile/presentation/login_screen/signup_date_of_birth_screen.dart';
import 'package:flow_mobile/presentation/login_screen/signup_name_screen.dart';
import 'package:flow_mobile/presentation/login_screen/signup_password_screen.dart';
import 'package:flow_mobile/presentation/manage_bank_account_screen/manage_bank_account_screen.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/recurring_spending_detail_screen/recurring_spending_detail_screen.dart';
import 'package:flow_mobile/presentation/refresh_screen/all_refresh_success_screen.dart';
import 'package:flow_mobile/presentation/refresh_screen/refresh_bank_screen.dart';
import 'package:flow_mobile/presentation/refresh_screen/refresh_bank_screen_argument.dart';
import 'package:flow_mobile/presentation/refresh_screen/refresh_failed_screen.dart';
import 'package:flow_mobile/presentation/refresh_screen/refresh_success_screen.dart';
import 'package:flow_mobile/presentation/setting_screen/manage_account_screen/manage_account_screen.dart';
import 'package:flow_mobile/presentation/setting_screen/manage_bank_accounts_screen/manage_bank_accounts_screen.dart';
import 'package:flow_mobile/presentation/setting_screen/manage_notification_screen/manage_notification_screen.dart';
import 'package:flow_mobile/presentation/setting_screen/setting_screen.dart';
import 'package:flow_mobile/presentation/transaction_detail_screen/category_selection_screen.dart';
import 'package:flow_mobile/presentation/transaction_detail_screen/transaction_detail_screen.dart';
import 'package:flow_mobile/presentation/transfer_screen/transfer_coming_soon.dart';
import 'package:flow_mobile/presentation/welcome_screen/welcome_screen.dart';
import 'package:flutter/material.dart';

import '../../domain/entity/bank_account.dart';
import '../../domain/redux/actions/screen_actions.dart';
import '../account_detail_screen/account_detail_screen.dart';
import '../home_screen/home_screen.dart';
import '../notification_screen/notification_screen.dart';
import '../privacy_protector.dart';
import '../refresh_screen/refresh_init_screen.dart';
import '../spending_calendar_screen/spending_calendar_screen.dart';
import '../spending_category_detail_screen/spending_category_detail_screen.dart';
import '../spending_category_screen/spending_category_screen.dart';
import '../spending_screen/spending_screen.dart';
import '../transfer_screen/transfer_amount_screen.dart';
import '../transfer_screen/transfer_confirm.dart';
import '../transfer_screen/transfer_result_screen.dart';
// ignore: unused_import - WILL BE IN USE WHEN TRANSFER FEATURE IS READY
import '../transfer_screen/transfer_screen.dart';
import '../transfer_screen/transfer_to_screen/transfer_to_screen.dart';
import 'app_transitions.dart';
import 'transition_type.dart';

typedef ScreenTracker = void Function(String screenName);

class AppRoutes {
  static const home = '/home';
  static const welcome = '/welcome';
  static const spending = '/spending';
  static const spendingDetail = '/spending/detail';
  static const category = '/spending/category';
  static const categoryDetail = '/spending/category/detail';
  static const transactionDetail = "transaction_detail";
  static const categorySelection = "category_selection";
  static const fixedSpending = '/fixed_spending/details';
  static const accountDetail = '/account_detail';
  static const cardDetail = '/card_detail';
  static const addAccount = '/add_account';
  static const transfer = '/transfer';
  static const transferAmount = '/transfer/amount';
  static const transferTo = '/transfer/to';
  static const transferConfirm = '/transfer/confirm';
  static const transferResult = '/transfer/result';
  static const notification = '/notification';
  static const refresh = '/refresh_init';
  static const refreshBank = '/refresh_bank';
  static const refreshSuccess = '/refresh_success';
  static const refreshFailed = '/refresh_failed';
  static const allRefreshSuccess = '/all_refresh_success';
  static const linkBank = '/link_bank';
  static const linkSuccess = '/link_success';
  static const linkFailed = '/link_failed';
  static const allLinkSuccess = '/all_link_success';
  static const login = '/login';
  static const loginPassword = '/login/password';
  static const signupPassword = '/signup/password';
  static const signupDateOfBirth = '/signup/date_of_birth';
  static const emailVerification = '/email_verification';
  static const signupName = '/signup/name';
  static const setting = '/setting';
  static const notificationSetting = '/notification/setting';
  static const bankAccountSetting = '/bank_account/setting';
  static const bankAccountsSetting = '/bank_accounts/setting';
  static const accountSetting = '/account/setting';
  static const asset = '/asset';

  static Route<dynamic> generate(
    RouteSettings settings,
    void Function(dynamic) dispatch,
  ) {
    // track screen name
    dispatch(NavigateToScreenAction(settings.name ?? home));

    late Widget page;
    final args = settings.arguments as CustomPageRouteArguments?;

    switch (settings.name) {
      case home:
        page = const FlowHomeScreen();
        break;
      case welcome:
        page = const WelcomeScreen();
        break;

      case spending:
        page = const SpendingScreen();
        break;

      case spendingDetail:
        page = SpendingCalendarScreen(
          displayedMonth: args!.extraData as DateTime,
        );
        break;

      case category:
        page = SpendingCategoryScreen(
          displayMonthYear: args!.extraData as DateTime,
        );
        break;

      case categoryDetail:
        final data = args!.extraData as SpendingCategoryDetailScreenArguments;
        page = SpendingCategoryDetailScreen(
          category: data.category,
          displayMonthYear: data.displayMonthYear,
        );
        break;

      case transactionDetail:
        final data = args!.extraData as Transaction;
        page = TransactionDetailScreen(transaction: data);
        break;
      case categorySelection:
        final data = args!.extraData as Transaction;
        page = CategorySelectionScreen(transaction: data);
        break;

      case fixedSpending:
        page = RecurringSpendingDetailScreen(
          recurringSpending: args!.extraData as RecurringSpending,
        );
        break;

      case accountDetail:
        page = BankAccountDetailScreen(
          bankAccount: args!.extraData as BankAccount,
        );
        break;
      case cardDetail:
        page = CardDetailScreen(card: args!.extraData as BankCard.Card);
        break;

      case transfer:
        // page = const TransferScreen();
        page = const TransferComingSoon();
        break;
      case transferAmount:
        page = const TransferAmountScreen();
        break;
      case transferTo:
        page = const TransferToScreen();
        break;
      case transferConfirm:
        page = const TransferConfirmationScreen();
        break;
      case transferResult:
        page = const TransferResultScreen();
        break;

      case notification:
        page = const NotificationScreen();
        break;
      case refresh:
        page = const RefreshInitScreen();
        break;
      case refreshBank:
        final arguments = args!.extraData as RefreshBankScreenArgument;
        page = RefreshBankScreen(url: arguments.url, bank: arguments.bank);
        break;
      case refreshSuccess:
        final data = args!.extraData as Bank;
        page = RefreshSuccessScreen(bank: data);
        break;
      case refreshFailed:
        page = const RefreshFailedScreen();
        break;
      case allRefreshSuccess:
        page = const AllRefreshSuccessScreen();
        break;

      case login:
        page = const LoginEmailScreen();
        break;
      case loginPassword:
        page = const LoginPasswordScreen();
        break;
      case signupPassword:
        page = const SignupPasswordScreen();
        break;
      case signupName:
        page = const SignupNameScreen();
        break;
      case signupDateOfBirth:
        page = const SignupDateOfBirthScreen();
        break;
      case emailVerification:
        page = const EmailValidationScreen();
        break;

      case setting:
        page = SettingScreen();
        break;
      case notificationSetting:
        page = const ManageNotificationScreen();
        break;
      case bankAccountsSetting:
        page = const ManageBankAccountsScreen();
        break;
      case accountSetting:
        page = const ManageAccountScreen();
        break;

      case asset:
        page = const AssetScreen();
        break;
      case addAccount:
        final data = args!.extraData as List<Bank>;
        page = AddAccountScreen(banks: data);
        break;
      case linkBank:
        final argument = args!.extraData as LinkBankScreenArgument;
        page = LinkBankScreen(url: argument.linkUrl, bank: argument.bank);
        break;
      case linkSuccess:
        final data = args!.extraData as Bank;
        page = LinkSuccessScreen(bank: data);
        break;
      case linkFailed:
        page = const LinkFailedScreen();
        break;
      case allLinkSuccess:
        page = const AllLinkSuccessScreen();
        break;
      case bankAccountSetting:
        final data = args!.extraData as BankAccount;
        page = ManageBankAccountScreen(bankAccount: data);
        break;

      default:
        page = const FlowHomeScreen();
    }

    // determine transition
    final transition = args?.transitionType ?? TransitionType.slideLeft;

    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder: (ctx, anim, secAnim) => PrivacyProtector(
        child: DefaultTextStyle(
          style: const TextStyle(fontFamily: 'Inter', color: Color(0xFF000000)),
          child: page,
        ),
      ),
      transitionsBuilder: (ctx, anim, sec, child) =>
          AppTransitions.build(transition, anim, child),
    );
  }
}
