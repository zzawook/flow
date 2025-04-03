import 'package:flow_mobile/domain/entities/bank_account.dart';
import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flutter/widgets.dart';

class AccountTile extends StatelessWidget {
  final BankAccount bankAccount;
  final VoidCallback onTransferPressed;

  const AccountTile({
    super.key,
    required this.bankAccount,
    required this.onTransferPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FlowButton(
      onPressed: onTransferPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            // Bank logo
            SizedBox(
              width: 50,
              height: 50,
              child: Image.asset(
                bankAccount.bank.logoPath,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),
            // Bank name + account type + balance
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        bankAccount.bank.name,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF454545),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        bankAccount.accountName,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF454545),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$ ${bankAccount.balance.toString()}",
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF454545),
                    ),
                  ),
                ],
              ),
            ),
            Image.asset("assets/icons/arrow_right.png", width: 16, height: 16),
          ],
        ),
      ),
    );
  }
}
