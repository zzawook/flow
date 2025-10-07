import 'package:flow_mobile/domain/entity/card.dart' as BankCard;
import 'package:flow_mobile/domain/manager/card_manager.dart';
import 'package:flow_mobile/domain/redux/actions/card_actions.dart';
import 'package:flow_mobile/domain/redux/actions/transaction_action.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/utils/debug_config.dart';
import 'package:flow_mobile/utils/test_data/card_test_data.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction<FlowState> getCardDetailThunk({
  required BankCard.Card card,
  String? oldestTransactionId,
  int limit = 20,
}) {
  return (Store<FlowState> store) async {
    final cardManager = getIt<CardManager>();

    List<BankCard.Card> cards = [];

    if (DebugConfig.isDebugMode) {
      switch (DebugConfig.cardTestMode) {
        case CardTestMode.none:
          await cardManager.fetchCardsFromRemote();
          cards = await cardManager.getCards();
          break;
        case CardTestMode.multipleItems:
          cards = CardTestData.getMultipleCards();
          break;
        case CardTestMode.singleItem:
          cards = CardTestData.getSingleCard();
          break;
        case CardTestMode.empty:
          cards = CardTestData.getNoCards();
          break;
        case CardTestMode.edgeCases:
          cards = CardTestData.getEdgeCases();
          break;
      }
    } else {
      await cardManager.fetchCardsFromRemote();
      cards = await cardManager.getCards();
    }

    await cardManager.fetchCardsFromRemote();

    store.dispatch(
      SetCardStateAction(store.state.cardState.copyWith(cards: cards)),
    );
    return;
  };
}

ThunkAction<FlowState> getCardTransactionsThunk({
  required BankCard.Card card,
  String? oldestTransactionId,
  int limit = 20,
}) {
  return (Store<FlowState> store) async {
    final cardManager = getIt<CardManager>();
    final transactionList = await cardManager.fetchTransactionForCardFromRemote(
      card,
      limit,
      oldestTransactionId: oldestTransactionId,
    );
    store.dispatch(AddTransaction(transactionList));
  };
}
