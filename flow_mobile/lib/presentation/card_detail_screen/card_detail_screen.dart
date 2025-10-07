import 'package:flow_mobile/domain/entity/card.dart' as BankCard;
import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/thunks/card_thunks.dart';
import 'package:flow_mobile/initialization/manager_registry.dart';
import 'package:flow_mobile/presentation/account_detail_screen/account_transaction_list.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flow_mobile/service/logo_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CardDetailScreen extends StatefulWidget {
  final BankCard.Card card;

  const CardDetailScreen({super.key, required this.card});

  @override
  State<CardDetailScreen> createState() => _CardDetailScreenState();
}

class _CardDetailScreenState extends State<CardDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  bool isLoadingMore = false;
  bool hasMore = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store = StoreProvider.of<FlowState>(context);
      store.dispatch(getCardTransactionsThunk(card: widget.card, limit: 20));
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final delta = 200; // Trigger 200px before bottom

    if (currentScroll >= (maxScroll - delta)) {
      _loadMoreTransactions();
    }
  }

  void _loadMoreTransactions() {
    final store = StoreProvider.of<FlowState>(context);

    // Don't load if already loading or no more data
    if (isLoadingMore || hasMore) {
      return;
    }

    final List<Transaction> transactions = store.state.transactionState
        .getTransactionsByCard(widget.card);

    String oldestId = '';

    // Get oldest transaction (transactions are sorted by date desc in TransactionList)
    if (transactions.isNotEmpty) {
      final sorted = [...transactions]
        ..sort((a, b) => b.date.compareTo(a.date));
      oldestId = sorted.last.id.toString();
    }

    store.dispatch(
      getCardTransactionsThunk(
        card: widget.card,
        oldestTransactionId: oldestId.isEmpty ? null : oldestId,
        limit: 20,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlowSafeArea(
      backgroundColor: Theme.of(context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FlowTopBar(
            title: Text(
              widget.card.cardName,
              style: Theme.of(context).textTheme.titleSmall,
              textAlign: TextAlign.center,
            ),
            showBackButton: true,
          ),

          BalanceSection(card: widget.card),

          Container(
            height: 12,
            color: Theme.of(context).brightness == Brightness.light
                ? Theme.of(context).canvasColor
                : const Color(0xFF303030),
          ),

          Expanded(
            child: StoreConnector<FlowState, CardDetailViewModel>(
              converter: (store) => CardDetailViewModel(
                transactions: store.state.transactionState
                    .getTransactionsByCard(widget.card),
                isLoadingMore: store
                    .state
                    .screenState
                    .accountDetailScreenState
                    .isLoadingMore,
              ),
              builder: (_, viewModel) {
                return AccountTransactionList(
                  transactions: viewModel.transactions,
                  scrollController: _scrollController,
                  isLoadingMore: viewModel.isLoadingMore,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CardDetailViewModel {
  final List<Transaction> transactions;
  final bool isLoadingMore;

  CardDetailViewModel({
    required this.transactions,
    required this.isLoadingMore,
  });
}

class BalanceSection extends StatelessWidget {
  final BankCard.Card card;
  const BalanceSection({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    final logoService = getIt<LogoService>();

    return Container(
      padding: const EdgeInsets.only(top: 48, left: 24, right: 24, bottom: 32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${card.bank.name} ${card.cardNumber}",
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
                const FlowSeparatorBox(height: 12),
                Text(
                  '\$ ${card.balance.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Image.asset(
              logoService.getBankLogoUri(card.bank),
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
