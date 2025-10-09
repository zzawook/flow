import 'package:flow_mobile/domain/redux/flow_state.dart';
import 'package:flow_mobile/domain/redux/states/auth_state.dart';
import 'package:flow_mobile/domain/redux/thunks/user_thunks.dart';
import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flow_mobile/presentation/shared/flow_cta_button.dart';
import 'package:flow_mobile/presentation/shared/flow_safe_area.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';
import 'package:flow_mobile/presentation/shared/flow_top_bar.dart';
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
  bool isGenderSelected = false;
  bool isSelectedGenderMale = false;

  DateTime selectedDate = DateTime.now();

  void _onNext() {
    if (!isGenderSelected || selectedDate == DateTime.now()) {
      return;
    }
    StoreProvider.of<FlowState>(
      context,
    ).dispatch(setConstantUserFieldsThunk(selectedDate, isSelectedGenderMale));
  }

  @override
  Widget build(BuildContext context) {
    final selectedTileColor = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).primaryColor.withAlpha(150)
        : Theme.of(context).primaryColorLight.withAlpha(150);

    final unselectedMaleBorder = Colors.blue.shade100;
    final unselectedFemaleBorder = Colors.red.shade100;

    // Golden ratio constants
    const phi = 1.61803398875; // height = phi * width (we want height taller)
    const widthToHeight = 1 / phi; // width / height = ~0.618

    return FlowSafeArea(
      backgroundColor: Theme.of(context).canvasColor,
      child: Material(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FlowTopBar(
              title: const Center(child: Text('')),
              showBackButton: true,
            ),

            const FlowSeparatorBox(height: 36),

            // Guide messages
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: Text(
                "Just one last step",
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            const FlowSeparatorBox(height: 12),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: Text(
                "Tell us about yourself,\nWe'll personalize your financial analysis",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  // color: Theme.of(context).textTheme.bodyMedium?.color.withValues(),
                ),
              ),
            ),
            const FlowSeparatorBox(height: 36),

            // Gender section: initial golden ratio, then shrinks to 80 on selection
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // We have two tiles with a 12px gap between them.
                  const gap = 12.0;
                  final tileWidth = (constraints.maxWidth - gap) / 2;
                  // width / height = 0.618 -> height = width / 0.618
                  final initialHeight = tileWidth / widthToHeight;

                  final targetHeight = isGenderSelected ? 80.0 : initialHeight;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    height: targetHeight,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              // Male tile
                              Expanded(
                                child: FlowButton(
                                  onPressed: () {
                                    setState(() {
                                      isGenderSelected = true;
                                      isSelectedGenderMale = true;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    decoration: BoxDecoration(
                                      color:
                                          isGenderSelected &&
                                              isSelectedGenderMale
                                          ? selectedTileColor
                                          : Colors.transparent,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                      border: Border.all(
                                        color:
                                            isGenderSelected &&
                                                isSelectedGenderMale
                                            ? selectedTileColor
                                            : unselectedMaleBorder,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.male,
                                          color:
                                              isGenderSelected &&
                                                  isSelectedGenderMale
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary
                                              : null,
                                        ),
                                        Text(
                                          "Male",
                                          style: TextStyle(
                                            color:
                                                isGenderSelected &&
                                                    isSelectedGenderMale
                                                ? Theme.of(
                                                    context,
                                                  ).colorScheme.onPrimary
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const FlowSeparatorBox(width: gap),

                              // Female tile
                              Expanded(
                                child: FlowButton(
                                  onPressed: () {
                                    setState(() {
                                      isGenderSelected = true;
                                      isSelectedGenderMale = false;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    decoration: BoxDecoration(
                                      color:
                                          isGenderSelected &&
                                              !isSelectedGenderMale
                                          ? selectedTileColor
                                          : Colors.transparent,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                      border: Border.all(
                                        color:
                                            isGenderSelected &&
                                                !isSelectedGenderMale
                                            ? selectedTileColor
                                            : unselectedFemaleBorder,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.female,
                                          color:
                                              isGenderSelected &&
                                                  !isSelectedGenderMale
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.onPrimary
                                              : null,
                                        ),
                                        Text(
                                          "Female",
                                          style: TextStyle(
                                            color:
                                                isGenderSelected &&
                                                    !isSelectedGenderMale
                                                ? Theme.of(
                                                    context,
                                                  ).colorScheme.onPrimary
                                                : null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const FlowSeparatorBox(height: 36),

            // Birthday (only visible after gender selection)
            if (isGenderSelected) ...[
              const Padding(
                padding: EdgeInsets.only(left: 24, right: 24, bottom: 8),
                child: Text("Your birthday:"),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime.now(),
                    minimumDate: DateTime(1900),
                    maximumDate: DateTime(2100),
                    onDateTimeChanged: (dt) {
                      setState(() {
                        selectedDate = dt;
                      });
                    },
                  ),
                ),
              ),
            ],

            Expanded(child: SizedBox()),

            // CTA
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 36),
              child: StoreConnector<FlowState, AuthState>(
                converter: (store) => store.state.authState,
                builder: (context, authState) {
                  if (!isGenderSelected) {
                    return FlowCTAButton(
                      text: "Next",
                      color: Theme.of(context).disabledColor,
                      onPressed: () {},
                    );
                  }
                  return FlowCTAButton(
                    text: "Next",
                    onPressed: () {
                      _onNext();
                    },
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
