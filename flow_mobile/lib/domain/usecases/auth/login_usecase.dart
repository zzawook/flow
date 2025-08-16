import 'package:flow_mobile/domain/repositories/auth_repository.dart';

/// Use case for user login operations
abstract class LoginUseCase {
  Future<bool> execute();
}

/// Implementation of login use case
class LoginUseCaseImpl implements LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCaseImpl(this._authRepository);

  @override
  Future<bool> execute() async {
    return await _authRepository.attemptLogin();
  }
}