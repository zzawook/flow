import 'dart:developer';

import 'package:flow_mobile/domain/manager/auth_manager.dart';
import 'package:flow_mobile/domain/manager/bank_account_manager.dart';
import 'package:flow_mobile/domain/manager/bank_manager.dart';
import 'package:flow_mobile/domain/manager/notification_manager.dart';
import 'package:flow_mobile/domain/manager/transaction_manager.dart';
import 'package:flow_mobile/domain/manager/user_manager.dart';
import 'package:flow_mobile/domain/redux/actions/auth_action.dart';
import 'package:flow_mobile/domain/redux/actions/bank_account_action.dart';
import 'package:flow_mobile/domain/redux/actions/notification_action.dart';
import 'package:flow_mobile/domain/redux/actions/transaction_action.dart';
import 'package:flow_mobile/domain/redux/actions/user_actions.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/generated/auth/v1/auth.pb.dart';
import 'package:flow_mobile/initialization/flow_state_initializer.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/presentation/navigation/app_routes.dart';
import 'package:flow_mobile/service/api_service/api_service.dart';
import 'package:flow_mobile/service/api_service/grpc_interceptor.dart';
import 'package:flow_mobile/service/navigation_service.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction<FlowState> setLoginEmailThunk(String email) {
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

ThunkAction<FlowState> loginThunk(
  String email,
  String password,
  Function onFailure,
) {
  ApiService apiService = getIt<ApiService>();
  AuthManager authManager = getIt<AuthManager>();
  final nav = getIt<NavigationService>();
  return (Store<FlowState> store) async {
    TokenSet tokenSet;
    try {
      tokenSet = await apiService.signin(email, password);
    } catch (error) {
      store.dispatch(LoginErrorAction(error.toString()));
      onFailure();
      return;
    }
    authManager.saveAccessTokenToLocal(tokenSet.accessToken);
    authManager.saveRefreshTokenToLocal(tokenSet.refreshToken);
    GrpcInterceptor.setAccessToken(tokenSet.accessToken);
    await _initStateForLoggedInUser(store);
    store.dispatch(
      LoginSuccessAction(
        accessToken: tokenSet.accessToken,
        refreshToken: tokenSet.refreshToken,
      ),
    );
    nav.pushNamed(AppRoutes.home);
  };
}

Future<void> _initStateForLoggedInUser(Store<FlowState> store) async {
  BankAccountManager bankAccountManager = getIt<BankAccountManager>();
  BankManager bankManager = getIt<BankManager>();
  NotificationManager notificationManager = getIt<NotificationManager>();
  TransactionManager transactionManager = getIt<TransactionManager>();
  UserManager userManager = getIt<UserManager>();

  bankManager.clearBanks();
  bankAccountManager.clearBankAccounts();
  transactionManager.clearTransactions();

  final userFuture = userManager.fetchUserFromRemote();
  final bankFuture = bankManager.fetchBanksFromRemote();
  final bankAccountFuture = bankAccountManager.fetchBankAccountsFromRemote();
  final transactionFuture = transactionManager
      .fetchLastYearTransactionsFromRemote();
  final notificationFuture = notificationManager.fetchNotificationsFromRemote();

  final fetchResults = Future.wait([
    userFuture,
    bankFuture,
    bankAccountFuture,
    transactionFuture,
    notificationFuture,
  ]);

  fetchResults.then((_) async {
    store.dispatch(
      SetUserStateAction(userState: await FlowStateInitializer.getUserState()),
    );
    store.dispatch(
      SetBankAccountStateAction(
        bankAccountState: await FlowStateInitializer.getBankAccountState(),
      ),
    );
    store.dispatch(
      SetTransactionStateAction(
        transactionHistoryState:
            await FlowStateInitializer.getTransactionState(),
      ),
    );
    store.dispatch(
      SetNotificationStateAction(
        notificationState: await FlowStateInitializer.getNotificationState(),
      ),
    );
  });
}

Future<void> _clearState(Store<FlowState> store) async {
  store.dispatch(ClearUserStateAction());
  store.dispatch(ClearBankAccountStateAction());
  store.dispatch(ClearTransactionStateAction());
  store.dispatch(ClearNotificationStateAction());
}

ThunkAction<FlowState> signupThunk(
  String email,
  String password,
  String name,
  DateTime dateOfBirth,
) {
  ApiService apiService = getIt<ApiService>();
  AuthManager authManager = getIt<AuthManager>();
  final nav = getIt<NavigationService>();
  return (Store<FlowState> store) async {
    try {
      final tokenSet = await apiService.signup(
        email,
        password,
        name,
        dateOfBirth,
      );
      authManager.saveAccessTokenToLocal(tokenSet.accessToken);
      authManager.saveRefreshTokenToLocal(tokenSet.refreshToken);
      GrpcInterceptor.setAccessToken(tokenSet.accessToken);
      store.dispatch(
        SignupSuccessAction(
          accessToken: tokenSet.accessToken,
          refreshToken: tokenSet.refreshToken,
          name: name,
          email: email,
        ),
      );
      _clearState(store);
      store.dispatch(sendVerificationEmailThunk());
      nav.pushNamed(AppRoutes.emailVerification);
    } catch (error) {
      store.dispatch(SignupErrorAction(error.toString()));
    }
  };
}

ThunkAction<FlowState> logoutThunk() {
  AuthManager authManager = getIt<AuthManager>();
  ApiService apiService = getIt<ApiService>();
  final nav = getIt<NavigationService>();

  return (Store<FlowState> store) async {
    try {
      // best effort basis
      await apiService.signout();
    } catch (error) {
      log('Logout error: $error');
    }
    await _clearState(store);
    // ALWAYS clear tokens after logout
    GrpcInterceptor.setAccessToken("");
    authManager.deleteAccessTokenFromLocal();
    authManager.deleteRefreshTokenFromLocal();
    store.dispatch(LogoutAction());
    nav.pushNamedAndRemoveUntil(AppRoutes.welcome);
  };
}

ThunkAction<FlowState> sendVerificationEmailThunk() {
  ApiService apiService = getIt<ApiService>();
  return (Store<FlowState> store) async {
    try {
      final emailSendResult = await apiService.sendVerificationEmail(
        store.state.authState.loginEmail,
      );
      if (emailSendResult) {
        store.dispatch(checkEmailVerifiedThunk());
      }
    } catch (error) {
      log('Error sending verification email: $error');
    }
  };
}

ThunkAction<FlowState> checkEmailVerifiedThunk() {
  print("Checking email verification");
  ApiService apiService = getIt<ApiService>();
  final nav = getIt<NavigationService>();
  return (Store<FlowState> store) async {
    try {
      final emailVerifyResult = await apiService.checkEmailVerified(
        store.state.authState.loginEmail ?? '',
      );
      if (emailVerifyResult.verified) {
        nav.pushNamedAndRemoveUntil(AppRoutes.home);
      }
    } catch (error) {
      log('Error sending verification email: $error');
    }
  };
}
