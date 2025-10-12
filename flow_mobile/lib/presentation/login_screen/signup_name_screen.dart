import 'package:flow_mobile/domain/redux/actions/auth_action.dart';
import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/presentation/navigation/app_routes.dart';
import 'package:flow_mobile/presentation/shared/flow_cta_button.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flow_mobile/presentation/transfer_screen/input.dart';
import 'package:flow_mobile/service/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SignupNameScreen extends StatefulWidget {
  const SignupNameScreen({super.key});

  @override
  State<SignupNameScreen> createState() => _SignupNameScreenState();
}

class _SignupNameScreenState extends State<SignupNameScreen> {
  final TextEditingController _nameController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();

  String message = "";

  void _onNext() {
    if (_nameController.text.isEmpty) {
      setState(() {
        message = 'Please enter your name';
      });
      return;
    }
    // Dispatch the action to save the name
    StoreProvider.of<FlowState>(
      context,
      listen: false,
    ).dispatch(SetSignupNameAction(name: _nameController.text));
    final navService = getIt<NavigationService>();
    navService.pushNamed(AppRoutes.signupPassword);
  }

  @override
  Widget build(BuildContext context) {
    return FlowSafeArea(
      backgroundColor: Theme.of(context).canvasColor,
      child: Material(
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FlowTopBar(title: Center(child: Text('')), showBackButton: true),
              FlowSeparatorBox(height: 50),
              Padding(
                padding: EdgeInsetsGeometry.only(left: 10, right: 10),
                child: Text(
                  "Seems like you're new here!",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  "How should we call you?",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                child: Text(
                  message,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.red),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: EditableTextWidget(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  hintText: 'Name',
                  labelText: 'Name',
                  keyboardType: TextInputType.name,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: FlowCTAButton(
                  text: "Next",
                  onPressed: () {
                    _onNext();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
