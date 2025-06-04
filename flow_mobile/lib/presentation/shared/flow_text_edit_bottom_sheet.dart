import 'package:flutter/material.dart';

class FlowTextEditBottomSheet extends StatelessWidget {
  final String title;
  final String initialValue;
  final String hintText;
  final String saveButtonText;
  final void Function(String) onSave;

  const FlowTextEditBottomSheet({
    super.key,
    required this.title,
    required this.initialValue,
    required this.hintText,
    required this.saveButtonText,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: initialValue);
    final primary = Theme.of(context).primaryColor;
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            autofocus: true,
            cursorColor: primary,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: primary.withAlpha(153)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primary),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primary, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                onSave(controller.text.trim());
                Navigator.pop(context);
              },
              child: Text(
                saveButtonText,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
