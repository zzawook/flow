import 'package:flow_mobile/domain/entity/bank_account.dart';
import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/bank_account_state.dart';
import 'package:flow_mobile/domain/redux/thunks/account_thunks.dart';
import 'package:flow_mobile/presentation/account_detail_screen/account_transaction_list.dart';
import 'package:flow_mobile/presentation/navigation/custom_page_route_arguments.dart';
import 'package:flow_mobile/presentation/navigation/transition_type.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';
import 'package:flow_mobile/presentation/shared/flow_snackbar.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

class BankAccountDetailScreen extends StatefulWidget {
  final BankAccount bankAccount;
  const BankAccountDetailScreen({super.key, required this.bankAccount});

  @override
  State<BankAccountDetailScreen> createState() =>
      _BankAccountDetailScreenState();
}

class _BankAccountDetailScreenState extends State<BankAccountDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Add scroll listener for infinite scroll
    _scrollController.addListener(_onScroll);

    // Fetch initial transactions after frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final store = StoreProvider.of<FlowState>(context);
      store.dispatch(
        getAccountTransactionsThunk(account: widget.bankAccount, limit: 20),
      );
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
    final accountDetailState = store.state.screenState.accountDetailScreenState;

    // Don't load if already loading or no more data
    if (accountDetailState.isLoadingMore || !accountDetailState.hasMore) {
      return;
    }

    // Only load for the current account
    if (accountDetailState.currentAccountNumber != null &&
        accountDetailState.currentAccountNumber !=
            widget.bankAccount.accountNumber) {
      return;
    }

    final transactions = store.state.transactionState.getTransactionsByAccount(
      widget.bankAccount,
    );

    if (transactions.isEmpty) return;

    // Get oldest transaction (transactions are sorted by date desc in TransactionList)
    final sorted = [...transactions]..sort((a, b) => b.date.compareTo(a.date));
    final oldestId = sorted.last.id.toString();

    store.dispatch(
      getAccountTransactionsThunk(
        account: widget.bankAccount,
        oldestTransactionId: oldestId,
        limit: 20,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlowSafeArea(
        backgroundColor: Theme.of(context).cardColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── custom top bar ───────────────────────────────────────────────
            FlowTopBar(
              title: StoreConnector<FlowState, String>(
                converter: (store) {
                  BankAccountState bankAccountState =
                      store.state.bankAccountState;
                  for (var bankAccount in bankAccountState.bankAccounts) {
                    if (bankAccount.isEqualTo(widget.bankAccount)) {
                      return bankAccount.accountName;
                    }
                  }
                  return widget.bankAccount.accountName;
                },
                builder: (_, accountName) {
                  return Text(
                    accountName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  );
                },
              ),
              leftWidget: FlowButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    "/bank_account/setting",
                    arguments: CustomPageRouteArguments(
                      transitionType: TransitionType.slideRight,
                      extraData: widget.bankAccount,
                    ),
                  );
                },
                child: SizedBox(
                  width: 25,
                  child: Icon(
                    Icons.settings_outlined,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ),

            // ── balance & copy-to-clipboard section ─────────────────────────
            BalanceSection(bankAccount: widget.bankAccount),

            // thin grey divider
            Container(
              height: 12,
              color: Theme.of(context).brightness == Brightness.light
                  ? Theme.of(context).canvasColor
                  : const Color(0xFF303030),
            ),

            // ── transactions list (scrollable) ──────────────────────────────
            Expanded(
              child: StoreConnector<FlowState, AccountDetailViewModel>(
                converter: (store) => AccountDetailViewModel(
                  transactions: store.state.transactionState
                      .getTransactionsByAccount(widget.bankAccount),
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
      ),
    );
  }
}

class AccountDetailViewModel {
  final List<Transaction> transactions;
  final bool isLoadingMore;

  AccountDetailViewModel({
    required this.transactions,
    required this.isLoadingMore,
  });
}

class BalanceSection extends StatelessWidget {
  final BankAccount bankAccount;
  const BalanceSection({super.key, required this.bankAccount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 48, left: 24, right: 24, bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              // Capture messenger & snackbar synchronously
              final messenger = ScaffoldMessenger.of(context);
              final snack = FlowSnackbar(
                content: const Text(
                  "Copied to clipboard",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.white,
                  ),
                ),
                duration: 2,
              ).build(context);

              // Now do the async, then show using the captured messenger
              Clipboard.setData(
                ClipboardData(
                  text: "${bankAccount.bank.name} ${bankAccount.accountNumber}",
                ),
              ).then((_) {
                messenger.showSnackBar(snack);
              });
            },
            child: Text(
              "${bankAccount.bank.name} ${bankAccount.accountNumber}",
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const FlowSeparatorBox(height: 12),
          Text(
            '\$ ${bankAccount.balance.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
