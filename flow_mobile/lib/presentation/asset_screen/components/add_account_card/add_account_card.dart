import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/thunks/link_thunks.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

/// A placeholder section for a "Quick Transfer" feature.
class AddAccountCard extends StatelessWidget {
  const AddAccountCard({super.key});

  void onQuickTransferPressed(BuildContext context) {
    StoreProvider.of<FlowState>(context).dispatch(openAddAccountScreenThunk());
  }

  static const double _horizontalPadding = 24.0;
  static const double _verticalPadding = 25.0;
  static const double _bottomMargin = 15.0;
  static const double _borderRadius = 15.0;
  static const double _iconSize = 17.0;

  @override
  Widget build(BuildContext context) {
    return FlowButton(
      onPressed: () {
        onQuickTransferPressed(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: _verticalPadding,
          horizontal: _horizontalPadding,
        ),
        margin: EdgeInsets.only(bottom: _bottomMargin),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(_borderRadius),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Add account',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Image.asset(
              'assets/icons/arrow_right.png',
              width: _iconSize,
              height: _iconSize,
            ),
          ],
        ),
      ),
    );
  }
}
