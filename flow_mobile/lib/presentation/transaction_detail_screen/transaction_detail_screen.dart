import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/presentation/navigation/app_routes.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';
import 'package:flow_mobile/presentation/shared/flow_snackbar.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flow_mobile/service/navigation_service.dart';
import 'package:flow_mobile/utils/date_time_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class TransactionDetailScreen extends StatefulWidget {
  final Transaction transaction;
  const TransactionDetailScreen({super.key, required this.transaction});

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final transactionProcessedName = widget.transaction.name.length > 25
        ? "${widget.transaction.name.replaceAll("\n", " ").substring(0, 25)}..."
        : widget.transaction.name.replaceAll("\n", " ");

    final transactionAmountString = widget.transaction.amount < 0
        ? "-\$${widget.transaction.amount.abs().toStringAsFixed(2)}"
        : "+\$${widget.transaction.amount.abs().toStringAsFixed(2)}";

    return Scaffold(
      body: FlowSafeArea(
        backgroundColor: Theme.of(context).cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FlowTopBar(
              title: Center(
                child: Text(
                  "Transaction detail",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              showBackButton: true,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: Column(
                children: [
                  FlowSeparatorBox(height: 36),
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/transaction_icons/mcdonalds.png',
                        height: 36,
                        width: 36,
                      ),
                      FlowSeparatorBox(width: 8),
                      Text(
                        transactionProcessedName,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: Theme.of(
                                context,
                              ).textTheme.labelMedium?.color?.withAlpha(150),
                            ),
                      ),
                    ],
                  ),

                  FlowSeparatorBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        transactionAmountString,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      FlowButton(
                        onPressed: () {
                          final messenger = ScaffoldMessenger.of(context);
                          final snack = FlowSnackbar(
                            content: const Text(
                              "Copied to clipboard",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                                color: Colors.white,
                              ),
                            ),
                            duration: 2,
                          ).build(context);

                          // Now do the async, then show using the captured messenger
                          Clipboard.setData(
                            ClipboardData(text: transactionAmountString),
                          ).then((_) {
                            messenger.showSnackBar(snack);
                          });
                        },
                        child: Container(
                          width: 65,
                          height: 40,
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Theme.of(context).disabledColor,
                          ),
                          child: Center(
                            child: Text(
                              "Copy",
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.color
                                        ?.withAlpha(150),
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  FlowSeparatorBox(height: 48),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Description",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          transactionProcessedName,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color?.withAlpha(150),
                              ),
                        ),
                      ],
                    ),
                  ),

                  FlowSeparatorBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Date",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          DateTimeUtil.getFormattedDate(
                            widget.transaction.date,
                          ),
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color?.withAlpha(150),
                              ),
                        ),
                      ],
                    ),
                  ),

                  FlowSeparatorBox(height: 8),

                  FlowButton(
                    onPressed: () {
                      final navigator = getIt<NavigationService>();
                      navigator.pushNamed(
                        AppRoutes.categorySelection,
                        arguments: CustomPageRouteArguments(
                          transitionType: TransitionType.slideLeft,
                          extraData: widget.transaction,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Category",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          StoreConnector<FlowState, String>(
                            converter: (Store<FlowState> store) {
                              final transaction = store
                                  .state
                                  .transactionState
                                  .transactions
                                  .firstWhere(
                                    (t) => t.id == widget.transaction.id,
                                    orElse: () => widget.transaction,
                                  );
                              return transaction.category;
                            },
                            builder: (context, category) {
                              return Text(
                                category,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color
                                          ?.withAlpha(150),
                                    ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  FlowSeparatorBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Bank account",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          widget.transaction.bankAccount.accountName,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color?.withAlpha(150),
                              ),
                        ),
                      ],
                    ),
                  ),

                  FlowSeparatorBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Include in ${widget.transaction.amount > 0 ? "income" : "spending"}",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        CupertinoSwitch(
                          value:
                              widget.transaction.isIncludedInSpendingOrIncome,
                          onChanged: (value) {
                            // TODO: Update transaction inclusion
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
