import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/thunks/link_thunks.dart';
import 'package:flow_mobile/presentation/shared/flow_cta_button.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class LinkSuccessScreen extends StatelessWidget {
  const LinkSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FlowSafeArea(
      child: Column(
        children: [
          FlowTopBar(title: Text(""), showBackButton: false),
          Expanded(
            child: Center(
              child: Text(
                "Bank linked successfully!",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            child: FlowCTAButton(
              text: "Continue",
              onPressed: () {
                StoreProvider.of<FlowState>(
                  context,
                  listen: false,
                ).dispatch(linkBankThunk());
              },
            ),
          ),
        ],
      ),
    );
  }
}
