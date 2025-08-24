import 'package:flow_mobile/domain/redux/actions/auth_action.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/initialization/manager_registry.dart';
import 'package:flow_mobile/presentation/navigation/app_routes.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flow_mobile/presentation/shared/flow_cta_button.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';
import 'package:flow_mobile/presentation/shared/flow_string_checker.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flow_mobile/presentation/transfer_screen/input.dart';
import 'package:flow_mobile/service/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SignupPasswordScreen extends StatefulWidget {
  const SignupPasswordScreen({super.key});

  @override
  State<SignupPasswordScreen> createState() => _SignupPasswordScreenState();
}

class _SignupPasswordScreenState extends State<SignupPasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final bool _isPasswordShown = false;
  String message = '';

  void _onNext(String email) {
    if (_passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        message = 'Please fill in all fields';
      });
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        message = 'Passwords do not match';
      });
      return;
    }
    var passwordMessage = FlowStringChecker.isValidPassword(
      _passwordController.text,
    );
    if (passwordMessage.isNotEmpty) {
      setState(() {
        message = passwordMessage;
      });
      return;
    }

    StoreProvider.of<FlowState>(
      context,
      listen: false,
    ).dispatch(SetSignupPasswordAction(password: _passwordController.text));
    final nav = getIt<NavigationService>();
    nav.pushNamed(AppRoutes.signupName);
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
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Text(
                        "Type in your password",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 8),
                      child: Text(
                        message,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    ),

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
                    FlowSeparatorBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: EditableTextWidget(
                        controller: _confirmPasswordController,
                        focusNode: _confirmPasswordFocus,
                        hintText: 'Confirm Password',
                        labelText: 'Confirm Password',
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
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: FlowCTAButton(
                        text: "Next",
                        onPressed: () {
                          if (_passwordController.text.isNotEmpty) {
                            _onNext(email);
                          }
                        },
                      ),
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
