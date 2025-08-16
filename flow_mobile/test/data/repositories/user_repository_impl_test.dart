import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flow_mobile/domain/entities/user.dart';
import 'package:flow_mobile/data/repositories/user_repository_impl.dart';
import 'package:flow_mobile/data/datasources/local/user_local_datasource.dart';
import 'package:flow_mobile/data/datasources/remote/user_remote_datasource.dart';

import 'user_repository_impl_test.mocks.dart';

@GenerateMocks([UserLocalDataSource, UserRemoteDataSource])
void main() {
  late UserRepositoryImpl repository;
  late MockUserLocalDataSource mockLocalDataSource;
  late MockUserRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockLocalDataSource = MockUserLocalDataSource();
    mockRemoteDataSource = MockUserRemoteDataSource();
    repository = UserRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
    );
  });

  group('UserRepositoryImpl', () {
    final testUser = User(
      id: '1',
      name: 'John Doe',
      email: 'john@example.com',
      phoneNumber: '+1234567890',
    );

    group('getUser', () {
      test('should return user from local data source', () async {
        // Arrange
        when(mockLocalDataSource.getUser())
            .thenAnswer((_) async => testUser);

        // Act
        final result = await repository.getUser();

        // Assert
        expect(result, equals(testUser));
        verify(mockLocalDataSource.getUser()).called(1);
      });

      test('should throw exception when local data source throws', () async {
        // Arrange
        when(mockLocalDataSource.getUser())
            .thenThrow(Exception('User not found'));

        // Act & Assert
        expect(
          () => repository.getUser(),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('updateUser', () {
      test('should call local data source updateUser', () async {
        // Arrange
        when(mockLocalDataSource.updateUser(any))
            .thenAnswer((_) async => {});

        // Act
        await repository.updateUser(testUser);

        // Assert
        verify(mockLocalDataSource.updateUser(testUser)).called(1);
      });

      test('should throw exception when local data source throws', () async {
        // Arrange
        when(mockLocalDataSource.updateUser(any))
            .thenThrow(Exception('Update failed'));

        // Act & Assert
        expect(
          () => repository.updateUser(testUser),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('deleteUser', () {
      test('should call local data source deleteUser', () async {
        // Arrange
        when(mockLocalDataSource.deleteUser())
            .thenAnswer((_) async => {});

        // Act
        await repository.deleteUser();

        // Assert
        verify(mockLocalDataSource.deleteUser()).called(1);
      });

      test('should throw exception when local data source throws', () async {
        // Arrange
        when(mockLocalDataSource.deleteUser())
            .thenThrow(Exception('Delete failed'));

        // Act & Assert
        expect(
          () => repository.deleteUser(),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}