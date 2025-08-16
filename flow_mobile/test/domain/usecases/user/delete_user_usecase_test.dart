import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flow_mobile/domain/usecases/user/delete_user_usecase.dart';

import '../../../mocks/repository_mocks.dart';

void main() {
  late DeleteUserUseCaseImpl useCase;
  late MockUserRepository mockRepository;

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = DeleteUserUseCaseImpl(mockRepository);
  });

  group('DeleteUserUseCase', () {
    test('should call repository deleteUser when execute is called', () async {
      // Arrange
      when(mockRepository.deleteUser())
          .thenAnswer((_) async => {});

      // Act
      await useCase.execute();

      // Assert
      verify(mockRepository.deleteUser()).called(1);
    });

    test('should throw exception when repository throws exception', () async {
      // Arrange
      when(mockRepository.deleteUser())
          .thenThrow(Exception('Delete failed'));

      // Act & Assert
      expect(
        () => useCase.execute(),
        throwsA(isA<Exception>()),
      );
    });
  });
}