import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/thunks/asset_screen_thunks.dart';
import 'package:flow_mobile/presentation/asset_screen/components/add_account_card/add_account_card.dart';
import 'package:flow_mobile/presentation/asset_screen/components/bank_account_card/bank_account_card.dart';
import 'package:flow_mobile/presentation/asset_screen/components/card_card/card_card.dart';
import 'package:flow_mobile/presentation/asset_screen/components/total_asset_card/total_asset_card.dart';
import 'package:flow_mobile/presentation/shared/flow_bottom_nav_bar.dart';
import 'package:flow_mobile/presentation/shared/flow_main_top_bar.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class AssetScreen extends StatefulWidget {
  const AssetScreen({super.key});

  @override
  State<AssetScreen> createState() => _AssetScreenState();
}

class _AssetScreenState extends State<AssetScreen> {
  bool _dispatched = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_dispatched) return;

    final store = StoreProvider.of<FlowState>(context);
    store.dispatch(fetchMonthlyAssetsThunk());
    _dispatched = true; // prevents re-dispatch on rebuilds
  }

  @override
  Widget build(BuildContext context) {
    return FlowSafeArea(
      backgroundColor: Theme.of(context).canvasColor,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 18, right: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FlowMainTopBar(),
                    const BankAccountCard(),

                    const CardCard(),

                    const FlowSeparatorBox(height: 16),

                    AddAccountCard(),

                    const TotalAssetCard(),
                  ],
                ),
              ),
            ),
          ),
          const FlowBottomNavBar(),
        ],
      ),
    );
  }
}
