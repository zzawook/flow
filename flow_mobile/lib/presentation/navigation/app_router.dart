import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/bank_account.dart';
import '../account_detail_screen/account_detail_screen.dart';
import '../asset_screen/asset_screen.dart';
import '../fixed_spending_screen/fixed_spending_screen.dart';
import '../home_screen/home_screen.dart';
import '../manage_bank_account_screen/manage_bank_account_screen.dart';
import '../notification_screen/notification_screen.dart';
import '../privacy_protector.dart';
import '../refresh_screen/refresh_init_screen.dart';
import '../setting_screen/manage_account_screen/manage_account_screen.dart';
import '../setting_screen/manage_bank_accounts_screen/manage_bank_accounts_screen.dart';
import '../setting_screen/manage_notification_screen/manage_notification_screen.dart';
import '../setting_screen/setting_screen.dart';
import '../spending_calendar_screen/spending_calendar_screen.dart';
import '../spending_category_detail_screen/spending_category_detail_screen.dart';
import '../spending_category_screen/spending_category_screen.dart';
import '../spending_screen/spending_screen.dart';
import '../transfer_screen/transfer_amount_screen.dart';
import '../transfer_screen/transfer_confirm.dart';
import '../transfer_screen/transfer_result_screen.dart';
import '../transfer_screen/transfer_screen.dart';
import '../transfer_screen/transfer_to_screen/transfer_to_screen.dart';
import 'app_transitions.dart';
import 'transition_type.dart';

/// Route paths - maintaining exact same paths as original
class AppRoutePaths {
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
  static const bankAccountsSetting = '/bank_accounts/setting';
  static const accountSetting = '/account/setting';
  static const asset = '/asset';
}

/// Route parameters for type-safe navigation
class RouteParams {
  final TransitionType? transitionType;
  final Object? extraData;

  const RouteParams({
    this.transitionType,
    this.extraData,
  });
}

/// Provider for GoRouter instance
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutePaths.home,
    routes: [
      GoRoute(
        path: AppRoutePaths.home,
        name: 'home',
        pageBuilder: (context, state) => _buildPage(
          context,
          state,
          const FlowHomeScreen(),
          TransitionType.slideLeft,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.spending,
        name: 'spending',
        pageBuilder: (context, state) => _buildPage(
          context,
          state,
          const SpendingScreen(),
          TransitionType.slideLeft,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.spendingDetail,
        name: 'spendingDetail',
        pageBuilder: (context, state) {
          final displayedMonth = state.extra as DateTime;
          return _buildPage(
            context,
            state,
            SpendingCalendarScreen(displayedMonth: displayedMonth),
            TransitionType.slideLeft,
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.category,
        name: 'category',
        pageBuilder: (context, state) {
          final displayMonthYear = state.extra as DateTime;
          return _buildPage(
            context,
            state,
            SpendingCategoryScreen(displayMonthYear: displayMonthYear),
            TransitionType.slideLeft,
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.categoryDetail,
        name: 'categoryDetail',
        pageBuilder: (context, state) {
          final data = state.extra as SpendingCategoryDetailScreenArguments;
          return _buildPage(
            context,
            state,
            SpendingCategoryDetailScreen(
              category: data.category,
              displayMonthYear: data.displayMonthYear,
            ),
            TransitionType.slideLeft,
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.fixedSpending,
        name: 'fixedSpending',
        pageBuilder: (context, state) {
          final month = state.extra as DateTime;
          return _buildPage(
            context,
            state,
            FixedSpendingDetailsScreen(month: month),
            TransitionType.slideLeft,
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.accountDetail,
        name: 'accountDetail',
        pageBuilder: (context, state) {
          final bankAccount = state.extra as BankAccount;
          return _buildPage(
            context,
            state,
            BankAccountDetailScreen(bankAccount: bankAccount),
            TransitionType.slideLeft,
          );
        },
      ),
      GoRoute(
        path: AppRoutePaths.transfer,
        name: 'transfer',
        pageBuilder: (context, state) => _buildPage(
          context,
          state,
          const TransferScreen(),
          TransitionType.slideLeft,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.transferAmount,
        name: 'transferAmount',
        pageBuilder: (context, state) => _buildPage(
          context,
          state,
          const TransferAmountScreen(),
          TransitionType.slideLeft,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.transferTo,
        name: 'transferTo',
        pageBuilder: (context, state) => _buildPage(
          context,
          state,
          const TransferToScreen(),
          TransitionType.slideLeft,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.transferConfirm,
        name: 'transferConfirm',
        pageBuilder: (context, state) => _buildPage(
          context,
          state,
          const TransferConfirmationScreen(),
          TransitionType.slideLeft,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.transferResult,
        name: 'transferResult',
        pageBuilder: (context, state) => _buildPage(
          context,
          state,
          const TransferResultScreen(),
          TransitionType.slideLeft,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.notification,
        name: 'notification',
        pageBuilder: (context, state) => _buildPage(
          context,
          state,
          const NotificationScreen(),
          TransitionType.slideLeft,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.refresh,
        name: 'refresh',
        pageBuilder: (context, state) => _buildPage(
          context,
          state,
          const RefreshInitScreen(),
          TransitionType.slideLeft,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.setting,
        name: 'setting',
        pageBuilder: (context, state) => _buildPage(
          context,
          state,
          SettingScreen(),
          TransitionType.slideLeft,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.notificationSetting,
        name: 'notificationSetting',
        pageBuilder: (context, state) => _buildPage(
          context,
          state,
          const ManageNotificationScreen(),
          TransitionType.slideLeft,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.bankAccountsSetting,
        name: 'bankAccountsSetting',
        pageBuilder: (context, state) => _buildPage(
          context,
          state,
          const ManageBankAccountsScreen(),
          TransitionType.slideLeft,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.accountSetting,
        name: 'accountSetting',
        pageBuilder: (context, state) => _buildPage(
          context,
          state,
          const ManageAccountScreen(),
          TransitionType.slideLeft,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.asset,
        name: 'asset',
        pageBuilder: (context, state) => _buildPage(
          context,
          state,
          const AssetScreen(),
          TransitionType.slideLeft,
        ),
      ),
      GoRoute(
        path: AppRoutePaths.bankAccountSetting,
        name: 'bankAccountSetting',
        pageBuilder: (context, state) {
          final bankAccount = state.extra as BankAccount;
          return _buildPage(
            context,
            state,
            ManageBankAccountScreen(bankAccount: bankAccount),
            TransitionType.slideLeft,
          );
        },
      ),
    ],
  );
});

/// Helper function to build pages with custom transitions
Page<dynamic> _buildPage(
  BuildContext context,
  GoRouterState state,
  Widget child,
  TransitionType transitionType,
) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: PrivacyProtector(
      child: DefaultTextStyle(
        style: const TextStyle(
          fontFamily: 'Inter',
          color: Color(0xFF000000),
        ),
        child: child,
      ),
    ),
    transitionType: transitionType,
    transitionDuration: const Duration(milliseconds: 150),
  );
}

/// Custom page with transition support
class CustomTransitionPage<T> extends Page<T> {
  final Widget child;
  final TransitionType transitionType;
  final Duration transitionDuration;

  const CustomTransitionPage({
    required this.child,
    required this.transitionType,
    this.transitionDuration = const Duration(milliseconds: 300),
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return PageRouteBuilder<T>(
      settings: this,
      transitionDuration: transitionDuration,
      pageBuilder: (context, animation, _) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return AppTransitions.build(transitionType, animation, child);
      },
    );
  }
}