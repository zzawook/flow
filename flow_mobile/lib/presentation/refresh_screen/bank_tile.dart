import 'package:flow_mobile/domain/entity/bank.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flutter/material.dart';

class BankTile extends StatefulWidget {
  const BankTile({
    super.key,
    required this.bank,
    required this.bankAccountNames,
    required this.isSelected,
    required this.onTap,
  });

  final Bank bank;
  final List<String> bankAccountNames;
  final bool isSelected;
  final Function onTap;

  @override
  State<BankTile> createState() => _BankTileState();
}

class _BankTileState extends State<BankTile> {
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    final selectedTextStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      // fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface,
    );

    final unselectedTextStyle = Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(
      color: Theme.of(context).colorScheme.onSurface,
      fontWeight: FontWeight.normal,
    );

    final selectedTileColor =
        Theme.of(context).brightness == Brightness.light
            ? Theme.of(context).primaryColor.withAlpha(150)
            : Theme.of(context).primaryColorLight.withAlpha(150);

    return FlowButton(
      onPressed: () {
        widget.onTap();
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        decoration: BoxDecoration(
          color:
              isSelected ? selectedTileColor : Theme.of(context).disabledColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            // Bank logo
            SizedBox(
              width: 50,
              height: 50,
              child: Image.asset(widget.bank.logoPath, fit: BoxFit.contain),
            ),
            const SizedBox(width: 12),
            // Bank name + account type + balance
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.bank.name,
                    style: isSelected ? selectedTextStyle : unselectedTextStyle,
                  ),
                  Text(
                    "${widget.bankAccountNames.length} account${widget.bankAccountNames.length > 1 ? 's' : ''}",
                    style: isSelected ? selectedTextStyle : unselectedTextStyle,
                  ),
                  const SizedBox(height: 4),
                  ...widget.bankAccountNames.map(
                    (accountName) => Text(
                      accountName,
                      style:
                          isSelected ? selectedTextStyle : unselectedTextStyle,
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
