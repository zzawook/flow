import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/presentation/navigation/app_routes.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flow_mobile/presentation/spending_screen/components/spending_overview_card/transaction_item.dart';
import 'package:flow_mobile/service/navigation_service.dart';
import 'package:flow_mobile/utils/date_time_util.dart';
import 'package:flow_mobile/presentation/shared/flow_horizontal_divider.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';
import 'package:flutter/material.dart';

import '../navigation/transition_type.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Map<DateTime, GlobalKey> detailKeys;

  const TransactionList({
    super.key,
    required this.transactions,
    this.detailKeys = const {},
  });

  @override
  Widget build(BuildContext context) {
    final sorted = [...transactions]..sort((a, b) => b.date.compareTo(a.date));
    if (sorted.isEmpty) {
      return Center(
        child: Text(
          'No transactions found',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }

    const double fadeHeight = 24.0;

    return Stack(
      children: [
        // Scrollable content with top padding for fade region
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: fadeHeight),
            child: Column(
              children: [
                for (int index = 0; index < sorted.length; index++) ...[
                  Builder(
                    builder: (context) {
                      final txn = sorted[index];
                      final dateOnly = DateTime(
                        txn.date.year,
                        txn.date.month,
                        txn.date.day,
                      );
                      final dateLabel = DateTimeUtil.getFormattedDate(txn.date);
                      final isNewDate =
                          index == 0 ||
                          !DateTimeUtil.isSameDate(
                            sorted[index - 1].date,
                            txn.date,
                          );

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isNewDate)
                              Column(
                                key: detailKeys[dateOnly],
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: index == 0 ? 0 : 24,
                                      bottom: 8,
                                    ),
                                    child: Text(
                                      dateLabel,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                  FlowHorizontalDivider(),
                                  FlowSeparatorBox(height: 8),
                                ],
                              ),
                            FlowButton(
                              onPressed: () {
                                final navigator = getIt<NavigationService>();
                                navigator.pushNamed(
                                  AppRoutes.transactionDetail,
                                  arguments: CustomPageRouteArguments(
                                    transitionType: TransitionType.slideLeft,
                                    extraData: txn,
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: TransactionItem(
                                  name: txn.name,
                                  amount: txn.amount,
                                  category: txn.category,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withAlpha(240),
                                  incomeColor: txn.amount > 0
                                      ? const Color(0xFF00C864)
                                      : const Color(0xFF000000),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
        // Top fade overlay
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: fadeHeight,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).cardColor, // match background
                    Theme.of(context).cardColor.withAlpha(0), // transparent
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
