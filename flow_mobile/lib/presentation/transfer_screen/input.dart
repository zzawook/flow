import 'package:flutter/material.dart';

class EditableTextWidget extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final String labelText;
  const EditableTextWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.labelText,
  });

  @override
  State<EditableTextWidget> createState() => _EditableTextWidgetState();
}

class _EditableTextWidgetState extends State<EditableTextWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).primaryColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
      child: Form(
        key: _formKey,
        child: Material(
          child: TextFormField(
            autofocus: true,
            style: TextStyle(
              color: primary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 2,
            ),
            cursorColor: primary,
            decoration: InputDecoration(
              labelText: widget.labelText,
              labelStyle: TextStyle(
                color: primary.withOpacity(0.6),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              floatingLabelStyle: TextStyle(
                color: primary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: primary),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primary),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primary, width: 2),
              ),
              hintText: widget.hintText,
              hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black54
              ),
              filled: true,
              fillColor: const Color(0x00000000),
              contentPadding: EdgeInsets.zero,
            ),
            keyboardType: TextInputType.text,
          ),
        ),
      ),
    );
  }
}
