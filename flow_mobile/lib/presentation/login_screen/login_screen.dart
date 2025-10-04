import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/thunks/auth_thunks.dart';
import 'package:flow_mobile/presentation/navigation/app_routes.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flow_mobile/presentation/shared/flow_cta_button.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';
import 'package:flow_mobile/presentation/shared/flow_string_checker.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flow_mobile/presentation/transfer_screen/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class LoginEmailScreen extends StatefulWidget {
  const LoginEmailScreen({super.key});

  @override
  State<LoginEmailScreen> createState() => _LoginEmailScreenState();
}

class _LoginEmailScreenState extends State<LoginEmailScreen> {
  final bool _isLoading = false;
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _usernameFocus = FocusNode();

  var message = '';

  void _onNext() {
    if (_usernameController.text.isEmpty) {
      setState(() {
        message = 'Email cannot be empty';
      });
      return;
    }
    var emailMessage = FlowStringChecker.isValidEmail(_usernameController.text);
    if (!emailMessage) {
      setState(() {
        message = "Sorry, that doesn't look like a valid email";
      });
      return;
    }
    StoreProvider.of<FlowState>(
      context,
      listen: false,
    ).dispatch(setLoginEmailThunk(_usernameController.text));
  }

  void _onSignUp() {
    Navigator.of(context).pushNamed(AppRoutes.signupPassword);
  }

  @override
  Widget build(BuildContext context) {
    return FlowSafeArea(
      backgroundColor: Theme.of(context).canvasColor,
      child: Material(
        child: Padding(
          padding: const EdgeInsets.only(left: 18, right: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FlowTopBar(title: Center(child: Text(''))),
              FlowSeparatorBox(height: 50),
              Text(
                "What's your Email?",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  message,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 14,
                  ),
                ),
              ),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  child: EditableTextWidget(
                    controller: _usernameController,
                    focusNode: _usernameFocus,
                    hintText: 'Email',
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              FlowCTAButton(
                text: "Next",
                onPressed: () {
                  _onNext();
                },
              ),
              FlowSeparatorBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlowButton(
                    onPressed: _onSignUp,
                    child: Text(
                      "I lost my account",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
    );
  }
}
