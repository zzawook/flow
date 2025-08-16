import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flow_mobile/domain/entities/bank.dart';
import 'package:flow_mobile/domain/usecases/bank/get_banks_usecase.dart';

import '../../../mocks/repository_mocks.dart';

void main() {
  late GetBanksUseCaseImpl useCase;
  late MockBankRepository mockRepository;

  setUp(() {
    mockRepository = MockBankRepository();
    useCase = GetBanksUseCaseImpl(mockRepository);
  });

  group('GetBanksUseCase', () {
    test('should return list of banks from repository', () async {
      // Arrange
      final expectedBanks = [
        Bank(id: '1', name: 'Bank A', logoUrl: 'logo1.png'),
        Bank(id: '2', name: 'Bank B', logoUrl: 'logo2.png'),
      ];

      when(mockRepository.getBanks())
          .thenAnswer((_) async => expectedBanks);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result, equals(expectedBanks));
      verify(mockRepository.getBanks()).called(1);
    });

    test('should return empty list when repository returns empty list', () async {
      // Arrange
      when(mockRepository.getBanks())
          .thenAnswer((_) async => []);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result, isEmpty);
      verify(mockRepository.getBanks()).called(1);
    });

    test('should throw exception when repository throws exception', () async {
      // Arrange
      when(mockRepository.getBanks())
          .thenThrow(Exception('Network error'));

      // Act & Assert
      expect(
        () => useCase.execute(),
        throwsA(isA<Exception>()),
      );
    });
  });
}