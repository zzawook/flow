abstract class AuthManager {
  Future<String?> getAccessTokenFromLocal();
  Future<String?> getRefreshTokenFromLocal();
  Future<void> saveAccessTokenToLocal(String accessToken);
  Future<void> saveRefreshTokenToLocal(String refreshToken);
  Future<void> deleteAccessTokenFromLocal();
  Future<void> deleteRefreshTokenFromLocal();

  Future<String?> getAndSaveAccessTokenFromRemote(String refreshToken);
  Future<void> getAndSaveRefreshTokenFromRemote();

  Future<bool> attemptTokenValidation();

  Future<bool> isEmailVerified(String email);
}
