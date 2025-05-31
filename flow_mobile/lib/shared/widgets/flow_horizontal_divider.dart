import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class FlowHorizontalDivider extends StatelessWidget {
  const FlowHorizontalDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<FlowState, String>(
      converter: (store) => store.state.settingsState.settings.theme,
      builder: (context, theme) {
        return Container(
          height: 1,
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  theme == "light" ? Colors.grey.shade400 : Color(0x88EDEDED),
              width: 1.0,
            ),
          ),
        );
      },
    );
  }
}