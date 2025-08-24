import 'package:flow_mobile/domain/entity/bank.dart';
import 'package:flow_mobile/domain/redux/actions/refresh_screen_action.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/refresh_screen_state.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/presentation/link_bank_screen/link_bank_screen_argument.dart';
import 'package:flow_mobile/presentation/navigation/app_routes.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/service/api_service/api_service.dart';
import 'package:flow_mobile/service/navigation_service.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction<FlowState> openAddAccountScreenThunk() {
  return (Store<FlowState> store) {
    final apiService = getIt<ApiService>();
    final nav = getIt<NavigationService>();
    apiService.getBanksForLink().then((response) {
      final bankList =
          response.banks
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

    final authResultResponse = await apiService
        .getInstitutionAuthenticationResult(bankToLink);
    if (authResultResponse.success) {
      if (isLinkingThisBank(
        store.state.screenState.refreshScreenState,
        bankToLink,
        linkStartTimestamp,
      )) {
        nav.pushNamed(AppRoutes.linkSuccess);
        store.dispatch(BankLinkingSuccessAction(bank: bankToLink));
      }
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

bool isLinkingThisBank(
  RefreshScreenState state,
  Bank bank,
  String linkStartTimestamp,
) {
  return state.isLinking &&
      state.linkingBank?.bankId == bank.bankId &&
      state.linkStartTimestamp == linkStartTimestamp;
}
