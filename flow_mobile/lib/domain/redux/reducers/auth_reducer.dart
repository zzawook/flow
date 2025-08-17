import 'package:flow_mobile/domain/redux/actions/auth_action.dart';
import 'package:flow_mobile/domain/redux/states/auth_state.dart';

AuthState authReducer(AuthState state, dynamic action) {
  if (action is SetLoginEmailAction) {
    print(action.email);
    return state.copyWith(loginEmail: action.email);
  }
  if (action is SetLoginPasswordAction) {
    return state.copyWith(loginPassword: action.password);
  }
  if (action is LoginSuccessAction) {
    return state.copyWith(isAuthenticated: true);
  }
  if (action is LoginErrorAction) {
    return state.copyWith(isAuthenticated: false, loginError: action.error);
  }
  if (action is LogoutAction) {
    return AuthState.initial();
  }
  if (action is SetSignupPasswordAction) {
    return state.copyWith(signupPassword: action.password);
  }
  if (action is SetSignupNameAction) {
    return state.copyWith(signupName: action.name);
  }
  if (action is SignupSuccessAction) {
    return state.copyWith(
      isAuthenticated: true,
      loginEmail: action.email,
      signupName: action.name,
      signupPassword: null, // Clear password after successful signup
      loginError: null, // Clear any previous login error
    );
  }

  return state;
}
