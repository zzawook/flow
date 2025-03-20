import 'package:flow_mobile/presentation/trsansfer_screen/transfer_top_bar.dart';
import 'package:flutter/widgets.dart';

class TransferToScreen extends StatefulWidget {
  const TransferToScreen({super.key});

  @override
  _TransferToScreenState createState() => _TransferToScreenState();
}

class _TransferToScreenState extends State<TransferToScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5), // Background color
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 72.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [TransferTopBar(previousScreenRoute: "/transfer/amount")],
        ),
      ),
    );
  }
}
