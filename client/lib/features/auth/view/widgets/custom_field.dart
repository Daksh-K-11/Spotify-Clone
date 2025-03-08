import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  const CustomField({required this.hintText,super.key});

  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }
}