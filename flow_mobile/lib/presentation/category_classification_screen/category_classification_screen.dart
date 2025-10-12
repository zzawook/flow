import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/presentation/transaction_detail_screen/category_selection_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CategoryClassificationScreen extends StatefulWidget {
  const CategoryClassificationScreen({super.key});
  @override
  State<CategoryClassificationScreen> createState() =>
      _CategoryClassificationScreenState();
}

class _CategoryClassificationScreenState
    extends State<CategoryClassificationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _start());
  }

  void _start() {
    if (!mounted) return;
    final store = StoreProvider.of<FlowState>(context, listen: false);
    final month = DateTime(
      store.state.screenState.spendingScreenState.displayedMonth.year,
      store.state.screenState.spendingScreenState.displayedMonth.month,
    );
    final list = store.state.transactionState.getUncategorizedTransactions(
      month,
    );

    if (list.isEmpty) {
      Navigator.of(context).pop();
      return;
    }

    Navigator.of(context).pushReplacement(categoryRoute(list.first));
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
