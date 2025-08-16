import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlowMainTopBar extends ConsumerWidget {
  const FlowMainTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasUncheckedNotification = ref.watch(hasUncheckedNotificationProvider);
    
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
                if (hasUncheckedNotification)
                  Positioned(
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
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
