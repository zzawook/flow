import 'package:flow_mobile/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlowHorizontalDivider extends ConsumerWidget {
  const FlowHorizontalDivider({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    
    return Container(
      height: 1,
      decoration: BoxDecoration(
        border: Border.all(
          color:
              theme == "light" ? Colors.grey.shade400 : Color(0x88EDEDED),
          width: 1.0,
        ),
      ),
    );
  }
}