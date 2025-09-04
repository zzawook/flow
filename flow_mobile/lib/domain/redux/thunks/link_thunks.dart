import 'package:flow_mobile/domain/entity/bank.dart';
import 'package:flow_mobile/domain/manager/bank_account_manager.dart';
import 'package:flow_mobile/domain/manager/bank_manager.dart';
import 'package:flow_mobile/domain/manager/transaction_manager.dart';
import 'package:flow_mobile/domain/redux/actions/bank_account_action.dart';
import 'package:flow_mobile/domain/redux/actions/refresh_screen_action.dart';
import 'package:flow_mobile/domain/redux/actions/transaction_action.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/refresh_screen_state.dart';
import 'package:flow_mobile/initialization/flow_state_initializer.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/presentation/link_bank_screen/link_bank_screen_argument.dart';
import 'package:flow_mobile/presentation/navigation/app_routes.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/refresh_screen/refresh_bank_screen_argument.dart';
import 'package:flow_mobile/service/api_service/api_service.dart';
import 'package:flow_mobile/service/navigation_service.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction<FlowState> openAddAccountScreenThunk() {
  return (Store<FlowState> store) {
    final apiService = getIt<ApiService>();
    final nav = getIt<NavigationService>();
    apiService.getBanksForLink().then((response) {
      final bankList = response.banks
          .map((bank) => Bank(name: bank.name, bankId: bank.id))
          .toList();
      nav.pushNamed(
        AppRoutes.addAccount,
        arguments: CustomPageRouteArguments(
          transitionType: TransitionType.slideLeft,
          extraData: bankList,
        ),
      );
    });
  };
}

ThunkAction<FlowState> skipFirstAndLinkBankThunk() {
  return (Store<FlowState> store) {
    store.dispatch(RemoveCurrentLinkingBankAction());
    store.dispatch(linkBankThunk());
  };
}

ThunkAction<FlowState> linkBankThunk() {
  return (Store<FlowState> store) async {
    final nav = getIt<NavigationService>();

    if (store.state.screenState.refreshScreenState.banksToRefresh.isEmpty) {
      nav.pushNamed(AppRoutes.allLinkSuccess);
      return;
    }

    final bankToLink =
        store.state.screenState.refreshScreenState.banksToRefresh.first;
    final apiService = getIt<ApiService>();

    final linkUrlResponse = await apiService.getLinkUrl(bankToLink);

    final linkStartTimestamp = DateTime.now().toIso8601String();
    store.dispatch(
      StartBankLinkingAction(
        bank: bankToLink,
        linkStartTimestamp: linkStartTimestamp,
      ),
    );

    nav.pushNamed(
      AppRoutes.linkBank,
      arguments: CustomPageRouteArguments(
        transitionType: TransitionType.slideLeft,
        extraData: LinkBankScreenArgument(
          bank: bankToLink,
          linkUrl: linkUrlResponse.relinkUrl,
        ),
      ),
    );

    store.dispatch(
      monitorBankLinkThunk(bankToLink, linkStartTimestamp),
    ); // DISPATCHING THE MONITOR THUNK TO USE UPDATED STATE
  };
}

ThunkAction<FlowState> refreshBankThunk() {
  return (Store<FlowState> store) async {
    final nav = getIt<NavigationService>();

    if (store.state.screenState.refreshScreenState.banksToRefresh.isEmpty) {
      nav.pushNamed(AppRoutes.allRefreshSuccess);
      return;
    }

    final bankToLink =
        store.state.screenState.refreshScreenState.banksToRefresh.first;
    final apiService = getIt<ApiService>();

    final refreshUrlResponse = await apiService.getRefreshUrl(bankToLink);

    final linkStartTimestamp = DateTime.now().toIso8601String();
    store.dispatch(
      StartBankLinkingAction(
        bank: bankToLink,
        linkStartTimestamp: linkStartTimestamp,
      ),
    );

    nav.pushNamed(
      AppRoutes.refreshBank,
      arguments: CustomPageRouteArguments(
        transitionType: TransitionType.slideLeft,
        extraData: RefreshBankScreenArgument(
          bank: bankToLink,
          url: refreshUrlResponse.refreshUrl,
        ),
      ),
    );

    store.dispatch(
      monitorBankRefreshThunk(bankToLink, linkStartTimestamp),
    ); // DISPATCHING THE MONITOR THUNK TO USE UPDATED STATE
  };
}

ThunkAction<FlowState> monitorBankRefreshThunk(
  Bank bankToRefresh,
  String refreshStartTimestamp,
) {
  return (Store<FlowState> store) async {
    final apiService = getIt<ApiService>();
    final nav = getIt<NavigationService>();
    final authResultResponse = await apiService
        .getInstitutionAuthenticationResult(bankToRefresh);
    if (authResultResponse.success) {
      if (isLinkingThisBank(
        store.state.screenState.refreshScreenState,
        bankToRefresh,
        refreshStartTimestamp,
      )) {
        store.dispatch(BankLinkingSuccessAction(bank: bankToRefresh));
        nav.pushNamed(
          AppRoutes.refreshSuccess,
          arguments: CustomPageRouteArguments(
            transitionType: TransitionType.slideLeft,
            extraData: bankToRefresh,
          ),
        );
        store.dispatch(monitorBankDataFetchThunk(bankToRefresh));
      }
    } else {
      if (isLinkingThisBank(
        store.state.screenState.refreshScreenState,
        bankToRefresh,
        refreshStartTimestamp,
      )) {
        nav.pushNamed(AppRoutes.refreshFailed);
        // NOT DISPATCHING HERE, USER WILL DECIDE TO RETRY OR SKIP
      }
    }
  };
}

ThunkAction<FlowState> monitorBankLinkThunk(
  Bank bankToLink,
  String linkStartTimestamp,
) {
  return (Store<FlowState> store) async {
    final apiService = getIt<ApiService>();
    final nav = getIt<NavigationService>();
    final authResultResponse = await apiService
        .getInstitutionAuthenticationResult(bankToLink);
    if (authResultResponse.success) {
      if (isLinkingThisBank(
        store.state.screenState.refreshScreenState,
        bankToLink,
        linkStartTimestamp,
      )) {
        store.dispatch(BankLinkingSuccessAction(bank: bankToLink));
        nav.pushNamed(
          AppRoutes.linkSuccess,
          arguments: CustomPageRouteArguments(
            transitionType: TransitionType.slideLeft,
            extraData: bankToLink,
          ),
        );
      }
      store.dispatch(monitorBankDataFetchThunk(bankToLink));
    } else {
      if (isLinkingThisBank(
        store.state.screenState.refreshScreenState,
        bankToLink,
        linkStartTimestamp,
      )) {
        nav.pushNamed(AppRoutes.linkFailed);
        // NOT DISPATCHING HERE, USER WILL DECIDE TO RETRY OR SKIP
      }
    }
  };
}

ThunkAction<FlowState> monitorBankDataFetchThunk(Bank bank) {
  return (Store<FlowState> store) async {
    store.dispatch(StartBankDataFetchMonitoringAction(bank: bank));
    final apiService = getIt<ApiService>();
    final dataFetchResultResponse = await apiService.getDataRetrievalResult(
      bank,
    );
    _updateStateForBankDataCompletion(store);
    if (dataFetchResultResponse.success) {
      store.dispatch(FinishBankDataFetchMonitoringAction(bank: bank));
    } else {
      store.dispatch(FinishBankDataFetchMonitoringAction(bank: bank));
    }
  };
}

Future<void> _updateStateForBankDataCompletion(Store<FlowState> store) async {
  BankAccountManager bankAccountManager = getIt<BankAccountManager>();
  BankManager bankManager = getIt<BankManager>();
  TransactionManager transactionManager = getIt<TransactionManager>();

  bankAccountManager.clearBankAccounts();
  bankManager.clearBanks();
  transactionManager.clearTransactions();

  final bankFuture = bankManager.fetchBanksFromRemote();
  final bankAccountFuture = bankAccountManager.fetchBankAccountsFromRemote();
  final transactionFuture = transactionManager
      .fetchLastYearTransactionsFromRemote();

  final fetchResults = Future.wait([
    bankFuture,
    bankAccountFuture,
    transactionFuture,
  ]);

  fetchResults.then((_) async {
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
  });
}

bool isLinkingThisBank(
  RefreshScreenState state,
  Bank bank,
  String linkStartTimestamp,
) {
  return state.isLinking &&
      state.linkingBank?.bankId == bank.bankId &&
      state.linkStartTimestamp == linkStartTimestamp;
}
