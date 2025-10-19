import 'dart:async';
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
  final TransactionManager transactionManager = getIt<TransactionManager>();
  bool _listening = false;

  UnprocessedTxnPoller(
    this.store, {
    this.interval = const Duration(seconds: 5),
  });

  void start() {
    // Subscribe once; keep listening across background/foreground.
    if (!_listening) {
      WidgetsBinding.instance.addObserver(this);
      _listening = true;
    }
    _startTimerIfNeeded();
    _tick(); // optional: kick once immediately
  }

  void _startTimerIfNeeded() {
    _timer ??= Timer.periodic(interval, (_) => _tick());
  }

  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  /// Call when the poller is no longer needed (e.g., widget disposed/app exit).
  void dispose() {
    _stop();
    if (_listening) {
      WidgetsBinding.instance.removeObserver(this);
      _listening = false;
    }
  }

  Future<void> _tick() async {
    if (_inFlight) return;
    _inFlight = true;
    try {
      final processed = await transactionManager
          .fetchProcessedTransactionFromRemote();
      if (processed.isEmpty) return;
      store.dispatch(AddTransaction(processed));
    } finally {
      _inFlight = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startTimerIfNeeded();
      _tick();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _stop(); // keep observer; don't remove it here
    }
    // Generally you don't need to stop on 'inactive'
  }
}
