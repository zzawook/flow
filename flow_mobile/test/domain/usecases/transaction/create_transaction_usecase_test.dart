import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flow_mobile/domain/entities/transaction.dart';
import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/domain/entities/bank.dart';
import 'package:flow_mobile/domain/repositories/transaction_repository.dart';
import 'package:flow_mobile/domain/usecases/transaction/create_transaction_usecase.dart';

import 'create_transaction_usecase_test.mocks.dart';

@GenerateMocks([TransactionRepository])
void main() {
  late CreateTransactionUseCaseImpl useCase;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    useCase = CreateTransactionUseCaseImpl(mockRepository);
  });

  group('CreateTransactionUseCase', () {
    test('should call repository addTransaction when execute is called', () async {
      // Arrange
      final testBank = Bank(
        name: 'Test Bank',
        logoPath: 'assets/bank_logos/test.png',
      );
      
      final testBankAccount = BankAccount(
        accountNumber: '1234567890',
        accountHolder: 'John Doe',
        balance: 1000.0,
        accountName: 'Test Account',
        bank: testBank,
        transferCount: 0,
        isHidden: false,
      );
      
      final transaction = Transaction(
        name: 'Test transaction',
        amount: 100.0,
        bankAccount: testBankAccount,
        category: 'Food',
        date: DateTime.now(),
        method: 'Card',
        note: 'Test note',
      );

      when(mockRepository.addTransaction(any))
          .thenAnswer((_) async => {});

      // Act
      await useCase.execute(transaction);

      // Assert
      verify(mockRepository.addTransaction(transaction)).called(1);
    });

    test('should throw exception when repository throws exception', () async {
      // Arrange
      final testBank = Bank(
        name: 'Test Bank',
        logoPath: 'assets/bank_logos/test.png',
      );
      
      final testBankAccount = BankAccount(
        accountNumber: '1234567890',
        accountHolder: 'John Doe',
        balance: 1000.0,
        accountName: 'Test Account',
        bank: testBank,
        transferCount: 0,
        isHidden: false,
      );
      
      final transaction = Transaction(
        name: 'Test transaction',
        amount: 100.0,
        bankAccount: testBankAccount,
        category: 'Food',
        date: DateTime.now(),
        method: 'Card',
        note: 'Test note',
      );

      when(mockRepository.addTransaction(any))
          .thenThrow(Exception('Database error'));

      // Act & Assert
      expect(
        () => useCase.execute(transaction),
        throwsA(isA<Exception>()),
      );
    });
  });
}