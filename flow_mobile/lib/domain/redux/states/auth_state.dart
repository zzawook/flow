class AuthState {
  final String? loginEmail;
  final String? loginPassword;
  final bool isAuthenticated;
  final String? loginError;

  final String? signupName;
  final String? signupPassword;
  final String? signupEmail;

  AuthState({
    this.loginEmail,
    this.loginPassword,
    this.isAuthenticated = false,
    this.loginError,
    this.signupName,
    this.signupPassword,
    this.signupEmail,
  });

  AuthState copyWith({
    String? loginEmail,
    String? loginPassword,
    bool? isAuthenticated,
    String? loginError,
    String? signupName,
    String? signupPassword,
    String? signupEmail,
  }) {
    return AuthState(
      loginEmail: loginEmail ?? this.loginEmail,
      loginPassword: loginPassword ?? this.loginPassword,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      loginError: loginError ?? this.loginError,
      signupName: signupName ?? this.signupName,
      signupPassword: signupPassword ?? this.signupPassword,
      signupEmail: signupEmail ?? this.signupEmail,
    );
  }

  @override
  String toString() {
    return 'AuthState{loginEmail: $loginEmail, loginPassword: $loginPassword, isAuthenticated: $isAuthenticated, loginError: $loginError, signupName: $signupName, signupPassword: $signupPassword, signupEmail: $signupEmail}';
  }

  factory AuthState.initial() {
    return AuthState(
      loginEmail: null,
      loginPassword: null,
      isAuthenticated: false,
      loginError: null,
      signupName: null,
      signupPassword: null,
      signupEmail: null,
    );
  }
}
