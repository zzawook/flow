import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entity/bank_account.dart';
import '../spending_category_detail_screen/spending_category_detail_screen.dart';
import 'app_navigation.dart';
import 'custom_page_route_arguments.dart';

/// Compatibility layer to help migrate from Navigator.pushNamed to GoRouter
/// This provides the same interface as the old navigation system
class NavigationCompatibility {
  /// Helper method to convert old Navigator.pushNamed calls to GoRouter
  static void pushNamed(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    switch (routeName) {
      case '/home':
        AppNavigation.pushToHome(context);
        break;
      case '/spending':
        AppNavigation.pushToSpending(context);
        break;
      case '/spending/detail':
        if (arguments is DateTime) {
          AppNavigation.pushToSpendingDetail(context, arguments);
        }
        break;
      case '/spending/category':
        if (arguments is DateTime) {
          AppNavigation.pushToSpendingCategory(context, arguments);
        }
        break;
      case '/spending/category/detail':
        if (arguments is SpendingCategoryDetailScreenArguments) {
          AppNavigation.pushToSpendingCategoryDetail(context, arguments);
        }
        break;
      case '/fixed_spending/details':
        if (arguments is DateTime) {
          AppNavigation.pushToFixedSpendingDetails(context, arguments);
        }
        break;
      case '/account_detail':
        if (arguments is BankAccount) {
          AppNavigation.pushToAccountDetail(context, arguments);
        }
        break;
      case '/transfer':
        AppNavigation.pushToTransfer(context);
        break;
      case '/transfer/amount':
        AppNavigation.pushToTransferAmount(context);
        break;
      case '/transfer/to':
        AppNavigation.pushToTransferTo(context);
        break;
      case '/transfer/confirm':
        AppNavigation.pushToTransferConfirm(context);
        break;
      case '/transfer/result':
        AppNavigation.pushToTransferResult(context);
        break;
      case '/notification':
        AppNavigation.pushToNotification(context);
        break;
      case '/refresh':
        AppNavigation.pushToRefresh(context);
        break;
      case '/setting':
        AppNavigation.pushToSettings(context);
        break;
      case '/notification/setting':
        AppNavigation.pushToNotificationSettings(context);
        break;
      case '/bank_accounts/setting':
        AppNavigation.pushToBankAccountsSettings(context);
        break;
      case '/account/setting':
        AppNavigation.pushToAccountSettings(context);
        break;
      case '/asset':
        AppNavigation.pushToAsset(context);
        break;
      case '/bank_account/setting':
        if (arguments is BankAccount) {
          AppNavigation.pushToBankAccountSettings(context, arguments);
        }
        break;
      default:
        // Fallback to home if route not found
        AppNavigation.pushToHome(context);
        break;
    }
  }

  /// Helper method to extract arguments from CustomPageRouteArguments
  static Object? extractArguments(Object? arguments) {
    if (arguments is CustomPageRouteArguments) {
      return arguments.extraData;
    }
    return arguments;
  }

  /// Helper method to convert old Navigator.pushNamed with CustomPageRouteArguments
  static void pushNamedWithArguments(
    BuildContext context,
    String routeName,
    CustomPageRouteArguments arguments,
  ) {
    pushNamed(context, routeName, arguments: arguments.extraData);
  }

  /// Pop current screen - same as before
  static void pop(BuildContext context) {
    context.pop();
  }

  /// Check if can pop - same as before
  static bool canPop(BuildContext context) {
    return context.canPop();
  }
}

/// Extension on BuildContext to provide familiar navigation methods
extension NavigationExtension on BuildContext {
  /// Push named route with GoRouter
  void pushNamedGoRouter(String routeName, {Object? arguments}) {
    NavigationCompatibility.pushNamed(this, routeName, arguments: arguments);
  }

  /// Pop with GoRouter
  void popGoRouter() {
    NavigationCompatibility.pop(this);
  }

  /// Check if can pop with GoRouter
  bool canPopGoRouter() {
    return NavigationCompatibility.canPop(this);
  }
}