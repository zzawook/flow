import 'package:flow_mobile/domain/repositories/user_repository.dart';

/// Use case for deleting user
abstract class DeleteUserUseCase {
  Future<void> execute();
}

/// Implementation of delete user use case
class DeleteUserUseCaseImpl implements DeleteUserUseCase {
  final UserRepository _userRepository;

  DeleteUserUseCaseImpl(this._userRepository);

  @override
  Future<void> execute() async {
    await _userRepository.deleteUser();
  }
}