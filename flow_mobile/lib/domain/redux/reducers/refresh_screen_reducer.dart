import 'package:flow_mobile/domain/entity/bank.dart';
import 'package:flow_mobile/domain/redux/actions/refresh_screen_action.dart';
import 'package:flow_mobile/domain/redux/states/refresh_screen_state.dart';

RefreshScreenState refreshScreenReducer(
  RefreshScreenState state,
  dynamic action,
) {
  if (action is InitSelectedBankAction) {
    return state.copyWith(banksToRefresh: action.banks);
  }
  if (action is SelectBankAction) {
    List<Bank> banks = state.banksToRefresh;
    if (banks.contains(action.bank)) {
      banks.remove(action.bank);
    } else {
      banks.add(action.bank);
    }
    return state.copyWith(banksToRefresh: banks);
  }
  if (action is CancelLinkBankingScreenAction) {
    return state.copyWith(isLinking: false, linkingBank: null, linkStartTimestamp: null);
  }
  if (action is StartBankLinkingAction) {
    return state.copyWith(isLinking: true, linkingBank: action.bank, linkStartTimestamp: action.linkStartTimestamp);
  }
  if (action is BankLinkingSuccessAction) {
    List<Bank> banks = state.banksToRefresh;
    if (banks.contains(action.bank)) {
      banks.remove(action.bank);
    }
    return state.copyWith(banksToRefresh: banks, isLinking: false, linkingBank: null, linkStartTimestamp: null);
  }
  if (action is RemoveCurrentLinkingBankAction) {
    List<Bank> banks = state.banksToRefresh;
    banks.removeAt(0);
    return state.copyWith(banksToRefresh: banks, isLinking: false, linkingBank: null, linkStartTimestamp: null);
  }
  
  return state;
}
