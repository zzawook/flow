import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:flow_mobile/presentation/navigation/app_router.dart';
import 'package:flow_mobile/presentation/navigation/app_navigation.dart';

void main() {
  group('AppRouter Tests', () {
    testWidgets('should navigate to home route', (WidgetTester tester) async {
      final router = GoRouter(
        initialLocation: AppRoutePaths.home,
        routes: [
          GoRoute(
            path: AppRoutePaths.home,
            name: 'home',
            builder: (context, state) => const Scaffold(
              body: Text('Home Screen'),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );

      expect(find.text('Home Screen'), findsOneWidget);
    });

    testWidgets('should navigate to spending route', (WidgetTester tester) async {
      final router = GoRouter(
        initialLocation: AppRoutePaths.spending,
        routes: [
          GoRoute(
            path: AppRoutePaths.spending,
            name: 'spending',
            builder: (context, state) => const Scaffold(
              body: Text('Spending Screen'),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );

      expect(find.text('Spending Screen'), findsOneWidget);
    });

    test('should have correct route paths', () {
      expect(AppRoutePaths.home, equals('/home'));
      expect(AppRoutePaths.spending, equals('/spending'));
      expect(AppRoutePaths.spendingDetail, equals('/spending/detail'));
      expect(AppRoutePaths.category, equals('/spending/category'));
      expect(AppRoutePaths.categoryDetail, equals('/spending/category/detail'));
      expect(AppRoutePaths.fixedSpending, equals('/fixed_spending/details'));
      expect(AppRoutePaths.accountDetail, equals('/account_detail'));
      expect(AppRoutePaths.transfer, equals('/transfer'));
      expect(AppRoutePaths.transferAmount, equals('/transfer/amount'));
      expect(AppRoutePaths.transferTo, equals('/transfer/to'));
      expect(AppRoutePaths.transferConfirm, equals('/transfer/confirm'));
      expect(AppRoutePaths.transferResult, equals('/transfer/result'));
      expect(AppRoutePaths.notification, equals('/notification'));
      expect(AppRoutePaths.refresh, equals('/refresh'));
      expect(AppRoutePaths.setting, equals('/setting'));
      expect(AppRoutePaths.notificationSetting, equals('/notification/setting'));
      expect(AppRoutePaths.bankAccountSetting, equals('/bank_account/setting'));
      expect(AppRoutePaths.bankAccountsSetting, equals('/bank_accounts/setting'));
      expect(AppRoutePaths.accountSetting, equals('/account/setting'));
      expect(AppRoutePaths.asset, equals('/asset'));
    });
  });

  group('AppNavigation Tests', () {
    testWidgets('should provide type-safe navigation methods', (WidgetTester tester) async {
      late BuildContext testContext;
      
      final router = GoRouter(
        initialLocation: AppRoutePaths.home,
        routes: [
          GoRoute(
            path: AppRoutePaths.home,
            name: 'home',
            builder: (context, state) {
              testContext = context;
              return const Scaffold(
                body: Text('Home Screen'),
              );
            },
          ),
          GoRoute(
            path: AppRoutePaths.spending,
            name: 'spending',
            builder: (context, state) => const Scaffold(
              body: Text('Spending Screen'),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );

      // Test that navigation methods exist and are callable
      expect(() => AppNavigation.goToHome(testContext), returnsNormally);
      expect(() => AppNavigation.goToSpending(testContext), returnsNormally);
      expect(() => AppNavigation.pushToHome(testContext), returnsNormally);
      expect(() => AppNavigation.pushToSpending(testContext), returnsNormally);
    });
  });
}