import 'package:flow_mobile/utils/spending_category_util.dart';
import 'package:flutter/widgets.dart';

class TransactionTag extends StatelessWidget {
  final String tag;
  final double fontSize;

  const TransactionTag({super.key, required this.tag, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: SpendingCategoryUtil.getCategoryColor(
          tag,
        ).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Text(
        tag,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: SpendingCategoryUtil.getCategoryColor(
            tag,
          ).withValues(alpha: 1.0),
        ),
      ),
    );
  }
}
