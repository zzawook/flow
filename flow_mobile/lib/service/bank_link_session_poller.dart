import 'dart:async';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/thunks/link_thunks.dart';
import 'package:flutter/widgets.dart';
import 'package:redux/redux.dart';

class BankLinkSessionPoller with WidgetsBindingObserver {
  final Store<FlowState> store;
  final Duration interval;

  Timer? _timer;
  bool _inFlight = false;
  bool _listening = false;

  BankLinkSessionPoller(
    this.store, {
    this.interval = const Duration(seconds: 2),
  });

  /// Call once to start observing lifecycle + start timer.
  void start() {
    // Subscribe once; keep listening across background/foreground transitions.
    if (!_listening) {
      WidgetsBinding.instance.addObserver(this);
      _listening = true;
    }
    _startTimerIfNeeded();
    _tick(); // optional immediate kick
  }

  /// Stop only the timer (keep lifecycle observer so we can see 'resumed').
  void _stop() {
    _timer?.cancel();
    _timer = null;
  }

  void _startTimerIfNeeded() {
    _timer ??= Timer.periodic(interval, (_) => _tick());
  }

  /// Fully tear down (timer + lifecycle observer). Use on app exit/widget dispose.
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
      final banksOnLink =
          store.state.screenState.refreshScreenState.banksOnLink;
      if (banksOnLink.isEmpty) return;

      // Poll each bank’s link status
      for (final bank in banksOnLink) {
        await store.dispatch(queryBankLinkStatus(bank));
      }
    } finally {
      _inFlight = false;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startTimerIfNeeded();
      _tick(); // catch up immediately on resume
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _stop(); // keep observer so we'll receive 'resumed'
    }
    // Usually no action needed on 'inactive'
  }
}
