import 'package:flutter/widgets.dart';

class FlowSeparatorBox extends StatelessWidget {
  final double height;
  final double width;

  const FlowSeparatorBox({super.key, this.height = 1, this.width = 1});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height, width: width);
  }
}
