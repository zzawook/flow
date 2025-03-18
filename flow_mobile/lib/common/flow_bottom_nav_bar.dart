// 📌 Custom Bottom Navigation Bar
import 'package:flow_mobile/common/flow_button.dart';
import 'package:flow_mobile/common/route_observer_service.dart';
import 'package:flutter/widgets.dart';

class FlowBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final RouteObserverService routeObserver;

  const FlowBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.routeObserver,
  });

  @override
  State<FlowBottomNavBar> createState() => _FlowBottomNavBarState();
}

class _FlowBottomNavBarState extends State<FlowBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final routeObserver = widget.routeObserver;
    return Container(
      height: 70,
      color: Color(0xFFEEEEEE), // Light grey background
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: navItem(
              0,
              "home",
              routeObserver.currentRouteName == '/home',
              widget.onItemSelected,
            ),
          ),
          Expanded(
            child: navItem(
              1,
              "spending",
              routeObserver.currentRouteName == '/spending',
              widget.onItemSelected,
            ),
          ),
          Expanded(
            child: navItem(
              2,
              "analysis",
              routeObserver.currentRouteName == '/analysis',
              widget.onItemSelected,
            ),
          ),
        ],
      ),
    );
  }

  Widget navItem(int index, String icon, bool isSelected, Function(int) onTap) {
    return FlowButton(
      onPressed: () => onTap(index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Image.asset(
          'assets/icons/${icon}_icon.png',
          height: 30,
          width: 30,
          color: isSelected ? Color(0xFF000000) : Color(0xFFBDBDBD),
        ),
      ),
    );
  }
}
