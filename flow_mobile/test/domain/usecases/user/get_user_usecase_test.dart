import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flow_mobile/domain/entities/user.dart';
import 'package:flow_mobile/domain/usecases/user/get_user_usecase.dart';

import '../../../mocks/repository_mocks.mocks.dart';

void main() {
  late GetUserUseCaseImpl useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = GetUserUseCaseImpl(mockRepository);
  });

  group('GetUserUseCase', () {
    final testUser = User(
      name: 'John Doe',
      email: 'john@example.com',
      dateOfBirth: DateTime(1990, 1, 1),
      phoneNumber: '+1234567890',
      nickname: 'Johnny',
    );

    test('should return user from repository', () async {
      // Arrange
      when(mockRepository.getUser())
          .thenAnswer((_) async => testUser);

      // Act
      final result = await useCase.execute();

      // Assert
      expect(result, equals(testUser));
      verify(mockRepository.getUser()).called(1);
    });

    test('should throw exception when repository throws exception', () async {
      // Arrange
      when(mockRepository.getUser())
          .thenThrow(Exception('User not found'));

      // Act & Assert
      expect(
        () => useCase.execute(),
        throwsA(isA<Exception>()),
      );
    });
  });
}