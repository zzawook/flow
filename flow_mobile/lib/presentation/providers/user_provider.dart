import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/presentation/providers/state_models/state_models.dart';
import 'package:flow_mobile/domain/usecases/usecases.dart';
import 'package:flow_mobile/domain/entities/entities.dart';
import 'package:flow_mobile/core/providers/providers.dart';


/// StateNotifier for User state management
class UserNotifier extends StateNotifier<UserStateModel> {
  final GetUserUseCase _getUserUseCase;
  final UpdateUserUseCase _updateUserUseCase;
  final DeleteUserUseCase _deleteUserUseCase;

  UserNotifier(
    this._getUserUseCase,
    this._updateUserUseCase,
    this._deleteUserUseCase,
  ) : super(UserStateModel.initial());

  /// Load user data
  Future<void> loadUser() async {
    try {
      final user = await _getUserUseCase.execute();
      state = state.copyWith(user: user);
    } catch (e) {
      // Handle error - maintain existing error handling behavior
      // Error handling will be implemented in a later task
    }
  }

  /// Update user data
  Future<void> updateUser(User user) async {
    try {
      await _updateUserUseCase.execute(user);
      state = state.copyWith(user: user);
    } catch (e) {
      // Handle error - maintain existing error handling behavior
      // Error handling will be implemented in a later task
    }
  }

  /// Delete user data
  Future<void> deleteUser() async {
    try {
      await _deleteUserUseCase.execute();
      state = UserStateModel.initial();
    } catch (e) {
      // Handle error - maintain existing error handling behavior
      // Error handling will be implemented in a later task
    }
  }
}

/// Provider for UserNotifier
final userNotifierProvider = StateNotifierProvider<UserNotifier, UserStateModel>((ref) {
  return UserNotifier(
    ref.read(getUserUseCaseProvider).value!,
    ref.read(updateUserUseCaseProvider).value!,
    ref.read(deleteUserUseCaseProvider).value!,
  );
});

/// Convenience provider for accessing user state
final userStateProvider = Provider<UserStateModel>((ref) {
  return ref.watch(userNotifierProvider);
});

/// Convenience provider for accessing current user
final currentUserProvider = Provider<User>((ref) {
  return ref.watch(userNotifierProvider).user;
});