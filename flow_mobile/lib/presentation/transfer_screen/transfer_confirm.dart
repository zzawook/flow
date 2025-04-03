import 'package:flow_mobile/shared/widgets/flow_cta_button.dart';
import 'package:flow_mobile/shared/widgets/flow_separator_box.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/transfer_state.dart';
import 'package:flow_mobile/presentation/transfer_screen/transfer_top_bar.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

/// The Transfer Confirmation screen using only WidgetsApp-compatible widgets.
class TransferConfirmationScreen extends StatelessWidget {
  const TransferConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFFFFF),
      child: Padding(
        padding: const EdgeInsets.only(top: 72),
        child: StoreConnector<FlowState, TransferState>(
          converter: (store) => store.state.transferState,
          builder:
              (context, transferState) => Column(
                children: [
                  // Top bar row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: TransferTopBar(previousScreenRoute: '/transfer/to'),
                  ),

                  // Main content
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Bank logo inside a circle
                          Container(
                            width: 150,
                            height: 150,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFE0E0E0),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                // Replace with your own bank logo
                                transferState.fromAccount.bank.logoPath,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Transfer',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 24,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF000000),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '\$${(transferState.amountInCents / 100).toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF000000),
                                ),
                              ),
                              const Text(
                                ' to ',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 28,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF000000),
                                ),
                              ),
                              Text(
                                transferState.toAccount.accountHolder,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF000000),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        // Recipient row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Remark to recepient',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                color: Color(0xFF757575),
                              ),
                            ),
                            Row(
                              children: [
                                StoreConnector<FlowState, String>(
                                  converter:
                                      (store) =>
                                          store.state.userState.user.name,
                                  builder:
                                      (context, name) => Text(
                                        name,
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 16,
                                          color: Color(0xFF000000),
                                        ),
                                      ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Image.asset(
                                    "assets/icons/arrow_right.png",
                                    height: 12,
                                    width: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Date row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'From',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                color: Color(0xFF757575),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  'My ${transferState.fromAccount.bank.name} ${transferState.fromAccount.accountName}',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    color: Color(0xFF000000),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Image.asset(
                                    "assets/icons/arrow_right.png",
                                    height: 12,
                                    width: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  FlowSeparatorBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 28,
                    ),
                    child: FlowCTAButton(
                      text: "Transfer",
                      onPressed: () {
                        Navigator.pushNamed(context, '/transfer/result');
                      },
                    ),
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
