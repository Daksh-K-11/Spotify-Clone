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
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      validator: (val) {
        if (val!.trim().isEmpty) {
          return '$hintText is missing!';
        }
        return null;
      },
      obscureText: isObscureText,
    );
  }
}
