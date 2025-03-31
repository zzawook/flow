import 'package:flow_mobile/data/repository/auth_repository.dart';
import 'package:flow_mobile/data/source/local_secure_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  // Private static instance for the singleton
  static final AuthRepositoryImpl _instance = AuthRepositoryImpl._internal();

  // Instance of SecureStorage
  final SecureStorage _localSecureStorage;

  // Private named constructor to prevent external instantiation
  AuthRepositoryImpl._internal() : _localSecureStorage = SecureStorage();

  static Future<AuthRepositoryImpl> getInstance() async {
    return _instance;
  }

  @override
  Future<void> deleteAccessTokenFromLocal() {
    return _localSecureStorage.deleteData('accessToken');
  }

  @override
  Future<void> deleteRefreshTokenFromLocal() {
    return _localSecureStorage.deleteData('refreshToken');
  }

  @override
  Future<void> getAccessTokenFromLocal() {
    return _localSecureStorage.getData('accessToken');
  }

  @override
  Future<void> getAndSaveAccessTokenFromRemote() {
    String accessToken = 'access_token';
    // DO API REQUEST TO GET ACCESS TOKEN FROM REMOTE
    return _localSecureStorage.saveData('accessToken', accessToken);
  }

  @override
  Future<void> getAndSaveRefreshTokenFromRemote() {
    String refreshToken = 'refresh_token';
    // DO API REQUEST TO GET REFRESH TOKEN FROM REMOTE
    return _localSecureStorage.saveData('refreshToken', refreshToken);
  }

  @override
  Future<void> getRefreshTokenFromLocal() {
    return _localSecureStorage.getData('refreshToken');
  }

  @override
  Future<void> saveAccessTokenToLocal(String accessToken) {
    return _localSecureStorage.saveData('accessToken', accessToken);
  }

  @override
  Future<void> saveRefreshTokenToLocal(String refreshToken) {
    return _localSecureStorage.saveData('refreshToken', refreshToken);
  }
}
