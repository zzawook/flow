import 'package:flow_mobile/domain/entity/recurring_spending.dart';
import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/initialization/manager_registry.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flow_mobile/presentation/spending_calendar_screen/transaction_list.dart';
import 'package:flow_mobile/service/logo_service.dart';
import 'package:flow_mobile/utils/date_time_util.dart';
import 'package:flow_mobile/utils/spending_category_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class RecurringSpendingDetailScreen extends StatefulWidget {
  final RecurringSpending recurringSpending;

  const RecurringSpendingDetailScreen({
    super.key,
    required this.recurringSpending,
  });

  @override
  State<RecurringSpendingDetailScreen> createState() =>
      _RecurringSpendingDetailScreenState();
}

class _RecurringSpendingDetailScreenState
    extends State<RecurringSpendingDetailScreen> {
  String? networkLogoUrl;
  bool _tryNetwork = false; // whether to attempt network logo
  bool _networkFailed = false; // once true, never try again

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    _loadLogo();
  }

  void _loadTransactions() {
    // nothing to do here; transactions are loaded in SpendingScreen
  }

  void _loadLogo() {
    // base asset is decided in build() by theme; nothing to do here
    if (widget.recurringSpending.brandDomain == null ||
        widget.recurringSpending.brandDomain!.isEmpty) {
      return;
    }

    final logoService = getIt<LogoService>();
    final fetched = logoService.getLogoUrl(
      widget.recurringSpending.brandDomain!,
    );
    if (fetched.isNotEmpty) {
      setState(() {
        networkLogoUrl = fetched;
        _tryNetwork = true;
      });
    }
  }

  String _formatIntervalDays(int days) {
    if (days < 1) return "N/A";
    if (days == 1) return "Daily";
    if (days == 7) return "Weekly";
    if (days >= 28 && days <= 31) return "Monthly";
    if (days >= 84 && days <= 93) return "Quarterly";
    if (days >= 168 && days <= 186) return "Biannually";
    if (days == 365) return "Yearly";
    return "$days days";
  }

  @override
  Widget build(BuildContext context) {
    final recurringSpendingProcessedName =
        widget.recurringSpending.displayName.isEmpty
        ? "No description"
        : widget.recurringSpending.displayName;
    final recurringSpendingAmountString =
        "-\$${widget.recurringSpending.expectedAmount.abs().toStringAsFixed(2)}";

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logoService = getIt<LogoService>();
    final assetLogo = logoService.getCategoryIcon(
      widget.recurringSpending.category,
      isDark,
    );

    Widget logoWidget;
    if (_tryNetwork && networkLogoUrl != null && !_networkFailed) {
      logoWidget = ClipOval(
        child: Image.network(
          networkLogoUrl!,
          height: 42,
          width: 42,
          errorBuilder: (context, error, stackTrace) {
            // Network image failed; never try again
            _networkFailed = true;

            if (!_networkFailed) {
              _networkFailed = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) setState(() {});
              });
            }

            return const SizedBox(height: 42, width: 42);
          },
        ),
      );
    } else {
      logoWidget = Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: SpendingCategoryUtil.getCategoryColor(
            widget.recurringSpending.category,
          ),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8),
        child: Image.asset(assetLogo, fit: BoxFit.contain),
      );
    }
    return FlowSafeArea(
      backgroundColor: Theme.of(context).cardColor,
      child: StoreConnector<FlowState, List<Transaction>>(
        converter: (store) {
          final transactions = store.state.transactionState.transactions
              .where(
                (tx) => widget.recurringSpending.transactionIds.contains(tx.id),
              )
              .toList();
          transactions.sort((a, b) => b.date.compareTo(a.date));
          return transactions;
        },
        builder: (context, transactions) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FlowTopBar(title: Text(""), showBackButton: true),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    FlowSeparatorBox(height: 36),
                    Row(
                      children: [
                        logoWidget,
                        FlowSeparatorBox(width: 8),
                        Text(
                          recurringSpendingProcessedName,
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
                          recurringSpendingAmountString,
                          style: Theme.of(context).textTheme.displayLarge,
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
                            recurringSpendingProcessedName,
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

                    widget.recurringSpending.nextTransactionDate != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Next predicted date",
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                Text(
                                  DateTimeUtil.getFormattedDate(
                                    widget
                                        .recurringSpending
                                        .nextTransactionDate!,
                                  ),
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color
                                            ?.withAlpha(150),
                                      ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox.shrink(),

                    FlowSeparatorBox(height: 8),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Category",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            widget.recurringSpending.category,
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
                            "Interval",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            _formatIntervalDays(
                              widget.recurringSpending.intervalDays,
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

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Past Total",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text(
                            "\$${transactions.fold(0.0, (previousValue, element) => previousValue + element.amount.abs()).toStringAsFixed(2)} over ${transactions.length} transactions",
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
                  ],
                ),
              ),

              FlowSeparatorBox(height: 12),

              Container(
                height: 12,
                color: Theme.of(context).brightness == Brightness.light
                    ? Theme.of(context).canvasColor
                    : const Color(0xFF303030),
              ),

              Expanded(
                child: StoreConnector<FlowState, List<Transaction>>(
                  converter: (store) {
                    final transactions = store
                        .state
                        .transactionState
                        .transactions
                        .where(
                          (tx) => widget.recurringSpending.transactionIds
                              .contains(tx.id),
                        )
                        .toList();
                    transactions.sort((a, b) => b.date.compareTo(a.date));
                    return transactions;
                  },
                  builder: (context, transactions) => ListView(
                    children: [
                      TransactionList(
                        transactions: transactions,
                        hasFade: false,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
