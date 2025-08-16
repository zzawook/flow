import 'package:flow_mobile/domain/repositories/auth_repository.dart';
import 'package:flow_mobile/data/datasources/local/auth_local_datasource.dart';
import 'package:flow_mobile/data/datasources/remote/auth_remote_datasource.dart';

/// Implementation of AuthRepository using data sources
/// Maintains identical behavior to AuthManagerImpl
class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource _localDataSource;
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({
    required AuthLocalDataSource localDataSource,
    required AuthRemoteDataSource remoteDataSource,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource;

  @override
  Future<void> deleteAccessTokenFromLocal() {
    return _localDataSource.deleteAccessTokenFromLocal();
  }

  @override
  Future<void> deleteRefreshTokenFromLocal() {
    return _localDataSource.deleteRefreshTokenFromLocal();
  }

  @override
  Future<void> getAccessTokenFromLocal() async {
    await _localDataSource.getAccessTokenFromLocal();
  }

  @override
  Future<void> getRefreshTokenFromLocal() async {
    await _localDataSource.getRefreshTokenFromLocal();
  }

  @override
  Future<void> saveAccessTokenToLocal(String accessToken) {
    return _localDataSource.saveAccessTokenToLocal(accessToken);
  }

  @override
  Future<void> saveRefreshTokenToLocal(String refreshToken) {
    return _localDataSource.saveRefreshTokenToLocal(refreshToken);
  }

  @override
  Future<void> getAndSaveAccessTokenFromRemote() async {
    final accessToken = await _remoteDataSource.getAccessTokenFromRemote();
    await _localDataSource.saveAccessTokenToLocal(accessToken);
  }

  @override
  Future<void> getAndSaveRefreshTokenFromRemote() async {
    final refreshToken = await _remoteDataSource.getRefreshTokenFromRemote();
    await _localDataSource.saveRefreshTokenToLocal(refreshToken);
  }

  @override
  Future<bool> attemptLogin() async {
    final accessToken = await _localDataSource.getAccessTokenFromLocal();
    final refreshToken = await _localDataSource.getRefreshTokenFromLocal();

    // Refactored to use switch statement (matching original implementation)
    switch ([accessToken != null, refreshToken != null]) {
      case [false, false]:
        return false;
      case [false, true]:
        try {
          await getAndSaveAccessTokenFromRemote();
          return true;
        } catch (e) {
          return false;
        }
      default:
        break;
    }

    return true;
  }
}