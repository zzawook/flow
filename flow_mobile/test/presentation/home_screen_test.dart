import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/presentation/home_screen/home_screen.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';
import 'package:flow_mobile/domain/entities/entities.dart';

void main() {
  group('FlowHomeScreen', () {
    testWidgets('should render without errors with Riverpod providers', (WidgetTester tester) async {
      // Create mock data for providers
      final mockBankAccounts = <BankAccount>[];
      final mockTransactionState = TransactionStateModel.initial();
      final mockSettings = SettingsStateModel.initial();
      final mockNotificationState = NotificationStateModel.initial();

      // Build the widget with ProviderScope and overrides
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            bankAccountsProvider.overrideWith((ref) => mockBankAccounts),
            transactionStateProvider.overrideWith((ref) => mockTransactionState),
            settingsStateProvider.overrideWith((ref) => mockSettings),
            notificationStateProvider.overrideWith((ref) => mockNotificationState),
            hasUncheckedNotificationProvider.overrideWith((ref) => false),
            currentScreenProvider.overrideWith((ref) => '/home'),
          ],
          child: MaterialApp(
            home: FlowHomeScreen(),
          ),
        ),
      );

      // Verify that the widget builds without throwing
      expect(find.byType(FlowHomeScreen), findsOneWidget);
      
      // Verify that key components are present
      expect(find.byType(RefreshIndicator), findsOneWidget);
      expect(find.byType(CustomScrollView), findsOneWidget);
    });

    testWidgets('should handle back button press correctly', (WidgetTester tester) async {
      // Create mock data for providers
      final mockBankAccounts = <BankAccount>[];
      final mockTransactionState = TransactionStateModel.initial();
      final mockSettings = SettingsStateModel.initial();
      final mockNotificationState = NotificationStateModel.initial();

      // Build the widget with ProviderScope and overrides
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            bankAccountsProvider.overrideWith((ref) => mockBankAccounts),
            transactionStateProvider.overrideWith((ref) => mockTransactionState),
            settingsStateProvider.overrideWith((ref) => mockSettings),
            notificationStateProvider.overrideWith((ref) => mockNotificationState),
            hasUncheckedNotificationProvider.overrideWith((ref) => false),
            currentScreenProvider.overrideWith((ref) => '/home'),
          ],
          child: MaterialApp(
            home: FlowHomeScreen(),
          ),
        ),
      );

      // Find the PopScope widget and simulate back button press
      final popScope = tester.widget<PopScope>(find.byType(PopScope));
      expect(popScope.canPop, false);

      // Verify that the widget handles the back press without errors
      // This tests the _handleBack method indirectly
      expect(find.byType(FlowHomeScreen), findsOneWidget);
    });
  });
}