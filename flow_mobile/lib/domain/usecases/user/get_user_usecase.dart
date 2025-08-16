import 'package:flow_mobile/domain/entities/user.dart';
import 'package:flow_mobile/domain/repositories/user_repository.dart';

/// Use case for getting user information
abstract class GetUserUseCase {
  Future<User> execute();
}

/// Implementation of get user use case
class GetUserUseCaseImpl implements GetUserUseCase {
  final UserRepository _userRepository;

  GetUserUseCaseImpl(this._userRepository);

  @override
  Future<User> execute() async {
    return await _userRepository.getUser();
  }
}