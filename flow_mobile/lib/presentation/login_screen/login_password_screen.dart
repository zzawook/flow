import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/thunks/auth_thunks.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flow_mobile/presentation/shared/flow_cta_button.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flow_mobile/presentation/transfer_screen/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class LoginPasswordScreen extends StatefulWidget {
  const LoginPasswordScreen({super.key});

  @override
  State<LoginPasswordScreen> createState() => _LoginPasswordScreenState();
}

class _LoginPasswordScreenState extends State<LoginPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();

  final bool _isPasswordShown = false;

  void _onNext(String email) {
    StoreProvider.of<FlowState>(
      context,
      listen: false,
    ).dispatch(loginThunk(email, _passwordController.text));
  }

  @override
  Widget build(BuildContext context) {
    return FlowSafeArea(
      backgroundColor: Theme.of(context).canvasColor,
      child: Material(
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0),
          child: StoreConnector<FlowState, String>(
            converter: (store) => store.state.authState.loginEmail ?? '',
            builder:
                (context, email) => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FlowTopBar(title: Text(''), showBackButton: true),
                    FlowSeparatorBox(height: 50),
                    Text(
                      "Type in your password",
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    FlowSeparatorBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: EditableTextWidget(
                        controller: _passwordController,
                        focusNode: _passwordFocus,
                        hintText: 'Password',
                        labelText: 'Password',
                        obscureText: !_isPasswordShown,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Your email: $email",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(200),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    FlowSeparatorBox(height: 30),
                    FlowCTAButton(
                      text: "Next",
                      onPressed: () {
                        if (_passwordController.text.isNotEmpty) {
                          _onNext(email);
                        }
                      },
                    ),
                    FlowSeparatorBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlowButton(
                          onPressed: () {},
                          child: Text(
                            "I lost my account",
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withAlpha(200),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
          ),
        ),
      ),
    );
  }
}
