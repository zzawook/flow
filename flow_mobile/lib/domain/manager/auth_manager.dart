abstract class AuthManager {
  Future<void> getAccessTokenFromLocal();
  Future<void> getRefreshTokenFromLocal();
  Future<void> saveAccessTokenToLocal(String accessToken);
  Future<void> saveRefreshTokenToLocal(String refreshToken);
  Future<void> deleteAccessTokenFromLocal();
  Future<void> deleteRefreshTokenFromLocal();

  Future<void> getAndSaveAccessTokenFromRemote();
  Future<void> getAndSaveRefreshTokenFromRemote();

  Future<bool> attemptLogin();
}
