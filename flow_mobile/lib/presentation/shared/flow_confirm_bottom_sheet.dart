import 'package:flow_mobile/presentation/shared/flow_button.dart';
import 'package:flow_mobile/presentation/shared/flow_separator_box.dart';
import 'package:flutter/material.dart';

/// Pure content (not a bottom sheet by itself).
class FlowConfirmBottomSheet extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final bool destructive; // styles the confirm button as destructive
  final VoidCallback? onConfirm; // optional: extra side effects before pop
  final VoidCallback? onCancel; // optional: extra side effects before pop
  final Color? confirmColor;
  final Color? cancelColor;
  final Color? confirmTextColor;
  final bool showCancelButton;

  const FlowConfirmBottomSheet({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.destructive = false,
    this.onConfirm,
    this.onCancel,
    this.confirmColor,
    this.confirmTextColor,
    this.cancelColor,
    this.showCancelButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final destructiveBg = Colors.grey;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24, // safe padding
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          Text(message, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 12),

          // Buttons: Cancel (outlined) + Confirm (filled)
          Column(
            children: [
              if (showCancelButton)
                FlowButton(
                  onPressed: onCancel,
                  child: Container(
                    height: 64,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: destructiveBg,
                    ),

                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        cancelText,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color:
                              cancelColor ?? theme.textTheme.bodyLarge?.color,
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              FlowButton(
                onPressed: onConfirm,
                child: Container(
                  height: 64,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: confirmColor ?? theme.primaryColor,
                  ),

                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      confirmText,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color:
                            confirmTextColor ??
                            theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          FlowSeparatorBox(height: 48),
        ],
      ),
    );
  }
}
