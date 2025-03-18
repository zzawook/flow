import 'package:flow_mobile/flow_app.dart';
import 'utils/secure_storage.dart';
import 'utils/secure_hive.dart';
import 'package:flutter/material.dart';

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

  runApp(const FlowApplication());
}

class FlowApplication extends StatelessWidget {
  const FlowApplication({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      title: 'Flow',
      builder: (context, child) => FlowApp(),
      color: const Color(0xFFFFFFFF),
    );
  }
}
