import 'package:flow_mobile/domain/repositories/auth_repository.dart';

/// Use case for refreshing authentication tokens
abstract class RefreshTokenUseCase {
  Future<void> execute();
}

/// Implementation of refresh token use case
class RefreshTokenUseCaseImpl implements RefreshTokenUseCase {
  final AuthRepository _authRepository;

  RefreshTokenUseCaseImpl(this._authRepository);

  @override
  Future<void> execute() async {
    await _authRepository.getAndSaveRefreshTokenFromRemote();
    await _authRepository.getAndSaveAccessTokenFromRemote();
  }
}