import 'package:flow_mobile/domain/entity/bank_account.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flutter/material.dart';

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
                // "assets/bank_logos/${bankAccount.bank.name}.png",
                "assets/bank_logos/DBS.png",
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
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        bankAccount.accountName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$ ${bankAccount.balance.toString()}",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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
