import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flow_mobile/domain/entities/user.dart';
import 'package:flow_mobile/domain/usecases/user/get_user_usecase.dart';
import 'package:flow_mobile/domain/usecases/user/update_user_usecase.dart';
import 'package:flow_mobile/domain/usecases/user/delete_user_usecase.dart';
import 'package:flow_mobile/presentation/providers/user_provider.dart';
import 'package:flow_mobile/presentation/providers/state_models/state_models.dart';

import 'user_provider_test.mocks.dart';

@GenerateMocks([
  GetUserUseCase,
  UpdateUserUseCase,
  DeleteUserUseCase,
])
void main() {
  late UserNotifier notifier;
  late MockGetUserUseCase mockGetUserUseCase;
  late MockUpdateUserUseCase mockUpdateUserUseCase;
  late MockDeleteUserUseCase mockDeleteUserUseCase;

  setUp(() {
    mockGetUserUseCase = MockGetUserUseCase();
    mockUpdateUserUseCase = MockUpdateUserUseCase();
    mockDeleteUserUseCase = MockDeleteUserUseCase();
    
    notifier = UserNotifier(
      mockGetUserUseCase,
      mockUpdateUserUseCase,
      mockDeleteUserUseCase,
    );
  });

  group('UserNotifier', () {
    final testUser = User(
      id: '1',
      name: 'John Doe',
      email: 'john@example.com',
      phoneNumber: '+1234567890',
    );

    group('loadUser', () {
      test('should update state with user when successful', () async {
        // Arrange
        when(mockGetUserUseCase.execute())
            .thenAnswer((_) async => testUser);

        // Act
        await notifier.loadUser();

        // Assert
        expect(notifier.state.user, equals(testUser));
        verify(mockGetUserUseCase.execute()).called(1);
      });

      test('should handle exception gracefully', () async {
        // Arrange
        when(mockGetUserUseCase.execute())
            .thenThrow(Exception('User not found'));

        // Act & Assert - should not throw
        await notifier.loadUser();
        
        // State should remain unchanged (initial state)
        expect(notifier.state.user.id, isEmpty);
      });
    });

    group('updateUser', () {
      test('should update state with new user when successful', () async {
        // Arrange
        final updatedUser = testUser.copyWith(name: 'Jane Doe');
        when(mockUpdateUserUseCase.execute(any))
            .thenAnswer((_) async => {});

        // Act
        await notifier.updateUser(updatedUser);

        // Assert
        expect(notifier.state.user, equals(updatedUser));
        verify(mockUpdateUserUseCase.execute(updatedUser)).called(1);
      });

      test('should handle exception gracefully', () async {
        // Arrange
        when(mockUpdateUserUseCase.execute(any))
            .thenThrow(Exception('Update failed'));

        // Act & Assert - should not throw
        await notifier.updateUser(testUser);
        
        // Verify the use case was called despite the error
        verify(mockUpdateUserUseCase.execute(testUser)).called(1);
      });
    });

    group('deleteUser', () {
      test('should reset state to initial when successful', () async {
        // Arrange
        notifier.state = notifier.state.copyWith(user: testUser);
        when(mockDeleteUserUseCase.execute())
            .thenAnswer((_) async => {});

        // Act
        await notifier.deleteUser();

        // Assert
        expect(notifier.state.user.id, isEmpty);
        expect(notifier.state.user.name, isEmpty);
        expect(notifier.state.user.email, isEmpty);
        verify(mockDeleteUserUseCase.execute()).called(1);
      });

      test('should handle exception gracefully', () async {
        // Arrange
        notifier.state = notifier.state.copyWith(user: testUser);
        when(mockDeleteUserUseCase.execute())
            .thenThrow(Exception('Delete failed'));

        // Act & Assert - should not throw
        await notifier.deleteUser();
        
        // Verify the use case was called despite the error
        verify(mockDeleteUserUseCase.execute()).called(1);
      });
    });

    group('initial state', () {
      test('should have correct initial state', () {
        // Arrange & Act
        final initialNotifier = UserNotifier(
          mockGetUserUseCase,
          mockUpdateUserUseCase,
          mockDeleteUserUseCase,
        );

        // Assert
        expect(initialNotifier.state.user.id, isEmpty);
        expect(initialNotifier.state.user.name, isEmpty);
        expect(initialNotifier.state.user.email, isEmpty);
        expect(initialNotifier.state.user.phoneNumber, isEmpty);
      });
    });
  });
}