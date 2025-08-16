import 'package:flow_mobile/domain/repositories/auth_repository.dart';

/// Use case for user logout operations
abstract class LogoutUseCase {
  Future<void> execute();
}

/// Implementation of logout use case
class LogoutUseCaseImpl implements LogoutUseCase {
  final AuthRepository _authRepository;

  LogoutUseCaseImpl(this._authRepository);

  @override
  Future<void> execute() async {
    await _authRepository.deleteAccessTokenFromLocal();
    await _authRepository.deleteRefreshTokenFromLocal();
  }
}