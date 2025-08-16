import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/presentation/transfer_screen/transfer_screen.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';
import 'package:flow_mobile/domain/entities/entities.dart';
import '../../test_helpers/test_helpers.dart';

void main() {
  group('TransferScreen Widget Tests', () {
    late List<BankAccount> mockBankAccounts;
    late User mockUser;

    setUp(() {
      mockUser = TestHelpers.createTestUser(nickname: 'John');
      mockBankAccounts = [
        TestHelpers.createTestBankAccount(
          accountName: 'Checking Account',
          balance: 2500.0,
        ),
        TestHelpers.createTestBankAccount(
          accountName: 'Savings Account',
          balance: 1500.0,
        ),
      ];
    });

    testWidgets('should render transfer screen with user greeting', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWith((ref) => mockUser),
            bankAccountsProvider.overrideWith((ref) => mockBankAccounts),
            currentScreenProvider.overrideWith((ref) => '/transfer'),
          ],
          child: const MaterialApp(
            home: TransferScreen(),
          ),
        ),
      );

      // Verify screen title
      expect(find.text('Transfer'), findsOneWidget);
      
      // Verify user greeting
      expect(find.text('Hi John,'), findsOneWidget);
      
      // Verify balance display
      expect(find.text('Your total balance: '), findsOneWidget);
      expect(find.text('\$4,869.17'), findsOneWidget);
    });

    testWidgets('should display bank accounts list', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWith((ref) => mockUser),
            bankAccountsProvider.overrideWith((ref) => mockBankAccounts),
            currentScreenProvider.overrideWith((ref) => '/transfer'),
          ],
          child: const MaterialApp(
            home: TransferScreen(),
          ),
        ),
      );

      // Verify ListView is present
      expect(find.byType(ListView), findsOneWidget);
      
      // Verify instruction text
      expect(find.text('Choose my bank account to transfer'), findsOneWidget);
      expect(find.text('From:'), findsOneWidget);
    });

    testWidgets('should show refresh indicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWith((ref) => mockUser),
            bankAccountsProvider.overrideWith((ref) => mockBankAccounts),
            currentScreenProvider.overrideWith((ref) => '/transfer'),
          ],
          child: const MaterialApp(
            home: TransferScreen(),
          ),
        ),
      );

      // Verify RefreshIndicator is present
      expect(find.byType(RefreshIndicator), findsOneWidget);
    });

    testWidgets('should have proper layout structure', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWith((ref) => mockUser),
            bankAccountsProvider.overrideWith((ref) => mockBankAccounts),
            currentScreenProvider.overrideWith((ref) => '/transfer'),
          ],
          child: const MaterialApp(
            home: TransferScreen(),
          ),
        ),
      );

      // Verify main layout components
      expect(find.byType(Column), findsWidgets);
      expect(find.byType(Expanded), findsOneWidget);
      
      // Verify top bar is present
      expect(find.byType(FlowTopBar), findsOneWidget);
      
      // Verify bottom navigation is present
      expect(find.byType(FlowBottomNavBar), findsOneWidget);
    });

    testWidgets('should handle empty bank accounts list', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWith((ref) => mockUser),
            bankAccountsProvider.overrideWith((ref) => <BankAccount>[]),
            currentScreenProvider.overrideWith((ref) => '/transfer'),
          ],
          child: const MaterialApp(
            home: TransferScreen(),
          ),
        ),
      );

      // Should still render without errors
      expect(find.byType(TransferScreen), findsOneWidget);
      expect(find.text('Hi John,'), findsOneWidget);
      
      // ListView should still be present but empty
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('should have correct padding and spacing', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWith((ref) => mockUser),
            bankAccountsProvider.overrideWith((ref) => mockBankAccounts),
            currentScreenProvider.overrideWith((ref) => '/transfer'),
          ],
          child: const MaterialApp(
            home: TransferScreen(),
          ),
        ),
      );

      // Verify padding is applied
      final paddingWidgets = tester.widgetList<Padding>(find.byType(Padding));
      expect(paddingWidgets.isNotEmpty, isTrue);
      
      // Verify SizedBox spacing elements
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('should display horizontal divider', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWith((ref) => mockUser),
            bankAccountsProvider.overrideWith((ref) => mockBankAccounts),
            currentScreenProvider.overrideWith((ref) => '/transfer'),
          ],
          child: const MaterialApp(
            home: TransferScreen(),
          ),
        ),
      );

      // Verify horizontal divider is present
      expect(find.byType(FlowHorizontalDivider), findsOneWidget);
    });

    testWidgets('should use correct text styles', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWith((ref) => mockUser),
            bankAccountsProvider.overrideWith((ref) => mockBankAccounts),
            currentScreenProvider.overrideWith((ref) => '/transfer'),
          ],
          child: MaterialApp(
            theme: ThemeData(
              textTheme: const TextTheme(
                titleLarge: TextStyle(fontSize: 24),
                titleSmall: TextStyle(fontSize: 16),
                labelMedium: TextStyle(fontSize: 14),
              ),
            ),
            home: const TransferScreen(),
          ),
        ),
      );

      // Verify text elements are present with correct content
      expect(find.text('Hi John,'), findsOneWidget);
      expect(find.text('Your total balance: '), findsOneWidget);
      expect(find.text('Choose my bank account to transfer'), findsOneWidget);
    });

    testWidgets('should handle pull to refresh gesture', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWith((ref) => mockUser),
            bankAccountsProvider.overrideWith((ref) => mockBankAccounts),
            currentScreenProvider.overrideWith((ref) => '/transfer'),
          ],
          child: const MaterialApp(
            home: TransferScreen(),
          ),
        ),
      );

      // Find the RefreshIndicator
      final refreshIndicator = find.byType(RefreshIndicator);
      expect(refreshIndicator, findsOneWidget);

      // Simulate pull to refresh
      await tester.fling(refreshIndicator, const Offset(0, 300), 1000);
      await tester.pump();

      // Should not throw any errors
      expect(find.byType(TransferScreen), findsOneWidget);
    });

    testWidgets('should use theme colors correctly', (WidgetTester tester) async {
      const primaryColor = Colors.blue;
      const canvasColor = Colors.white;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWith((ref) => mockUser),
            bankAccountsProvider.overrideWith((ref) => mockBankAccounts),
            currentScreenProvider.overrideWith((ref) => '/transfer'),
          ],
          child: MaterialApp(
            theme: ThemeData(
              primaryColor: primaryColor,
              canvasColor: canvasColor,
            ),
            home: const TransferScreen(),
          ),
        ),
      );

      // Verify the screen renders with theme colors
      expect(find.byType(TransferScreen), findsOneWidget);
    });
  });
}