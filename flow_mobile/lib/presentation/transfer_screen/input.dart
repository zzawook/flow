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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
      child: Form(
        key: _formKey,
        child: Material(
          child: TextFormField(
            autofocus: true,
            style: const TextStyle(
              color: Color(0xFF000000),
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 2,
            ),
            decoration: InputDecoration(
              labelText: widget.labelText,
              labelStyle: const TextStyle(
                color: Color(0xFFC8C8C8),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              floatingLabelStyle: const TextStyle(
                color: Color(0xFF50C878),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: const Color(0xFF50C878)),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: const Color(0xFF50C878)),
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
