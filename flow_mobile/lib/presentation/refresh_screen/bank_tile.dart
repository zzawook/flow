import 'package:flow_mobile/domain/entities/bank.dart';
import 'package:flow_mobile/domain/redux/actions/refresh_screen_action.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
          color: isSelected ? const Color(0x4450C878) : const Color(0xFFFFFFFF),
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
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF454545),
                    ),
                  ),
                  Text(
                    "${widget.bankAccountNames.length} account${widget.bankAccountNames.length > 1 ? 's' : ''}",
                  ),
                  const SizedBox(height: 4),
                  ...widget.bankAccountNames.map(
                    (accountName) => Text(
                      accountName,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF454545),
                      ),
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
