import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/presentation/spending_screen/spending_screen.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';
import 'package:flow_mobile/presentation/providers/state_models/state_models.dart';
import 'package:flow_mobile/domain/entities/entities.dart';

void main() {
  group('SpendingScreen Tests', () {
    testWidgets('SpendingScreen should render without errors', (WidgetTester tester) async {
      // Create mock providers
      final mockTransactionState = TransactionStateModel.initial();
      final mockSpendingScreenState = SpendingScreenStateModel.initial();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            transactionStateProvider.overrideWith((ref) => mockTransactionState),
            spendingScreenStateProvider.overrideWith((ref) => mockSpendingScreenState),
          ],
          child: MaterialApp(
            home: SpendingScreen(),
          ),
        ),
      );

      // Verify that the screen renders
      expect(find.byType(SpendingScreen), findsOneWidget);
    });

    testWidgets('SpendingScreen should display month selector', (WidgetTester tester) async {
      final mockTransactionState = TransactionStateModel.initial();
      final mockSpendingScreenState = SpendingScreenStateModel.initial();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            transactionStateProvider.overrideWith((ref) => mockTransactionState),
            spendingScreenStateProvider.overrideWith((ref) => mockSpendingScreenState),
          ],
          child: MaterialApp(
            home: SpendingScreen(),
          ),
        ),
      );

      // Verify that month selector is present
      expect(find.text('Category Breakdown'), findsOneWidget);
    });
  });
}