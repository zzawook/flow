import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/thunks/transaction_thunks.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/presentation/navigation/app_routes.dart';
import 'package:flow_mobile/presentation/navigation/app_transitions.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flow_mobile/presentation/shared/flow_cta_button.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flow_mobile/service/logo_service.dart';
import 'package:flow_mobile/utils/date_time_util.dart';
import 'package:flow_mobile/utils/spending_category_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

PageRoute categoryRoute(Transaction tx) => PageRouteBuilder(
  pageBuilder: (_, _, _) => CategorySelectionScreen(
    transaction: tx,
    isCategorizingUnclassified: true,
  ),
  transitionsBuilder: (ctx, anim, sec, child) =>
      AppTransitions.build(TransitionType.slideLeft, anim, child),
  transitionDuration: const Duration(milliseconds: 150),
  reverseTransitionDuration: const Duration(milliseconds: 220),
);

// ignore: must_be_immutable
class CategorySelectionScreen extends StatefulWidget {
  final Transaction transaction;
  final bool isCategorizingUnclassified;

  const CategorySelectionScreen({
    super.key,
    required this.transaction,
    this.isCategorizingUnclassified = false,
  });

  @override
  State<CategorySelectionScreen> createState() =>
      _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>(); // <-- add key

  String logoUrl = "";
  bool isLogoFromNetwork = false;

  String selectedCategory = "";
  PersistentBottomSheetController? _sheetController;

  void _showConfirmSheet(String category) {
    if (_sheetController != null) return; // already open

    final scaffoldState = _scaffoldKey.currentState;
    if (scaffoldState == null) return;

    _sheetController = scaffoldState.showBottomSheet(
      (ctx) {
        final store = StoreProvider.of<FlowState>(context);

        return SafeArea(
          top: false,
          child: Container(
            height: 150,
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              color: Theme.of(context).canvasColor,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Change the category to $category?"),
                const SizedBox(height: 12),
                FlowCTAButton(
                  onPressed: () {
                    store.dispatch(
                      setTransactionCategoryThunk(widget.transaction, category),
                    );
  
                    // 2) Close the persistent sheet
                    final controller = _sheetController;
                    _sheetController = null;

                    // 3a) If we are categorizing unclassified transactions,
                    if (widget.isCategorizingUnclassified) {
                      if (!mounted) return;
                      final month = StoreProvider.of<FlowState>(
                        context,
                        listen: true,
                      ).state.screenState.spendingScreenState.displayedMonth;
                      final remaining = store.state.transactionState
                          .getUncategorizedTransactions(month);

                      if (remaining.isEmpty) {
                        // End of flow
                        if (mounted) {
                          Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.categoryClassificationSuccess);
                        }
                        return;
                      }

                      // 4) Replace this page with a fresh one for the next transaction
                      if (mounted) {
                        Navigator.of(
                          context,
                        ).pushReplacement(categoryRoute(remaining.first));
                      }
                      controller?.close();
                      return;
                    }

                    // 3b) Otherwise, after the sheet’s LocalHistoryEntry is removed, pop the page
                    controller?.closed.then((_) {
                      if (mounted) {
                        Navigator.of(
                          ctx,
                        ).maybePop(); // pops the page in the correct Navigator
                      }
                    });

                    controller?.close();
                  },
                  text: "Change",
                ),
              ],
            ),
          ),
        );
      },
      backgroundColor: Theme.of(context).canvasColor,
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      enableDrag: true,
    );

    _sheetController!.closed.whenComplete(() {
      if (mounted) setState(() => _sheetController = null);
    });
  }

  @override
  void dispose() {
    // ensure it’s closed if this screen unmounts
    _sheetController?.close();
    _sheetController = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.transaction.category;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadLogo(); // safe to read Theme here
  }

  void _loadLogo() {
    final logoService = getIt<LogoService>();
    setState(() {
      logoUrl = logoService.getCategoryIcon(
        widget.transaction.category,
        Theme.of(context).brightness == Brightness.dark,
      );
    });
    if (widget.transaction.brandDomain.isEmpty) {
      return;
    }

    final fetchedLogoUrl = logoService.getLogoUrl(
      widget.transaction.brandDomain,
    );
    setState(() {
      isLogoFromNetwork = true;
      logoUrl = fetchedLogoUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionProcessedName = widget.transaction.name.length > 35
        ? "${widget.transaction.name.replaceAll("\n", " ").substring(0, 35)}..."
        : widget.transaction.name.replaceAll("\n", " ");

    final logoService = getIt<LogoService>();

    final transactionCategoryWidgets = SpendingCategoryUtil.getAllCategories()
        .where((category) => category != "Not Idenfiable")
        .map<Widget>((category) {
          final categoryData = SpendingCategoryUtil.categoryData[category];
          if (categoryData == null) return const SizedBox.shrink();

          final Color color = Color(
            int.parse(
              (categoryData['color'] as String?)?.replaceFirst('#', '0xff') ??
                  '0xffE91E63',
            ),
          );

          return FlowButton(
            onPressed: () {
              if (selectedCategory == category) return;
              if (category == widget.transaction.category) {
                setState(() => selectedCategory = category);
                _sheetController?.close();
                _sheetController = null;
                return;
              }

              setState(() => selectedCategory = category);
              _sheetController?.close();
              _sheetController = null;
              _showConfirmSheet(category); // uses ScaffoldState via key
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 18.0,
                horizontal: 24.0,
              ),
              child: Row(
                children: [
                  Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      logoService.getCategoryIcon(
                        category,
                        Theme.of(context).brightness == Brightness.dark,
                      ),
                    ),
                  ),

                  const FlowSeparatorBox(width: 16),
                  Text(
                    category,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  if (selectedCategory == category)
                    Icon(Icons.check, color: Theme.of(context).primaryColor),
                ],
              ),
            ),
          );
        })
        .toList();

    return Scaffold(
      key: _scaffoldKey, // <-- attach key
      body: FlowSafeArea(
        backgroundColor: Theme.of(context).cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const FlowTopBar(title: Text(""), showBackButton: true),

            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
              child: Text(
                "Select new category",
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
              child: Row(
                children: [
                  isLogoFromNetwork
                      ? Image.network(logoUrl, height: 50, width: 50)
                      : Image.asset(logoUrl, height: 50, width: 50),
                  const FlowSeparatorBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.transaction.amount < 0
                            ? "-\$${widget.transaction.amount.abs().toStringAsFixed(2)}"
                            : "+\$${widget.transaction.amount.abs().toStringAsFixed(2)}",
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: widget.transaction.amount > 0
                                  ? const Color(0xFF4CAF50)
                                  : Theme.of(
                                      context,
                                    ).textTheme.labelMedium?.color,
                            ),
                      ),
                      Text(
                        transactionProcessedName,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.color
                                  ?.withValues(alpha: 1),
                            ),
                      ),
                      Text(
                        DateTimeUtil.getFormattedDate(widget.transaction.date),
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: Theme.of(
                                context,
                              ).textTheme.labelMedium?.color?.withAlpha(150),
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Container(
              height: 12,
              color: Theme.of(context).brightness == Brightness.light
                  ? Theme.of(context).canvasColor
                  : const Color(0xFF303030),
            ),

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 24),
                itemCount: transactionCategoryWidgets.length,
                itemBuilder: (context, index) =>
                    transactionCategoryWidgets[index],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
