import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/auth_state.dart';
import 'package:flow_mobile/domain/redux/thunks/auth_thunks.dart';
import 'package:flow_mobile/presentation/shared/flow_cta_button.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
import 'package:flow_mobile/presentation/transfer_screen/input.dart';
import 'package:flow_mobile/utils/date_time_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class SignupDateOfBirthScreen extends StatefulWidget {
  const SignupDateOfBirthScreen({super.key});

  @override
  State<SignupDateOfBirthScreen> createState() =>
      _SignupDateOfBirthScreenState();
}

class _SignupDateOfBirthScreenState extends State<SignupDateOfBirthScreen> {
  DateTime selectedDate = DateTime.now();

  void _onNext(String email, String password, String name) {
    // Dispatch the action to save the date of birth
    StoreProvider.of<FlowState>(
      context,
      listen: false,
    ).dispatch(signupThunk(email, password, name, selectedDate));
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
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  "When's your birthday?",
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ),
              FlowSeparatorBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(
                  "Let us celebrate together!",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date, // .time, .dateAndTime
                    initialDateTime: DateTime.now(),
                    minimumDate: DateTime(2000),
                    maximumDate: DateTime(2100),
                    onDateTimeChanged: (dt) {
                      setState(() {
                        selectedDate = dt;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: StoreConnector<FlowState, AuthState>(
                  converter: (store) => store.state.authState,
                  builder: (context, authState) {
                    return FlowCTAButton(
                      text: "Next",
                      onPressed: () {
                        _onNext(
                          authState.loginEmail ?? '',
                          authState.signupPassword ?? '',
                          authState.signupName ?? '',
                        );
                      },
                    );
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
