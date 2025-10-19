import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/domain/manager/transaction_manager.dart';
import 'package:flow_mobile/domain/redux/actions/transaction_action.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

ThunkAction<FlowState> setTransactionCategoryThunk(
  Transaction transaction,
  String category,
) {
  return (Store<FlowState> store) async {
    final originalCategory = transaction.category;
    final transactionManager = getIt<TransactionManager>();
    final future = transactionManager.setTransactionCategory(
      transaction,
      category,
    );
    store.dispatch(
      SetTransactionCategoryAction(
        transaction: transaction,
        category: category,
      ),
    );

    future
        .then((success) {
          if (!success) {
            // Revert the change if the API call failed
            store.dispatch(
              SetTransactionCategoryAction(
                transaction: transaction,
                category: originalCategory,
              ),
            );
          }
        })
        .catchError((error) {
          // Revert the change if there was an error
          store.dispatch(
            SetTransactionCategoryAction(
              transaction: transaction,
              category: originalCategory,
            ),
          );
        });
  };
}

ThunkAction<FlowState> toggleTransactionIncludeInSpendingOrIncomeThunk(
  Transaction transaction,
) {
  return (Store<FlowState> store) async {
    final transactionManager = getIt<TransactionManager>();
    final future = transactionManager
        .toggleTransactionIncludeInSpendingOrIncome(transaction);
    store.dispatch(
      ToggleTransactionIncludeInSpendingOrIncomeAction(
        transaction: transaction,
      ),
    );

    future
        .then((success) {
          if (!success) {
            // Revert the change if the API call failed
            store.dispatch(
              ToggleTransactionIncludeInSpendingOrIncomeAction(
                transaction: transaction,
              ),
            );
          }
        })
        .catchError((error) {
          // Revert the change if there was an error
          store.dispatch(
            ToggleTransactionIncludeInSpendingOrIncomeAction(
              transaction: transaction,
            ),
          );
        });
  };
}

ThunkAction<FlowState> fetchTransactionsIfNotOnLocalThunk(List<String> ids) {
  return (Store<FlowState> store) async {
    final transactionManager = getIt<TransactionManager>();
    List<String> idsToFetch = []; // IDs that are not on local
    List<Transaction> localTransactions =
        store.state.transactionState.transactions;
    for (String id in ids) {
      if (!localTransactions.any((t) => t.id.toString() == id)) {
        idsToFetch.add(id);
      }
    }

    if (idsToFetch.isNotEmpty) {
      List<Transaction> fetchedTransactions = await transactionManager
          .fetchTransactionsByIdsFromRemote(idsToFetch);
      store.dispatch(AddTransaction(fetchedTransactions));
    } else {
    }
  };
}
