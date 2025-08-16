import 'package:flow_mobile/domain/entities/user.dart';
import 'package:flow_mobile/domain/repositories/user_repository.dart';

/// Use case for updating user information
abstract class UpdateUserUseCase {
  Future<void> execute(User user);
}

/// Implementation of update user use case
class UpdateUserUseCaseImpl implements UpdateUserUseCase {
  final UserRepository _userRepository;

  UpdateUserUseCaseImpl(this._userRepository);

  @override
  Future<void> execute(User user) async {
    await _userRepository.updateUser(user);
  }
}