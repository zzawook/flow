import 'dart:async';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/thunks/auth_thunks.dart';
import 'package:flow_mobile/presentation/shared/flow_cta_button.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class EmailValidationScreen extends StatefulWidget {
  final bool showBackButton;
  const EmailValidationScreen({super.key, this.showBackButton = false});

  @override
  State<EmailValidationScreen> createState() => _EmailValidationScreenState();
}

class _EmailValidationScreenState extends State<EmailValidationScreen>
    with WidgetsBindingObserver {
  int resendCooldown = 180; // seconds
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Register for app lifecycle callbacks
    WidgetsBinding.instance.addObserver(this);

    // Cooldown ticker
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (resendCooldown <= 0) {
        timer.cancel();
      } else {
        setState(() => resendCooldown--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    // Unregister lifecycle observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      // App returned to foreground: re-check verification
      final store = StoreProvider.of<FlowState>(context, listen: true);
      store.dispatch(monitorEmailVerifiedThunk());
    }
  }

  void _onResendEmail(BuildContext context) {
    if (resendCooldown > 0) return;
    final store = StoreProvider.of<FlowState>(context, listen: false);
    store.dispatch(sendVerificationEmailThunk());
    setState(() => resendCooldown = 180);
  }

  @override
  Widget build(BuildContext context) {
    return FlowSafeArea(
      backgroundColor: Theme.of(context).canvasColor,
      child: Material(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FlowTopBar(
                title: const Center(child: Text('')),
                showBackButton: widget.showBackButton,
              ),
              const FlowSeparatorBox(height: 50),
              Text(
                "Seems you're new here!",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const FlowSeparatorBox(height: 30),
              Text(
                "Check your email to verify your account.",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const FlowSeparatorBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: FlowCTAButton(
                      onPressed: () => _onResendEmail(context),
                      text: resendCooldown > 0
                          ? "Resend email in ${resendCooldown ~/ 60}:${(resendCooldown % 60).toString().padLeft(2, '0')}"
                          : "Resend email",
                      color: resendCooldown > 0
                          ? Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.12)
                          : Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
