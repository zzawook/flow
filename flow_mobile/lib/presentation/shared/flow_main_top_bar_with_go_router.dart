import 'package:flow_mobile/presentation/navigation/app_navigation.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flow_mobile/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Example of FlowMainTopBar using the new GoRouter navigation system
/// This demonstrates how to migrate from Navigator.pushNamed to AppNavigation methods
class FlowMainTopBarWithGoRouter extends ConsumerWidget {
  const FlowMainTopBarWithGoRouter({super.key});

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
              // OLD WAY:
              // Navigator.pushNamed(
              //   context,
              //   '/notification',
              //   arguments: CustomPageRouteArguments(
              //     transitionType: TransitionType.slideBottom,
              //   ),
              // );
              
              // NEW WAY with GoRouter:
              AppNavigation.pushToNotification(context);
              // Note: Transitions are handled automatically by the router configuration
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
                        // OLD WAY:
                        // Navigator.pushNamed(
                        //   context,
                        //   '/notification',
                        //   arguments: CustomPageRouteArguments(
                        //     transitionType: TransitionType.slideTop,
                        //   ),
                        // );
                        
                        // NEW WAY with GoRouter:
                        AppNavigation.pushToNotification(context);
                        // Note: The transition type is configured in the router
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