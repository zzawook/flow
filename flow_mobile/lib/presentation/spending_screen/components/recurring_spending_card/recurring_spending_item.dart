import 'package:flow_mobile/domain/entity/recurring_spending.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/presentation/spending_screen/components/spending_overview_card/transaction_tag.dart';
import 'package:flow_mobile/service/logo_service.dart';
import 'package:flow_mobile/utils/date_time_util.dart';
import 'package:flow_mobile/utils/spending_category_util.dart';
import 'package:flutter/material.dart';

/// Individual Recurring Spending Item (similar to TransactionItem)
class RecurringSpendingItem extends StatefulWidget {
  final RecurringSpending recurring;
  // The month this item is being displayed in
  final DateTime month;
  final VoidCallback onTap;

  const RecurringSpendingItem({
    super.key,
    required this.recurring,
    required this.month,
    required this.onTap,
  });

  @override
  State<RecurringSpendingItem> createState() => _RecurringSpendingItemState();
}

class _RecurringSpendingItemState extends State<RecurringSpendingItem> {
  String? networkLogoUrl;
  bool _tryNetwork = false;
  bool _networkFailed = false;

  @override
  void initState() {
    super.initState();
    _loadLogo();
  }

  void _loadLogo() {
    if (widget.recurring.brandDomain == null ||
        widget.recurring.brandDomain!.isEmpty) {
      return;
    }

    final logoService = getIt<LogoService>();
    final fetched = logoService.getLogoUrl(widget.recurring.brandDomain!);
    if (fetched.isNotEmpty) {
      setState(() {
        networkLogoUrl = fetched;
        _tryNetwork = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayName = widget.recurring.displayName.length > 35
        ? "${widget.recurring.displayName.substring(0, 35)}..."
        : widget.recurring.displayName;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logoService = getIt<LogoService>();
    final assetLogo = logoService.getCategoryIcon(
      widget.recurring.category,
      isDark,
    );

    Widget logoWidget;
    if (_tryNetwork && !_networkFailed && networkLogoUrl != null) {
      // Network logo (clipped to circle)
      logoWidget = ClipOval(
        child: Image.network(
          networkLogoUrl!,
          height: 42,
          width: 42,
          errorBuilder: (context, error, stackTrace) {
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
      // Fallback: category icon in colored circle
      logoWidget = Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: SpendingCategoryUtil.getCategoryColor(
            widget.recurring.category,
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Image.asset(assetLogo, fit: BoxFit.contain),
      );
    }

    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Row(
          children: [
            // Logo
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: logoWidget,
            ),
            // Amount and name
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      "-${widget.recurring.expectedAmount.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFEB5757),
                      ),
                    ),
                  ),
                  Text(
                    displayName,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha(150),
                    ),
                  ),
                ],
              ),
            ),
            // Right chevron arrow
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TransactionTag(tag: widget.recurring.category, fontSize: 12.0),
                const SizedBox(height: 8),
                widget.recurring.lastTransactionDate != null
                    ? Text(
                        (widget.recurring.lastTransactionDate != null)
                            ? 'Last: ${DateTimeUtil.getMonthName(widget.recurring.lastTransactionDate!.month)} ${widget.recurring.lastTransactionDate!.day}${DateTimeUtil.getDatePostFix(widget.recurring.lastTransactionDate!.day)}'
                            : '',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(150),
                        ),
                      )
                    : const SizedBox.shrink(),
                widget.recurring.nextTransactionDate != null &&
                        DateTimeUtil.isSameMonth(
                          widget.month,
                          widget.recurring.nextTransactionDate!,
                        )
                    ? Text(
                        (widget.recurring.nextTransactionDate != null)
                            ? 'Next: ${DateTimeUtil.getMonthName(widget.recurring.nextTransactionDate!.month)} ${widget.recurring.nextTransactionDate!.day}${DateTimeUtil.getDatePostFix(widget.recurring.nextTransactionDate!.day)}'
                            : 'No upcoming',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(150),
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
