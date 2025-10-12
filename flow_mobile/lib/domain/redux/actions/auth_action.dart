class SetLoginEmailAction {
  final String email;

  SetLoginEmailAction({required this.email});
}

class SetLoginPasswordAction {
  final String password;

  SetLoginPasswordAction({required this.password});
}

class SetSignupPasswordAction {
  final String password;

  SetSignupPasswordAction({required this.password});
}

class SetSignupNameAction {
  final String name;

  SetSignupNameAction({required this.name});
}

class LoginSuccessAction {
  final String accessToken;
  final String refreshToken;

  LoginSuccessAction({required this.accessToken, required this.refreshToken});
}

class SignupSuccessAction {
  final String accessToken;
  final String refreshToken;
  final String name;
  final String email;

  SignupSuccessAction({
    required this.accessToken,
    required this.refreshToken,
    required this.name,
    required this.email,
  });
}

class SignupErrorAction {
  final String error;

  SignupErrorAction(this.error);
}

class LoginErrorAction {
  final String error;

  LoginErrorAction(this.error);
}

class LogoutAction {
  LogoutAction();
}

class EmailVerifiedAction {
  EmailVerifiedAction();
}