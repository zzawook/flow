import 'package:flow_mobile/domain/entity/bank.dart';
import 'package:flow_mobile/domain/redux/actions/refresh_screen_action.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/presentation/link_bank_screen/webview_widget.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class LinkBankScreen extends StatefulWidget {
  final String url;
  final Bank bank;

  const LinkBankScreen({super.key, required this.url, required this.bank});

  @override
  State<LinkBankScreen> createState() => _LinkBankScreenState();
}

class _LinkBankScreenState extends State<LinkBankScreen> {
  @override
  Widget build(BuildContext context) {
    return FlowSafeArea(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          FlowTopBar(
            title: Text(""),
            showBackButton: true,
            onBackPressed: () {
              StoreProvider.of<FlowState>(context, listen: false)
                  .dispatch(CancelLinkBankingScreenAction(bank: widget.bank));
            },
          ),
          Expanded(child: WebviewWidget(url: widget.url)),
        ],
      ),
    );
  }
}
