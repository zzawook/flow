import 'dart:async';
import 'package:flow_mobile/domain/entity/transaction.dart';
import 'package:flow_mobile/domain/manager/transaction_manager.dart';
import 'package:flow_mobile/domain/redux/actions/transaction_action.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

import '../../domain/redux/flow_state.dart';

class UnprocessedTxnPoller with WidgetsBindingObserver {
  final Store<FlowState> store;
  final Duration interval;
  Timer? _timer;
  bool _inFlight = false;
  TransactionManager transactionManager = getIt<TransactionManager>();

  UnprocessedTxnPoller(
    this.store, {
    this.interval = const Duration(seconds: 5),
  });

  void start() {
    if (_timer != null) return; // already running
    WidgetsBinding.instance.addObserver(this);
    _timer = Timer.periodic(interval, (_) => _tick());
    _tick(); // optional: run once immediately
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    WidgetsBinding.instance.removeObserver(this);
  }

  Future<void> _tick() async {
    if (_inFlight) return;
    _inFlight = true;
    try {
      List<Transaction> processedTransactions = await transactionManager
          .fetchProcessedTransactionFromRemote();
      print(processedTransactions);
      if (processedTransactions.isEmpty) return;
      store.dispatch(AddTransaction(processedTransactions));
    } finally {
      _inFlight = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_timer == null) start();
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      stop();
    }
  }
}
