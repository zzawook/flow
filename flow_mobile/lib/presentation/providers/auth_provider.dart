import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow_mobile/domain/usecases/usecases.dart';
import 'package:flow_mobile/core/providers/providers.dart';

/// StateNotifier for Authentication state management
class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetAuthStatusUseCase _getAuthStatusUseCase;
  final RefreshTokenUseCase _refreshTokenUseCase;

  AuthNotifier(
    this._loginUseCase,
    this._logoutUseCase,
    this._getAuthStatusUseCase,
    this._refreshTokenUseCase,
  ) : super(const AuthState.initial());

  /// Check authentication status
  Future<void> checkAuthStatus() async {
    state = const AuthState.loading();
    try {
      final isAuthenticated = await _getAuthStatusUseCase.execute();
      if (isAuthenticated) {
        state = const AuthState.authenticated();
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Login user (attempt login with stored credentials)
  Future<void> login() async {
    state = const AuthState.loading();
    try {
      final success = await _loginUseCase.execute();
      if (success) {
        state = const AuthState.authenticated();
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Logout user
  Future<void> logout() async {
    state = const AuthState.loading();
    try {
      await _logoutUseCase.execute();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Refresh authentication token
  Future<void> refreshToken() async {
    try {
      await _refreshTokenUseCase.execute();
      // Token refreshed successfully, maintain authenticated state
      if (state != const AuthState.authenticated()) {
        state = const AuthState.authenticated();
      }
    } catch (e) {
      // Token refresh failed, user needs to login again
      state = const AuthState.unauthenticated();
    }
  }

  /// Clear error state
  void clearError() {
    if (state is AuthError) {
      state = const AuthState.unauthenticated();
    }
  }

  /// Attempt automatic login (equivalent to authManager.attemptLogin())
  /// This method tries to login with stored credentials
  Future<void> attemptLogin() async {
    try {
      await login();
    } catch (e) {
      // If anything fails, user remains unauthenticated
      state = const AuthState.unauthenticated();
    }
  }
}

/// Auth state sealed class
sealed class AuthState {
  const AuthState();

  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated() = AuthAuthenticated;
  const factory AuthState.unauthenticated() = AuthUnauthenticated;
  const factory AuthState.error(String message) = AuthError;
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
}

/// Provider for AuthNotifier
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.read(loginUseCaseProvider),
    ref.read(logoutUseCaseProvider),
    ref.read(getAuthStatusUseCaseProvider),
    ref.read(refreshTokenUseCaseProvider),
  );
});

/// Convenience provider for accessing auth state
final authStateProvider = Provider<AuthState>((ref) {
  return ref.watch(authNotifierProvider);
});

/// Convenience provider for checking if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState is AuthAuthenticated;
});

/// Convenience provider for checking if auth is loading
final isAuthLoadingProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState is AuthLoading;
});

/// Convenience provider for getting auth error
final authErrorProvider = Provider<String?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState is AuthError ? authState.message : null;
});