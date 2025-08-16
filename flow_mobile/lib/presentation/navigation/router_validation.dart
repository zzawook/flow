import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_router.dart';
import 'app_navigation.dart';

/// Validation class to ensure GoRouter setup is correct
class RouterValidation {
  /// Validate that all route paths are correctly defined
  static bool validateRoutePaths() {
    final paths = [
      AppRoutePaths.home,
      AppRoutePaths.spending,
      AppRoutePaths.spendingDetail,
      AppRoutePaths.category,
      AppRoutePaths.categoryDetail,
      AppRoutePaths.fixedSpending,
      AppRoutePaths.accountDetail,
      AppRoutePaths.transfer,
      AppRoutePaths.transferAmount,
      AppRoutePaths.transferTo,
      AppRoutePaths.transferConfirm,
      AppRoutePaths.transferResult,
      AppRoutePaths.notification,
      AppRoutePaths.refresh,
      AppRoutePaths.setting,
      AppRoutePaths.notificationSetting,
      AppRoutePaths.bankAccountSetting,
      AppRoutePaths.bankAccountsSetting,
      AppRoutePaths.accountSetting,
      AppRoutePaths.asset,
    ];

    // Check that all paths start with '/'
    for (final path in paths) {
      if (!path.startsWith('/')) {
        debugPrint('Invalid path: $path - must start with /');
        return false;
      }
    }

    debugPrint('All route paths are valid');
    return true;
  }

  /// Validate that navigation methods exist and are callable
  static bool validateNavigationMethods() {
    try {
      // This is a compile-time check - if these methods don't exist, 
      // the code won't compile
      final methods = [
        AppNavigation.goToHome,
        AppNavigation.goToSpending,
        AppNavigation.goToTransfer,
        AppNavigation.goToAsset,
        AppNavigation.goToSettings,
        AppNavigation.pushToHome,
        AppNavigation.pushToSpending,
        AppNavigation.pushToTransfer,
        AppNavigation.pushToAsset,
        AppNavigation.pushToSettings,
      ];

      debugPrint('All navigation methods are available: ${methods.length} methods');
      return true;
    } catch (e) {
      debugPrint('Navigation methods validation failed: $e');
      return false;
    }
  }

  /// Run all validations
  static bool runAllValidations() {
    debugPrint('Running GoRouter validation...');
    
    final pathsValid = validateRoutePaths();
    final methodsValid = validateNavigationMethods();
    
    final allValid = pathsValid && methodsValid;
    
    if (allValid) {
      debugPrint('✅ GoRouter setup validation passed');
    } else {
      debugPrint('❌ GoRouter setup validation failed');
    }
    
    return allValid;
  }
}