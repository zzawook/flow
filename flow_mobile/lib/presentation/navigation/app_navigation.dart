import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entity/bank_account.dart';
import '../spending_category_detail_screen/spending_category_detail_screen.dart';
import 'app_router.dart';
import 'transition_type.dart';

/// Type-safe navigation methods to replace Navigator.pushNamed calls
class AppNavigation {
  /// Navigate to home screen
  static void goToHome(BuildContext context) {
    context.go(AppRoutePaths.home);
  }

  /// Navigate to spending screen
  static void goToSpending(BuildContext context) {
    context.go(AppRoutePaths.spending);
  }

  /// Navigate to spending detail screen with month data
  static void goToSpendingDetail(BuildContext context, DateTime displayedMonth) {
    context.go(AppRoutePaths.spendingDetail, extra: displayedMonth);
  }

  /// Navigate to spending category screen
  static void goToSpendingCategory(BuildContext context, DateTime displayMonthYear) {
    context.go(AppRoutePaths.category, extra: displayMonthYear);
  }

  /// Navigate to spending category detail screen
  static void goToSpendingCategoryDetail(
    BuildContext context,
    SpendingCategoryDetailScreenArguments arguments,
  ) {
    context.go(AppRoutePaths.categoryDetail, extra: arguments);
  }

  /// Navigate to fixed spending details screen
  static void goToFixedSpendingDetails(BuildContext context, DateTime month) {
    context.go(AppRoutePaths.fixedSpending, extra: month);
  }

  /// Navigate to account detail screen
  static void goToAccountDetail(BuildContext context, BankAccount bankAccount) {
    context.go(AppRoutePaths.accountDetail, extra: bankAccount);
  }

  /// Navigate to transfer screen
  static void goToTransfer(BuildContext context) {
    context.go(AppRoutePaths.transfer);
  }

  /// Navigate to transfer amount screen
  static void goToTransferAmount(BuildContext context) {
    context.go(AppRoutePaths.transferAmount);
  }

  /// Navigate to transfer to screen
  static void goToTransferTo(BuildContext context) {
    context.go(AppRoutePaths.transferTo);
  }

  /// Navigate to transfer confirmation screen
  static void goToTransferConfirm(BuildContext context) {
    context.go(AppRoutePaths.transferConfirm);
  }

  /// Navigate to transfer result screen
  static void goToTransferResult(BuildContext context) {
    context.go(AppRoutePaths.transferResult);
  }

  /// Navigate to notification screen
  static void goToNotification(BuildContext context) {
    context.go(AppRoutePaths.notification);
  }

  /// Navigate to refresh screen
  static void goToRefresh(BuildContext context) {
    context.go(AppRoutePaths.refresh);
  }

  /// Navigate to settings screen
  static void goToSettings(BuildContext context) {
    context.go(AppRoutePaths.setting);
  }

  /// Navigate to notification settings screen
  static void goToNotificationSettings(BuildContext context) {
    context.go(AppRoutePaths.notificationSetting);
  }

  /// Navigate to bank accounts settings screen
  static void goToBankAccountsSettings(BuildContext context) {
    context.go(AppRoutePaths.bankAccountsSetting);
  }

  /// Navigate to account settings screen
  static void goToAccountSettings(BuildContext context) {
    context.go(AppRoutePaths.accountSetting);
  }

  /// Navigate to asset screen
  static void goToAsset(BuildContext context) {
    context.go(AppRoutePaths.asset);
  }

  /// Navigate to bank account settings screen
  static void goToBankAccountSettings(BuildContext context, BankAccount bankAccount) {
    context.go(AppRoutePaths.bankAccountSetting, extra: bankAccount);
  }

  /// Push navigation methods (for when you want to push instead of replace)
  
  /// Push to home screen
  static void pushToHome(BuildContext context) {
    context.push(AppRoutePaths.home);
  }

  /// Push to spending screen
  static void pushToSpending(BuildContext context) {
    context.push(AppRoutePaths.spending);
  }

  /// Push to spending detail screen with month data
  static void pushToSpendingDetail(BuildContext context, DateTime displayedMonth) {
    context.push(AppRoutePaths.spendingDetail, extra: displayedMonth);
  }

  /// Push to spending category screen
  static void pushToSpendingCategory(BuildContext context, DateTime displayMonthYear) {
    context.push(AppRoutePaths.category, extra: displayMonthYear);
  }

  /// Push to spending category detail screen
  static void pushToSpendingCategoryDetail(
    BuildContext context,
    SpendingCategoryDetailScreenArguments arguments,
  ) {
    context.push(AppRoutePaths.categoryDetail, extra: arguments);
  }

  /// Push to fixed spending details screen
  static void pushToFixedSpendingDetails(BuildContext context, DateTime month) {
    context.push(AppRoutePaths.fixedSpending, extra: month);
  }

  /// Push to account detail screen
  static void pushToAccountDetail(BuildContext context, BankAccount bankAccount) {
    context.push(AppRoutePaths.accountDetail, extra: bankAccount);
  }

  /// Push to transfer screen
  static void pushToTransfer(BuildContext context) {
    context.push(AppRoutePaths.transfer);
  }

  /// Push to transfer amount screen
  static void pushToTransferAmount(BuildContext context) {
    context.push(AppRoutePaths.transferAmount);
  }

  /// Push to transfer to screen
  static void pushToTransferTo(BuildContext context) {
    context.push(AppRoutePaths.transferTo);
  }

  /// Push to transfer confirmation screen
  static void pushToTransferConfirm(BuildContext context) {
    context.push(AppRoutePaths.transferConfirm);
  }

  /// Push to transfer result screen
  static void pushToTransferResult(BuildContext context) {
    context.push(AppRoutePaths.transferResult);
  }

  /// Push to notification screen
  static void pushToNotification(BuildContext context) {
    context.push(AppRoutePaths.notification);
  }

  /// Push to refresh screen
  static void pushToRefresh(BuildContext context) {
    context.push(AppRoutePaths.refresh);
  }

  /// Push to settings screen
  static void pushToSettings(BuildContext context) {
    context.push(AppRoutePaths.setting);
  }

  /// Push to notification settings screen
  static void pushToNotificationSettings(BuildContext context) {
    context.push(AppRoutePaths.notificationSetting);
  }

  /// Push to bank accounts settings screen
  static void pushToBankAccountsSettings(BuildContext context) {
    context.push(AppRoutePaths.bankAccountsSetting);
  }

  /// Push to account settings screen
  static void pushToAccountSettings(BuildContext context) {
    context.push(AppRoutePaths.accountSetting);
  }

  /// Push to asset screen
  static void pushToAsset(BuildContext context) {
    context.push(AppRoutePaths.asset);
  }

  /// Push to bank account settings screen
  static void pushToBankAccountSettings(BuildContext context, BankAccount bankAccount) {
    context.push(AppRoutePaths.bankAccountSetting, extra: bankAccount);
  }

  /// Pop current screen
  static void pop(BuildContext context) {
    context.pop();
  }

  /// Check if can pop
  static bool canPop(BuildContext context) {
    return context.canPop();
  }
}