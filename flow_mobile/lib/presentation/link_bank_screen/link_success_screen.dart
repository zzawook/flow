import 'package:flow_mobile/domain/entity/bank.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/thunks/link_thunks.dart';
import 'package:flow_mobile/presentation/shared/flow_cta_button.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class LinkSuccessScreen extends StatelessWidget {
  final Bank bank;

  const LinkSuccessScreen({super.key, required this.bank});

  @override
  Widget build(BuildContext context) {
    String compliment1 = "Lovely job!";
    String compliment2 = "You rock!";
    String compliment3 = "Fantastic work!";
    String compliment4 = "Way to go!";
    String compliment5 = "Brilliant!";

    String selectedCompliment = // RANDOMLY SELECT A COMPLIMENT
        ([compliment1, compliment2, compliment3, compliment4, compliment5]
          ..shuffle()).first;

    return FlowSafeArea(
      backgroundColor: Theme.of(context).canvasColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FlowTopBar(title: Text(""), showBackButton: false),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Text(
              selectedCompliment,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 8),
            child: Text(
              "Link successful for ${bank.name}!",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),

          Expanded(
            child: Center(
              child: Text(
                "🎉",
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge?.copyWith(fontSize: 150),
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
