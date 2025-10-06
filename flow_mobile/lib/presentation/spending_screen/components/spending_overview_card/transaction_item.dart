import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/presentation/spending_screen/components/spending_overview_card/transaction_tag.dart';
import 'package:flow_mobile/service/logo_service.dart';
import 'package:flow_mobile/utils/spending_category_util.dart';
import 'package:flutter/material.dart';

/// Individual Transaction Item
class TransactionItem extends StatefulWidget {
  final String name;
  final double amount;
  final String brandDomain;
  final String category;
  final Color color;
  final Color incomeColor;

  const TransactionItem({
    super.key,
    required this.name,
    required this.amount,
    required this.brandDomain,
    required this.category,
    required this.color,
    required this.incomeColor,
  });

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  String? networkLogoUrl;
  bool _tryNetwork = false; // whether to attempt network logo
  bool _networkFailed = false; // once true, never try again

  @override
  void initState() {
    super.initState();
    _loadLogo();
  }

  void _loadLogo() {
    // base asset is decided in build() by theme; nothing to do here
    if (widget.brandDomain.isEmpty) return;

    final logoService = getIt<LogoService>();
    final fetched = logoService.getLogoUrl(widget.brandDomain);
    if (fetched.isNotEmpty) {
      setState(() {
        networkLogoUrl = fetched;
        _tryNetwork = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final processedName = widget.name.length > 35
        ? "${widget.name.replaceAll("\n", " ").substring(0, 35)}..."
        : widget.name.replaceAll("\n", " ");

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logoService = getIt<LogoService>();
    final assetLogo = logoService.getCategoryIcon(widget.category, isDark);

    Widget logoWidget;
    if (_tryNetwork && !_networkFailed && networkLogoUrl != null) {
      // Only the network image is clipped
      logoWidget = ClipOval(
        child: Image.network(
          networkLogoUrl!,
          height: 42,
          width: 42,
          errorBuilder: (context, error, stackTrace) {
            // Mark failure exactly once, then rebuild to show asset (not clipped)
            if (!_networkFailed) {
              _networkFailed = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) setState(() {});
              });
            }
            // temporary placeholder so layout doesn't jump this frame
            return const SizedBox(height: 42, width: 42);
          },
        ),
      );
    } else {
      // Fallback: category icon inside a colored circle
      logoWidget = Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: SpendingCategoryUtil.getCategoryColor(widget.category),
        ),
        padding: const EdgeInsets.all(8),
        child: Image.asset(assetLogo, fit: BoxFit.contain),
      );
    }

    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: logoWidget,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        "${widget.amount < 0 ? '-' : '+'}${widget.amount.abs().toStringAsFixed(2)}",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: widget.amount > 0
                              ? widget.incomeColor
                              : widget.color,
                        ),
                      ),
                    ),
                    Text(
                      processedName,
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
              ],
            ),
          ),
          TransactionTag(tag: widget.category, fontSize: 12.0),
        ],
      ),
    );
  }
}
