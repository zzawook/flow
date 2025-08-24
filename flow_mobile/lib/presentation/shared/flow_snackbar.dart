import 'package:flutter/material.dart';

class FlowSnackbar extends StatelessWidget {
  final Widget content;
  final int duration;

  const FlowSnackbar({
    super.key,
    required this.content,
    required this.duration,
  });

  @override
  SnackBar build(BuildContext context) {
    return SnackBar(
      content: content,
      duration: Duration(seconds: duration),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: 48, left: 24, right: 24),
      padding: EdgeInsets.only(bottom: 16, top: 16, left: 24, right: 24),
      backgroundColor: Theme.of(context).primaryColor,
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }
}
