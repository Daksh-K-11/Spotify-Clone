import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  const CustomField({
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    super.key,
  });

  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
      ),
      obscureText: isObscureText,
    );
  }
}
