import 'package:flutter/widgets.dart';
import 'package:flow_mobile/domain/entities/transaction.dart';
import 'package:flow_mobile/shared/utils/date_time_util.dart';
import 'package:flow_mobile/presentation/spending_screen/components/spending_overview_card/transaction_item.dart';
import 'package:flow_mobile/shared/widgets/flow_horizontal_divider.dart';
import 'package:flow_mobile/shared/widgets/flow_separator_box.dart';

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
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            color: Color(0xFF000000),
          ),
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

                      return Column(
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
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(0xAA000000),
                                    ),
                                  ),
                                ),
                                FlowHorizontalDivider(),
                                FlowSeparatorBox(height: 8),
                              ],
                            ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TransactionItem(
                              name: txn.name,
                              amount: txn.amount,
                              category: txn.category,
                              color: Color(0xFF000000),
                              incomeColor:
                                  txn.amount > 0
                                      ? const Color(0xFF00C864)
                                      : const Color(0xFF000000),
                            ),
                          ),
                        ],
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
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFFFFFFF), // match background
                    Color(0x00F5F5F5), // transparent
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
