import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flow_mobile/domain/usecases/transaction/delete_transaction_usecase.dart';

import '../../../mocks/repository_mocks.dart';

void main() {
  late DeleteTransactionUseCaseImpl useCase;
  late MockTransactionRepository mockRepository;

  setUp(() {
    mockRepository = MockTransactionRepository();
    useCase = DeleteTransactionUseCaseImpl(mockRepository);
  });

  group('DeleteTransactionUseCase', () {
    test('should call repository clearTransactions when executeAll is called', () async {
      // Arrange
      when(mockRepository.clearTransactions())
          .thenAnswer((_) async => {});

      // Act
      await useCase.executeAll();

      // Assert
      verify(mockRepository.clearTransactions()).called(1);
    });

    test('should throw exception when repository throws exception', () async {
      // Arrange
      when(mockRepository.clearTransactions())
          .thenThrow(Exception('Delete failed'));

      // Act & Assert
      expect(
        () => useCase.executeAll(),
        throwsA(isA<Exception>()),
      );
    });
  });
}