import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flow_mobile/domain/entities/user.dart';
import 'package:flow_mobile/domain/usecases/user/update_user_usecase.dart';

import '../../../mocks/repository_mocks.dart';

void main() {
  late UpdateUserUseCaseImpl useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = UpdateUserUseCaseImpl(mockRepository);
  });

  group('UpdateUserUseCase', () {
    final testUser = User(
      id: '1',
      name: 'John Doe',
      email: 'john@example.com',
      phoneNumber: '+1234567890',
    );

    test('should call repository updateUser when execute is called', () async {
      // Arrange
      when(mockRepository.updateUser(any))
          .thenAnswer((_) async => {});

      // Act
      await useCase.execute(testUser);

      // Assert
      verify(mockRepository.updateUser(testUser)).called(1);
    });

    test('should throw exception when repository throws exception', () async {
      // Arrange
      when(mockRepository.updateUser(any))
          .thenThrow(Exception('Update failed'));

      // Act & Assert
      expect(
        () => useCase.execute(testUser),
        throwsA(isA<Exception>()),
      );
    });
  });
}