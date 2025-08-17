import 'package:flow_mobile/generated/auth/v1/auth.pbgrpc.dart';
import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_connection_interface.dart';

class AuthApiService {
  final AuthServiceClient client;

  AuthApiService(ClientChannel channel) : client = AuthServiceClient(channel);

  Future<TokenSet> login(String email, String password) async {
    final request = SignInRequest(email: email, password: password);

    try {
      final response = await client.signIn(request);
      return response;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<TokenSet> signup(String email, String password, String name) async {
    final request = SignUpRequest(email: email, password: password, name: name);

    try {
      final response = await client.signUp(request);
      return response;
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }

  Future<SignOutResponse> signout() async {
    final request = SignOutRequest();

    try {
      final response = await client.signOut(request);
      return response;
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  Future<TokenSet> refreshAccessToken(String refreshToken) async {
    final request = AccessTokenRefreshRequest(refreshToken: refreshToken);

    try {
      final response = await client.getAccessTokenByRefreshToken(request);
      return response;
    } catch (e) {
      throw Exception('Refresh token failed: $e');
    }
  }

  Future<CheckUserExistsResponse> checkUserExists(String email) async {
    final request = CheckUserExistsRequest(email: email);

    try {
      final response = await client.checkUserExists(request);
      return response;
    } catch (e) {
      throw Exception('Check user exists failed: $e');
    }
  }
}
