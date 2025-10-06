import 'package:flow_mobile/domain/manager/auth_manager.dart';
import 'package:flow_mobile/generated/auth/v1/auth.pb.dart';
import 'package:flow_mobile/initialization/manager_registry.dart';
import 'package:flow_mobile/service/api_service/api_service.dart';
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
    return _localSecureStorage.getData('accessToken').then((value) {
      return value;
    });
  }

  @override
  Future<String?> getAndSaveAccessTokenFromRemote(String refreshToken) async {
    String accessToken = 'access_token';
    final apiService = getIt<ApiService>();
    TokenSet tokenSet;
    try {
      tokenSet = await apiService.refreshAccessToken(refreshToken);
    } catch (e) {
      return null;
    }

    if (tokenSet.accessToken.isEmpty || tokenSet.refreshToken.isEmpty) {
      return null;
    }

    saveAccessTokenToLocal(tokenSet.accessToken);
    saveRefreshTokenToLocal(tokenSet.refreshToken);

    await _localSecureStorage.saveData('accessToken', accessToken);
    return accessToken;
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
  Future<bool> attemptTokenValidation() async {
    String? accessToken = await getAccessTokenFromLocal();
    String? refreshToken = await getRefreshTokenFromLocal();

    // Refactored to use switch statement
    switch ([accessToken != null, refreshToken != null]) {
      case [false, false]:
        return false;
      case [true, false]:
        return false;
      case [false, true]:
        String? accessToken = await getAndSaveAccessTokenFromRemote(refreshToken!);
        return accessToken != null;
      default:
        break;
    }

    // return false;
    return true;
  }
}
