import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/shared/flow_cta_button.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';
import 'package:flow_mobile/presentation/transfer_screen/transfer_top_bar.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransferResultScreen extends ConsumerWidget {
  const TransferResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transferState = ref.watch(transferStateProvider);
    return Container(
      color: const Color(0xFFFFFFFF),
      child: Padding(
        padding: const EdgeInsets.only(top: 72),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TransferTopBar(previousScreenRoute: "/transfer"),
            ),

            // Main content
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // The green check circle
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
                                color: Color(0xFFE0F8EB),
                              ),
                              child: Center(
                                child: SizedBox(
                                  width: 120,
                                  height: 120,
                                  child: Image.asset(
                                    // Replace with your own bank logo
                                    'assets/icons/check.png',
                                    width: 120,
                                    height: 120,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Transfered',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF000000),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                                    '\$${(transferState.amount / 100).toStringAsFixed(2)} to ${transferState.receiving.name}',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF000000),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom buttons row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
              child: Column(
                children: [
                  Row(
                    children: [
                      // OK button
                      Expanded(
                        child: FlowCTAButton(
                          text: "Share",
                          onPressed: () {},
                          color: Color(0xFFEBFFF2),
                          textColor: Color(0x88000000),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  FlowSeparatorBox(height: 12),
                  Row(
                    children: [
                      // OK button
                      Expanded(
                        child: FlowCTAButton(
                          text: "OK",
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/home',
                              arguments: CustomPageRouteArguments(
                                transitionType: TransitionType.slideLeft,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
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
