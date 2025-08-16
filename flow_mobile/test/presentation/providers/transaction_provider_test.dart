import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/domain/entities/transaction.dart';
import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/domain/usecases/transaction/create_transaction_usecase.dart';
import 'package:flow_mobile/domain/usecases/transaction/update_transaction_usecase.dart';
import 'package:flow_mobile/domain/usecases/transaction/delete_transaction_usecase.dart';
import 'package:flow_mobile/domain/usecases/transaction/get_transactions_usecase.dart';
import 'package:flow_mobile/presentation/providers/transaction_provider.dart';
import 'package:flow_mobile/presentation/providers/state_models/state_models.dart';
import 'package:flow_mobile/core/errors/app_error.dart';

import 'transaction_provider_test.mocks.dart';

@GenerateMocks([
  GetTransactionsUseCase,
  CreateTransactionUseCase,
  UpdateTransactionUseCase,
  DeleteTransactionUseCase,
])
void main() {
  late TransactionNotifier notifier;
  late MockGetTransactionsUseCase mockGetTransactionsUseCase;
  late MockCreateTransactionUseCase mockCreateTransactionUseCase;
  late MockUpdateTransactionUseCase mockUpdateTransactionUseCase;
  late MockDeleteTransactionUseCase mockDeleteTransactionUseCase;

  setUp(() {
    mockGetTransactionsUseCase = MockGetTransactionsUseCase();
    mockCreateTransactionUseCase = MockCreateTransactionUseCase();
    mockUpdateTransactionUseCase = MockUpdateTransactionUseCase();
    mockDeleteTransactionUseCase = MockDeleteTransactionUseCase();
    
    notifier = TransactionNotifier(
      mockGetTransactionsUseCase,
      mockCreateTransactionUseCase,
      mockUpdateTransactionUseCase,
      mockDeleteTransactionUseCase,
    );
  });

  group('TransactionNotifier', () {
    final testBankAccount = BankAccount(
      id: '1',
      bankId: 'bank1',
      accountNumber: '1234567890',
      accountType: AccountType.savings,
      balance: 1000.0,
      currency: 'USD',
      isActive: true,
    );
    
    final testTransaction = Transaction(
      name: 'Test transaction',
      amount: 100.0,
      bankAccount: testBankAccount,
      category: 'Food',
      date: DateTime.now(),
      method: 'Card',
      note: 'Test note',
    );

    group('loadTransactions', () {
      test('should update state with transactions when successful', () async {
        // Arrange
        final expectedTransactions = [testTransaction];
        when(mockGetTransactionsUseCase.executeAll())
            .thenAnswer((_) async => expectedTransactions);

        // Act
        await notifier.loadTransactions();

        // Assert
        expect(notifier.state.transactions, equals(expectedTransactions));
        expect(notifier.state.isLoading, isFalse);
        expect(notifier.state.error, isNull);
        verify(mockGetTransactionsUseCase.executeAll()).called(1);
      });

      test('should set loading state during execution', () async {
        // Arrange
        when(mockGetTransactionsUseCase.executeAll())
            .thenAnswer((_) async => []);

        // Act
        final future = notifier.loadTransactions();
        
        // Assert loading state
        expect(notifier.state.isLoading, isTrue);
        
        await future;
        expect(notifier.state.isLoading, isFalse);
      });

      test('should update state with error when use case throws', () async {
        // Arrange
        when(mockGetTransactionsUseCase.executeAll())
            .thenThrow(Exception('Network error'));

        // Act
        await notifier.loadTransactions();

        // Assert
        expect(notifier.state.isLoading, isFalse);
        expect(notifier.state.error, isA<AppError>());
        expect(notifier.state.transactions, isEmpty);
      });
    });

    group('createTransaction', () {
      test('should create transaction and reload list when successful', () async {
        // Arrange
        when(mockCreateTransactionUseCase.execute(any))
            .thenAnswer((_) async => {});
        when(mockGetTransactionsUseCase.executeAll())
            .thenAnswer((_) async => [testTransaction]);

        // Act
        await notifier.createTransaction(testTransaction);

        // Assert
        verify(mockCreateTransactionUseCase.execute(testTransaction)).called(1);
        verify(mockGetTransactionsUseCase.executeAll()).called(1);
        expect(notifier.state.transactions, contains(testTransaction));
        expect(notifier.state.isLoading, isFalse);
        expect(notifier.state.error, isNull);
      });

      test('should update state with error when use case throws', () async {
        // Arrange
        when(mockCreateTransactionUseCase.execute(any))
            .thenThrow(Exception('Creation failed'));

        // Act
        await notifier.createTransaction(testTransaction);

        // Assert
        expect(notifier.state.isLoading, isFalse);
        expect(notifier.state.error, isA<AppError>());
      });
    });

    group('updateTransaction', () {
      test('should update transaction and reload list when successful', () async {
        // Arrange
        when(mockUpdateTransactionUseCase.execute(any))
            .thenAnswer((_) async => {});
        when(mockGetTransactionsUseCase.executeAll())
            .thenAnswer((_) async => [testTransaction]);

        // Act
        await notifier.updateTransaction(testTransaction);

        // Assert
        verify(mockUpdateTransactionUseCase.execute(testTransaction)).called(1);
        verify(mockGetTransactionsUseCase.executeAll()).called(1);
        expect(notifier.state.isLoading, isFalse);
        expect(notifier.state.error, isNull);
      });

      test('should update state with error when use case throws', () async {
        // Arrange
        when(mockUpdateTransactionUseCase.execute(any))
            .thenThrow(Exception('Update failed'));

        // Act
        await notifier.updateTransaction(testTransaction);

        // Assert
        expect(notifier.state.isLoading, isFalse);
        expect(notifier.state.error, isA<AppError>());
      });
    });

    group('deleteAllTransactions', () {
      test('should delete all transactions and clear state when successful', () async {
        // Arrange
        when(mockDeleteTransactionUseCase.executeAll())
            .thenAnswer((_) async => {});

        // Act
        await notifier.deleteAllTransactions();

        // Assert
        verify(mockDeleteTransactionUseCase.executeAll()).called(1);
        expect(notifier.state.transactions, isEmpty);
        expect(notifier.state.isLoading, isFalse);
        expect(notifier.state.error, isNull);
      });

      test('should update state with error when use case throws', () async {
        // Arrange
        when(mockDeleteTransactionUseCase.executeAll())
            .thenThrow(Exception('Delete failed'));

        // Act
        await notifier.deleteAllTransactions();

        // Assert
        expect(notifier.state.isLoading, isFalse);
        expect(notifier.state.error, isA<AppError>());
      });
    });

    group('clearError', () {
      test('should clear error from state', () {
        // Arrange
        notifier.state = notifier.state.copyWith(
          error: const AppError.network('Test error'),
        );

        // Act
        notifier.clearError();

        // Assert
        expect(notifier.state.error, isNull);
      });
    });

    group('retryLastOperation', () {
      test('should retry loading transactions when error is retryable', () async {
        // Arrange
        notifier.state = notifier.state.copyWith(
          error: const AppError.network('Network error'),
        );
        when(mockGetTransactionsUseCase.executeAll())
            .thenAnswer((_) async => [testTransaction]);

        // Act
        await notifier.retryLastOperation();

        // Assert
        verify(mockGetTransactionsUseCase.executeAll()).called(1);
        expect(notifier.state.error, isNull);
      });
    });
  });
}