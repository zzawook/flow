import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flow_mobile/domain/entities/date_spending_statistics.dart';
import 'package:flow_mobile/domain/usecases/spending/get_spending_usecase.dart';

import '../../../mocks/repository_mocks.dart';

void main() {
  late GetSpendingUseCaseImpl useCase;
  late MockSpendingRepository mockRepository;

  setUp(() {
    mockRepository = MockSpendingRepository();
    useCase = GetSpendingUseCaseImpl(mockRepository);
  });

  group('GetSpendingUseCase', () {
    final testDate = DateTime(2024, 1, 1);
    final testStatistics = DateSpendingStatistics(
      date: testDate,
      totalSpent: 500.0,
      categoryBreakdown: {
        'Food': 200.0,
        'Transport': 150.0,
        'Entertainment': 150.0,
      },
      transactionCount: 10,
    );

    test('should return spending statistics from repository', () async {
      // Arrange
      when(mockRepository.getSpending(any))
          .thenAnswer((_) async => testStatistics);

      // Act
      final result = await useCase.execute(testDate);

      // Assert
      expect(result, equals(testStatistics));
      verify(mockRepository.getSpending(testDate)).called(1);
    });

    test('should throw exception when repository throws exception', () async {
      // Arrange
      when(mockRepository.getSpending(any))
          .thenThrow(Exception('Statistics calculation failed'));

      // Act & Assert
      expect(
        () => useCase.execute(testDate),
        throwsA(isA<Exception>()),
      );
    });
  });
}