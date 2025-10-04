import 'package:flow_mobile/domain/entity/card.dart' as BankCard;
import 'package:flow_mobile/domain/manager/card_manager.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction<FlowState> getCardDetailThunk({
  required BankCard.Card card,
  String? oldestTransactionId,
  int limit = 20,
}) {
  return (Store<FlowState> store) async {
    final cardManager = getIt<CardManager>();
    await cardManager.fetchCardsFromRemote();
  };
}
