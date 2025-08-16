/// Repository interface for authentication operations
/// Matches existing AuthManager method signatures for compatibility
abstract class AuthRepository {
  /// Get access token from local storage
  Future<void> getAccessTokenFromLocal();
  
  /// Get refresh token from local storage
  Future<void> getRefreshTokenFromLocal();
  
  /// Save access token to local storage
  Future<void> saveAccessTokenToLocal(String accessToken);
  
  /// Save refresh token to local storage
  Future<void> saveRefreshTokenToLocal(String refreshToken);
  
  /// Delete access token from local storage
  Future<void> deleteAccessTokenFromLocal();
  
  /// Delete refresh token from local storage
  Future<void> deleteRefreshTokenFromLocal();

  /// Get and save access token from remote server
  Future<void> getAndSaveAccessTokenFromRemote();
  
  /// Get and save refresh token from remote server
  Future<void> getAndSaveRefreshTokenFromRemote();

  /// Attempt login with stored credentials
  Future<bool> attemptLogin();
}