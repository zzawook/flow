import 'package:flow_mobile/domain/redux/app_state.dart';
import 'package:flow_mobile/domain/redux/reducers.dart';
import 'package:flow_mobile/flow_app.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'data/source/local_secure_storage.dart';
import 'data/source/local_secure_hive.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

void main() async {
  SecureStorage.init();
  await SecureHive.initHive();

  // You can store accounts using unique keys.
  await SecureHive.saveData('accounts', [
    {'bankName': 'DBS', 'accountType': 'Savings account'},
    {'bankName': 'UOB', 'accountType': 'Savings account'},
    {'bankName': 'Maybank', 'accountType': 'Savings account'},
  ]);

  await SecureHive.saveData('monthlyBalance', {
    'income': 4300.00,
    'card': 732.12,
    'transfer': 1000.00,
    'other': 1002.23,
  });

  runApp(FlowApplication());
}

class FlowApplication extends StatelessWidget {
  FlowApplication({super.key});

  final Store<FlowState> store = Store<FlowState>(
    flowReducer,
    initialState: FlowState.initial(),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StoreProvider<FlowState>(
      store: store,
      child: WidgetsApp(
        title: 'Flow',
        builder: (context, child) => FlowApp(),
        color: const Color(0xFFFFFFFF),
      ),
    );
  }
}
