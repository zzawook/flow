import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/shared/widgets/flow_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart'; // Or flutter/widgets.dart if you prefer, but Material is typical.

class FlowMainTopBar extends StatelessWidget {
  const FlowMainTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/FLOW.png', width: 80),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                '/notification',
                arguments: CustomPageRouteArguments(
                  transitionType: TransitionType.slideBottom,
                ),
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(
                    'assets/icons/notification_icon.png',
                    height: 30,
                    width: 30,
                  ),
                ),

                StoreConnector<FlowState, bool>(
                  converter:
                      (store) =>
                          store.state.notificationState
                              .hasUncheckedNotification(),
                  builder: (context, hasUncheckedNotification) {
                    return Positioned(
                      // Adjust these values as needed for your layout
                      top: 6,
                      right: 4,
                      child: FlowButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/notification',
                            arguments: CustomPageRouteArguments(
                              transitionType: TransitionType.slideTop,
                            ),
                          );
                        },
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF50C878),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
