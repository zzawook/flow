// 📌 Custom Bottom Navigation Bar
import 'package:flow_mobile/common/flow_button.dart';
import 'package:flow_mobile/domain/redux/app_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

class FlowBottomNavBar extends StatefulWidget {
  final Function(String) onItemSelected;

  const FlowBottomNavBar({
    super.key,
    required this.onItemSelected,
  });

  @override
  State<FlowBottomNavBar> createState() => _FlowBottomNavBarState();
}

class _FlowBottomNavBarState extends State<FlowBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF5F5F5), // Light grey background
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          color: Color(0xFFEEEEEE), // Light grey background
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: StoreConnector<FlowState, String>(
          converter: (store) => store.state.screenState.screenName,
          builder: (context, screenName) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: navItem("home", screenName == '/home', () {
                    widget.onItemSelected("/home");
                  }),
                ),
                Expanded(
                  child: navItem("spending", screenName == '/spending', () {
                    widget.onItemSelected("/spending");
                  }),
                ),
                Expanded(
                  child: navItem("analysis", screenName == '/transfer', () {
                    widget.onItemSelected("/transfer");
                  }),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget navItem(String icon, bool isSelected, Function() onTap) {
    return FlowButton(
      onPressed: () => onTap(),
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
