import 'package:flow_mobile/presentation/setting_screen/manage_account_screen/manage_account_screen.dart';
import 'package:flow_mobile/presentation/setting_screen/manage_bank_account_screen/manage_bank_account_screen.dart';
import 'package:flow_mobile/presentation/setting_screen/manage_notification_screen/manage_notification_screen.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/setting_screen/setting_screen.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/bank_account.dart';
import '../../domain/redux/actions/screen_actions.dart';
import '../account_detail_screen/account_detail_screen.dart';
import '../fixed_spending_screen/fixed_spending_screen.dart';
import '../home_screen/home_screen.dart';
import '../notification_screen/notification_screen.dart';
import '../refresh_screen/refresh_init_screen.dart';
import '../spending_calendar_screen/spending_calendar_screen.dart';
import '../spending_category_detail_screen/spending_category_detail_screen.dart';
import '../spending_category_screen/spending_category_screen.dart';
import '../spending_screen/spending_screen.dart';
import '../transfer_screen/transfer_amount_screen.dart';
import '../transfer_screen/transfer_confirm.dart';
import '../transfer_screen/transfer_result_screen.dart';
import '../transfer_screen/transfer_screen.dart';
import '../transfer_screen/transfer_to_screen/transfer_to_screen.dart';
import '../privacy_protector.dart';
import 'transition_type.dart';
import 'app_transitions.dart';

typedef ScreenTracker = void Function(String screenName);

class AppRoutes {
  static const home = '/home';
  static const spending = '/spending';
  static const spendingDetail = '/spending/detail';
  static const category = '/spending/category';
  static const categoryDetail = '/spending/category/detail';
  static const fixedSpending = '/fixed_spending/details';
  static const accountDetail = '/account_detail';
  static const transfer = '/transfer';
  static const transferAmount = '/transfer/amount';
  static const transferTo = '/transfer/to';
  static const transferConfirm = '/transfer/confirm';
  static const transferResult = '/transfer/result';
  static const notification = '/notification';
  static const refresh = '/refresh';
  static const setting = '/setting';
  static const notificationSetting = '/notification/setting';
  static const bankAccountSetting = '/bank_account/setting';
  static const accountSetting = '/account/setting';

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

      case fixedSpending:
        page = FixedSpendingDetailsScreen(month: args!.extraData as DateTime);
        break;

      case accountDetail:
        page = BankAccountDetailScreen(
          bankAccount: args!.extraData as BankAccount,
        );
        break;

      case transfer:
        page = const TransferScreen();
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

      case setting:
        page = SettingScreen();
        break;
      case notificationSetting:
        page = const ManageNotificationScreen();
        break;
      case bankAccountSetting:
        page = const ManageBankAccountScreen();
        break;
      case accountSetting:
        page = const ManageAccountScreen();
        break;

      default:
        page = const FlowHomeScreen();
    }

    // determine transition
    final transition = args?.transitionType ?? TransitionType.slideLeft;

    return PageRouteBuilder(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 150),
      pageBuilder:
          (ctx, anim, secAnim) => PrivacyProtector(
            child: DefaultTextStyle(
              style: const TextStyle(
                fontFamily: 'Inter',
                color: Color(0xFF000000),
              ),
              child: page,
            ),
          ),
      transitionsBuilder:
          (ctx, anim, sec, child) =>
              AppTransitions.build(transition, anim, child),
    );
  }
}
