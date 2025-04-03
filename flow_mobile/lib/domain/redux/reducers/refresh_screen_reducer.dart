import 'package:flow_mobile/domain/entities/bank.dart';
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
  return state;
}
