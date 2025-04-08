import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flow_mobile/domain/redux/actions/transfer_actions.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/presentation/transfer_screen/transfer_top_bar.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class TransferAmountScreen extends StatefulWidget {
  const TransferAmountScreen({super.key});

  @override
  State<TransferAmountScreen> createState() => TransferAmountScreenState();
}

class TransferAmountScreenState extends State<TransferAmountScreen> {
  /// Holds the user-entered amount in cents. (e.g., 123 => $1.23)
  int _amount = 0;

  void onTransferButtonPressed() {
    StoreProvider.of<FlowState>(
      context,
    ).dispatch(EnterAmountAction(_amount));
    Navigator.pushNamed(context, '/transfer/confirm');
  }

  /// Returns a string like "0.00" or "123.45" for display.
  String get _formattedAmount {
    final dollars = _amount ~/ 100;
    final cents = _amount % 100;
    return '$dollars.${cents.toString().padLeft(2, '0')}';
  }

  void _onDigitPressed(String digit) {
    HapticFeedback.vibrate();
    setState(() {
      // Shift current value left and add the new digit.
      // This example caps at 999,999,999 cents (~$9,999,999.99).
      if (_amount < 999999999) {
        _amount = _amount * 10 + int.parse(digit);
      }
    });
  }

  void _onBackspacePressed() {
    HapticFeedback.vibrate();
    setState(() {
      // Remove the last digit by integer division.
      _amount = _amount ~/ 10;
    });
  }

  void _onClearPressed() {
    HapticFeedback.vibrate();
    setState(() {
      _amount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Directionality ensures text is laid out (LTR or RTL).
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        color: const Color(0xFFF5F5F5),
        child: Padding(
          padding: const EdgeInsets.only(top: 72.0),
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TransferTopBar(previousScreenRoute: "/transfer"),
              ),

              // The large amount display
              Expanded(
                child: Center(
                  child: Text(
                    '\$ $_formattedAmount',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
              ),

              _amount > 0
                  ? Row(
                    children: [
                      TransferButton(onPressed: onTransferButtonPressed),
                    ],
                  )
                  : const SizedBox(height: 60),

              // The custom 3×4 keypad
              _buildNumberPad(),

              // Bottom row: Cancel and Transfer
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the 3×4 numeric keypad: digits 1–9, [X] to clear, 0, and [<] to backspace.
  Widget _buildNumberPad() {
    final buttons = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      'X',
      '0',
      '<',
    ];

    return SizedBox(
      height: 300, // Approx. keypad height
      child: GridView.builder(
        padding: EdgeInsets.zero,
        itemCount: buttons.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisExtent: 75, // Each row's height
        ),
        itemBuilder: (context, index) {
          final label = buttons[index];
          return FlowButton(
            onPressed: () {
              if (label == 'X') {
                _onClearPressed();
              } else if (label == '<') {
                _onBackspacePressed();
              } else {
                _onDigitPressed(label);
              }
            },
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child:
                    label == '<'
                        ? Image.asset(
                          "assets/icons/backspace.png",
                          width: 24,
                          height: 24,
                        )
                        : Text(
                          label,
                          style: () {
                            if (label == 'X' || label == '<') {
                              return const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 24,
                                color: Color(0xFFB0B0B0),
                                fontWeight: FontWeight.w500,
                              );
                            } else {
                              return const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 24,
                                color: Color(0xFF000000),
                              );
                            }
                          }(),
                        ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TransferButton extends StatelessWidget {
  final Function onPressed;
  const TransferButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FlowButton(
        onPressed: onPressed,
        child: Container(
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Color(0xFF50C878),
            borderRadius: BorderRadius.circular(0),
          ),
          child: const Text(
            'Transfer',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              color: Color(0xFFFFFFFF),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class CancelButton extends StatelessWidget {
  const CancelButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FlowButton(
        onPressed: () {
          Navigator.pushNamed(context, '/transfer');
        },
        child: Container(
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              color: Color(0x88000000),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
