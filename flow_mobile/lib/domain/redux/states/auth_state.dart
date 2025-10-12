class AuthState {
  final bool isAuthenticated;
  final bool isEmailVerified;
  
  final String? loginEmail;
  final String? loginPassword;
  final String? loginError;

  final String? signupName;
  final String? signupPassword;
  final String? signupEmail;
  final DateTime? signupDateOfBirth;

  AuthState({
    this.loginEmail,
    this.loginPassword,
    this.isAuthenticated = false,
    this.isEmailVerified = false,
    this.loginError,
    this.signupName,
    this.signupPassword,
    this.signupEmail,
    this.signupDateOfBirth,
  });

  AuthState copyWith({
    String? loginEmail,
    String? loginPassword,
    bool? isAuthenticated,
    bool? isEmailVerified,
    String? loginError,
    String? signupName,
    String? signupPassword,
    String? signupEmail,
    DateTime? signupDateOfBirth,
  }) {
    return AuthState(
      loginEmail: loginEmail ?? this.loginEmail,
      loginPassword: loginPassword ?? this.loginPassword,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      loginError: loginError ?? this.loginError,
      signupName: signupName ?? this.signupName,
      signupPassword: signupPassword ?? this.signupPassword,
      signupEmail: signupEmail ?? this.signupEmail,
      signupDateOfBirth: signupDateOfBirth ?? this.signupDateOfBirth,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  @override
  String toString() {
    return 'AuthState{loginEmail: $loginEmail, loginPassword: $loginPassword, isAuthenticated: $isAuthenticated, loginError: $loginError, signupName: $signupName, signupPassword: $signupPassword, signupEmail: $signupEmail, signupDateOfBirth: $signupDateOfBirth, isEmailVerified: $isEmailVerified}';
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
      signupDateOfBirth: null,
      isEmailVerified: false,
    );
  }
}
