import 'package:flow_mobile/domain/repositories/auth_repository.dart';

/// Use case for checking authentication status
abstract class GetAuthStatusUseCase {
  Future<bool> execute();
}

/// Implementation of get auth status use case
class GetAuthStatusUseCaseImpl implements GetAuthStatusUseCase {
  final AuthRepository _authRepository;

  GetAuthStatusUseCaseImpl(this._authRepository);

  @override
  Future<bool> execute() async {
    try {
      await _authRepository.getAccessTokenFromLocal();
      return true;
    } catch (e) {
      return false;
    }
  }
}