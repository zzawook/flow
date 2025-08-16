import 'package:flow_mobile/service/local_source/local_secure_storage.dart';

/// Local data source interface for authentication operations
/// Abstracts secure storage operations
abstract class AuthLocalDataSource {
  /// Get access token from local secure storage
  Future<String?> getAccessTokenFromLocal();
  
  /// Get refresh token from local secure storage
  Future<String?> getRefreshTokenFromLocal();
  
  /// Save access token to local secure storage
  Future<void> saveAccessTokenToLocal(String accessToken);
  
  /// Save refresh token to local secure storage
  Future<void> saveRefreshTokenToLocal(String refreshToken);
  
  /// Delete access token from local secure storage
  Future<void> deleteAccessTokenFromLocal();
  
  /// Delete refresh token from local secure storage
  Future<void> deleteRefreshTokenFromLocal();
}

/// Implementation of AuthLocalDataSource using secure storage
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorage _secureStorage;

  AuthLocalDataSourceImpl({required SecureStorage secureStorage}) 
      : _secureStorage = secureStorage;

  @override
  Future<void> deleteAccessTokenFromLocal() {
    return _secureStorage.deleteData('accessToken');
  }

  @override
  Future<void> deleteRefreshTokenFromLocal() {
    return _secureStorage.deleteData('refreshToken');
  }

  @override
  Future<String?> getAccessTokenFromLocal() {
    return _secureStorage.getData('accessToken');
  }

  @override
  Future<String?> getRefreshTokenFromLocal() {
    return _secureStorage.getData('refreshToken');
  }

  @override
  Future<void> saveAccessTokenToLocal(String accessToken) {
    return _secureStorage.saveData('accessToken', accessToken);
  }

  @override
  Future<void> saveRefreshTokenToLocal(String refreshToken) {
    return _secureStorage.saveData('refreshToken', refreshToken);
  }
}