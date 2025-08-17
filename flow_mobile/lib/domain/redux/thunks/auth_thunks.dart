import 'dart:developer';

import 'package:flow_mobile/domain/manager/auth_manager.dart';
import 'package:flow_mobile/domain/manager/bank_account_manager.dart';
import 'package:flow_mobile/domain/manager/bank_manager.dart';
import 'package:flow_mobile/domain/manager/notification_manager.dart';
import 'package:flow_mobile/domain/manager/transaction_manager.dart';
import 'package:flow_mobile/domain/manager/user_manager.dart';
import 'package:flow_mobile/domain/redux/actions/auth_action.dart';
import 'package:flow_mobile/domain/redux/actions/screen_actions.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/presentation/navigation/app_routes.dart';
import 'package:flow_mobile/service/api_service/api_service.dart';
import 'package:flow_mobile/service/navigation_service.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction<FlowState> setELoginEmailThunk(String email) {
  final ApiService apiService = getIt<ApiService>();
  final nav = getIt<NavigationService>();
  return (Store<FlowState> store) async {
    try {
      final hasUserWithEmail = await apiService.checkUserExists(email);
      store.dispatch(SetLoginEmailAction(email: email));
      if (hasUserWithEmail.exists) {
        nav.pushNamed(AppRoutes.loginPassword);
      } else {
        nav.pushNamed(AppRoutes.signupPassword);
      }
    } catch (error) {
      log('Error setting login email: $error');
    }
  };
}

ThunkAction<FlowState> loginThunk(String email, String password) {
  ApiService apiService = getIt<ApiService>();
  AuthManager authManager = getIt<AuthManager>();
  return (Store<FlowState> store) async {
    try {
      final tokenSet = await apiService.signin(email, password);
      authManager.saveAccessTokenToLocal(tokenSet.accessToken);
      authManager.saveRefreshTokenToLocal(tokenSet.refreshToken);
      _initStateForLoggedInUser();
      store.dispatch(
        LoginSuccessAction(
          accessToken: tokenSet.accessToken,
          refreshToken: tokenSet.refreshToken,
        ),
      );
      store.dispatch(NavigateToScreenAction(AppRoutes.home));
    } catch (error) {
      store.dispatch(LoginErrorAction(error.toString()));
    }
  };
}

void _initStateForLoggedInUser() {
  BankAccountManager bankAccountManager = getIt<BankAccountManager>();
  BankManager bankManager = getIt<BankManager>();
  NotificationManager notificationManager = getIt<NotificationManager>();
  TransactionManager transactionManager = getIt<TransactionManager>();
  UserManager userManager = getIt<UserManager>();

  userManager.fetchUserFromRemote();
  bankManager.fetchBanksFromRemote();
  bankAccountManager.fetchBankAccountsFromRemote();
  transactionManager.fetchLast30DaysTransactionsFromRemote();
  notificationManager.fetchNotificationsFromRemote();
}

ThunkAction<FlowState> signupThunk(String email, String password, String name) {
  ApiService apiService = getIt<ApiService>();
  AuthManager authManager = getIt<AuthManager>();
  final nav = getIt<NavigationService>();
  return (Store<FlowState> store) async {
    try {
      final tokenSet = await apiService.signup(email, password, name);
      authManager.saveAccessTokenToLocal(tokenSet.accessToken);
      authManager.saveRefreshTokenToLocal(tokenSet.refreshToken);
      store.dispatch(
        SignupSuccessAction(
          accessToken: tokenSet.accessToken,
          refreshToken: tokenSet.refreshToken,
          name: name,
          email: email,
        ),
      );
      nav.pushNamed(AppRoutes.home);
    } catch (error) {
      store.dispatch(SignupErrorAction(error.toString()));
    }
  };
}

ThunkAction<FlowState> logoutThunk() {
  AuthManager authManager = getIt<AuthManager>();
  ApiService apiService = getIt<ApiService>();
  return (Store<FlowState> store) async {
    try {
      final response = await apiService.signout();
      if (!response.success) {
        throw Exception('Logout failed');
      }
    } catch (error) {
      log('Logout error: $error');
    }
    // ALWAYS clear tokens after logout
    authManager.deleteAccessTokenFromLocal();
    authManager.deleteRefreshTokenFromLocal();
    store.dispatch(LogoutAction());
    store.dispatch(NavigateToScreenAction(AppRoutes.login));
  };
}
