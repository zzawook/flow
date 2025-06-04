import 'package:flow_mobile/domain/manager/auth_manager.dart';
import 'package:flow_mobile/service/local_source/local_secure_storage.dart';

class AuthManagerImpl implements AuthManager {
  // Private static instance for the singleton
  static final AuthManagerImpl _instance = AuthManagerImpl._internal();

  // Instance of SecureStorage
  final SecureStorage _localSecureStorage;

  // Private named constructor to prevent external instantiation
  AuthManagerImpl._internal() : _localSecureStorage = SecureStorage();

  static Future<AuthManagerImpl> getInstance() async {
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
  Future<String?> getAccessTokenFromLocal() {
    return _localSecureStorage.getData('accessToken');
  }

  @override
  Future<bool> getAndSaveAccessTokenFromRemote() async {
    String accessToken = 'access_token';
    // DO API REQUEST TO GET ACCESS TOKEN FROM REMOTE
    await _localSecureStorage.saveData('accessToken', accessToken);
    return true;
  }

  @override
  Future<bool> getAndSaveRefreshTokenFromRemote() async {
    String refreshToken = 'refresh_token';
    // DO API REQUEST TO GET REFRESH TOKEN FROM REMOTE
    await _localSecureStorage.saveData('refreshToken', refreshToken);
    return true;
  }

  @override
  Future<String?> getRefreshTokenFromLocal() {
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

  @override
  Future<bool> attemptLogin() async {
    String? accessToken = await getAccessTokenFromLocal();
    String? refreshToken = await getRefreshTokenFromLocal();

    // Refactored to use switch statement
    switch ([accessToken != null, refreshToken != null]) {
      case [false, false]:
        return false;
      case [false, true]:
        bool success = await getAndSaveAccessTokenFromRemote();
        return success;
      default:
        break;
    }

    // return false;
    return true;
  }
}
