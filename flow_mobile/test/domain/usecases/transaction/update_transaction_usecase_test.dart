import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flow_mobile/domain/entities/transaction.dart';
import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/domain/usecases/transaction/update_transaction_usecase.dart';

import '../../../mocks/repository_mocks.dart';

void main() {
  late UpdateTransactionUseCaseImpl useCase;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    useCase = UpdateTransactionUseCaseImpl(mockRepository);
  });

  group('UpdateTransactionUseCase', () {
    test('should call repository updateTransaction when execute is called', () async {
      // Arrange
      final testBankAccount = BankAccount(
        id: '1',
        bankId: 'bank1',
        accountNumber: '1234567890',
        accountType: AccountType.savings,
        balance: 1000.0,
        currency: 'USD',
        isActive: true,
      );
      
      final transaction = Transaction(
        name: 'Updated transaction',
        amount: 150.0,
        bankAccount: testBankAccount,
        category: 'Food',
        date: DateTime.now(),
        method: 'Card',
        note: 'Updated note',
      );

      when(mockRepository.updateTransaction(any))
          .thenAnswer((_) async => {});

      // Act
      await useCase.execute(transaction);

      // Assert
      verify(mockRepository.updateTransaction(transaction)).called(1);
    });

    test('should throw exception when repository throws exception', () async {
      // Arrange
      final testBankAccount = BankAccount(
        id: '1',
        bankId: 'bank1',
        accountNumber: '1234567890',
        accountType: AccountType.savings,
        balance: 1000.0,
        currency: 'USD',
        isActive: true,
      );
      
      final transaction = Transaction(
        name: 'Updated transaction',
        amount: 150.0,
        bankAccount: testBankAccount,
        category: 'Food',
        date: DateTime.now(),
        method: 'Card',
        note: 'Updated note',
      );

      when(mockRepository.updateTransaction(any))
          .thenThrow(Exception('Update failed'));

      // Act & Assert
      expect(
        () => useCase.execute(transaction),
        throwsA(isA<Exception>()),
      );
    });
  });
}