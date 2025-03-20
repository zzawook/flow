import 'package:flow_mobile/common/flow_button.dart';
import 'package:flow_mobile/common/flow_separator_box.dart';
import 'package:flow_mobile/presentation/trsansfer_screen/transfer_top_bar.dart';
import 'package:flutter/widgets.dart';

class TransferScreen extends StatelessWidget {
  const TransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for the accounts:
    final accounts = [
      {
        'logo': 'assets/bank_logos/DBS.png',
        'bankName': 'DBS',
        'accountType': 'Savings account',
        'balance': '\$ 4,325.90',
      },
      {
        'logo': 'assets/bank_logos/UOB.png',
        'bankName': 'OCBC',
        'accountType': 'Savings account',
        'balance': '\$ 500.00',
      },
      {
        'logo': 'assets/bank_logos/Maybank.png',
        'bankName': 'Maybank',
        'accountType': 'Savings account',
        'balance': '\$ 43.27',
      },
    ];

    // Use Directionality so text is laid out properly (LTR or RTL).
    return Container(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 72.0),
      child: Column(
        children: [
          // A simple “app bar” row with a centered title:
          TransferTopBar(previousScreenRoute: "/home"),

          const SizedBox(height: 30),
          // User info
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Hi Minseok,',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000),
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Your total balance: ',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF50C878),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '\$4,869.17',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF50C878),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          HorizontalDivider(),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choose your bank account to',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Color(0xAA000000),
                    ),
                  ),
                  FlowSeparatorBox(height: 6),
                  Text(
                    'Transfer from:',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000000),
                    ),
                  ),
                ],
              ),
            ],
          ),

          FlowSeparatorBox(height: 16),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 0, right: 0),
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                return _AccountTile(
                  logoPath: account['logo']!,
                  bankName: account['bankName']!,
                  accountType: account['accountType']!,
                  balance: account['balance']!,
                  onTransferPressed: () {
                    // Implement your transfer logic or navigation
                    Navigator.pushNamed(context, '/transfer/amount');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HorizontalDivider extends StatelessWidget {
  const HorizontalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFEDEDED), width: 1.2),
      ),
    );
  }
}

// A basic row widget to display the account logo, info, and a transfer button.
class _AccountTile extends StatelessWidget {
  final String logoPath;
  final String bankName;
  final String accountType;
  final String balance;
  final VoidCallback onTransferPressed;

  const _AccountTile({
    required this.logoPath,
    required this.bankName,
    required this.accountType,
    required this.balance,
    required this.onTransferPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          // Bank logo
          SizedBox(
            width: 50,
            height: 50,
            child: Image.asset(logoPath, fit: BoxFit.contain),
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
                      bankName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF656565),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      accountType,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF656565),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  balance,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ),
          // Simple text-based "Transfer" action
          FlowButton(
            onPressed: onTransferPressed,
            child: Container(
              padding: EdgeInsets.all(8),
              width: 65,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xFFEFEFEF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                'assets/icons/transfer_icon.png',
                width: 65,
                height: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
