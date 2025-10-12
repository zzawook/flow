import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/spending_screen_state.dart';
import 'package:flow_mobile/domain/redux/states/transaction_state.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/presentation/navigation/app_routes.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';
import 'package:flow_mobile/service/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class UserCategoryClassificationCard extends StatelessWidget {
  const UserCategoryClassificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return FlowButton(
      onPressed: () {
        final navService = getIt<NavigationService>();
        navService.pushNamed(AppRoutes.categoryClassification);
      },
      child: StoreConnector<FlowState, UserCategoryClassificationCardState>(
        converter: (store) {
          return UserCategoryClassificationCardState(
            transactionState: store.state.transactionState,
            spendingScreenState: store.state.screenState.spendingScreenState,
          );
        },
        builder: (BuildContext context, UserCategoryClassificationCardState state) {
          final notIdentifiableTransactions = state.transactionState
              .getUncategorizedTransactions(
                DateTime(
                  state.spendingScreenState.displayedMonth.year,
                  state.spendingScreenState.displayedMonth.month,
                ),
              );

          final allTransactions = state.transactionState
              .getTransactionsForMonth(
                DateTime(
                  state.spendingScreenState.displayedMonth.year,
                  state.spendingScreenState.displayedMonth.month,
                ),
              );

          final notIdentifiableTransactionRate = allTransactions.isEmpty
              ? 0.0
              : (notIdentifiableTransactions.length / allTransactions.length) *
                    100;

          if (notIdentifiableTransactions.isEmpty) {
            return const SizedBox.shrink();
          }

          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(18),
            child: StoreConnector<FlowState, TransactionState>(
              converter: (store) {
                return store.state.transactionState;
              },
              builder: (BuildContext context, TransactionState transactionState) {
                return Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(
                          context,
                        ).primaryColor.withValues(alpha: 0.8),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Icon(Icons.category_rounded),
                    ),
                    FlowSeparatorBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${(100 - notIdentifiableTransactionRate).toStringAsFixed(0)}% transactions categorized',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Complete your spending report by categorizing ${notIdentifiableTransactions.length} transactions',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    FlowSeparatorBox(width: 8),
                    Icon(Icons.chevron_right_rounded),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class UserCategoryClassificationCardState {
  final TransactionState transactionState;
  final SpendingScreenState spendingScreenState;

  UserCategoryClassificationCardState({
    required this.transactionState,
    required this.spendingScreenState,
  });
}
