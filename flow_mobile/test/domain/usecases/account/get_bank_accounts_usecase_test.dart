import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/domain/usecases/account/get_accounts_usecase.dart';

import '../../../mocks/repository_mocks.dart';

void main() {
  late GetAccountsUseCaseImpl useCase;
  late MockAccountRepository mockRepository;

  setUp(() {
    mockRepository = MockAccountRepository();
    useCase = GetAccountsUseCaseImpl(mockRepository);
  });

  group('GetAccountsUseCase', () {
    final testAccounts = [
      BankAccount(
        id: '1',
        bankId: 'bank1',
        accountNumber: '1234567890',
        accountType: AccountType.savings,
        balance: 1000.0,
        currency: 'USD',
        isActive: true,
      ),
      BankAccount(
        id: '2',
        bankId: 'bank2',
        accountNumber: '0987654321',
        accountType: AccountType.checking,
        balance: 2500.0,
        currency: 'USD',
        isActive: true,
      ),
    ];

    test('should return list of bank accounts from repository', () async {
      // Arrange
      when(mockRepository.getBankAccounts())
          .thenAnswer((_) async => testAccounts);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result, equals(testAccounts));
      verify(mockRepository.getBankAccounts()).called(1);
    });

    test('should return empty list when repository returns empty list', () async {
      // Arrange
      when(mockRepository.getBankAccounts())
          .thenAnswer((_) async => []);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result, isEmpty);
      verify(mockRepository.getBankAccounts()).called(1);
    });

    test('should throw exception when repository throws exception', () async {
      // Arrange
      when(mockRepository.getBankAccounts())
          .thenThrow(Exception('Failed to fetch accounts'));

      // Act & Assert
      expect(
        () => useCase.execute(),
        throwsA(isA<Exception>()),
      );
    });
  });
}