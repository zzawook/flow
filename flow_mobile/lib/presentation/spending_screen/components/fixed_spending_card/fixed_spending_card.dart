import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/utils/recurring_spending.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class FixedSpendingCard extends ConsumerStatefulWidget {
  /// The month to show initially
  final DateTime initialMonth;

  const FixedSpendingCard({super.key, required this.initialMonth});

  @override
  ConsumerState<FixedSpendingCard> createState() => FixedSpendingCardState();
}

class FixedSpendingCardState extends ConsumerState<FixedSpendingCard> {
  late DateTime displayMonth;

  @override
  void initState() {
    super.initState();
    displayMonth = widget.initialMonth;
  }

  Map<FixedSpendingCategory, double> spendingData = {
    FixedSpendingCategory.telco: 32,
    FixedSpendingCategory.subscription: 18,
    FixedSpendingCategory.utilities: 125.24,
    FixedSpendingCategory.insurance: 79.95,
    FixedSpendingCategory.rent: 1550.0,
    FixedSpendingCategory.others: 30.25,
    FixedSpendingCategory.installment: 200.0,
  };

  /// Total of all categories
  double get totalSpending =>
      spendingData.values.fold(0, (sum, val) => sum + val);

  /// Format numbers as “₩33,570”
  String _formatSGD(double amount) {
    final f = NumberFormat.currency(
      locale: 'en_SG',
      customPattern: "#,##0.00 'SGD'",
      decimalDigits: 2,
    );
    return f.format(amount);
  }

  /// Format numbers as “₩33,570”
  String _formatSGDollarSign(double amount) {
    final f = NumberFormat.currency(
      locale: 'en_SG',
      symbol: '\$ ',
      decimalDigits: 2,
    );
    return f.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Recurring Spendings",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    _formatSGDollarSign(totalSpending),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00C864),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            ...spendingData.entries.map((entry) {
              if (entry.value == 0) {
                return const SizedBox.shrink();
              }
              final displayMonth = ref.watch(spendingScreenStateProvider).displayedMonth;
              return FlowButton(
                      onPressed: () {
                        // Handle button press
                        Navigator.pushNamed(
                          context,
                          "/fixed_spending/details",
                          arguments: CustomPageRouteArguments(
                            transitionType: TransitionType.slideLeft,
                            extraData: displayMonth,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 24,
                          right: 24,
                          top: 14,
                          bottom: 14,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Color(0xFFF0F0F0)
                                            : Theme.of(
                                              context,
                                            ).colorScheme.surfaceBright,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: entry.key.icon,
                                ),
                                const FlowSeparatorBox(width: 18),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      entry.key.label,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelMedium?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface.withAlpha(180),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _formatSGD(entry.value),
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.copyWith(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: const Color(0xFFB0B0B0),
                            ),
                          ],
                        ),
                      ),
                    );
            }),
          ],
        ),
      ),
    );
  }
}
