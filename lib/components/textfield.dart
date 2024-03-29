import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool readOnly;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.obscureText,
    required this.controller,
    required this.keyboardType,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: hintText,
      ),
      readOnly: readOnly,
      keyboardType: keyboardType,
      obscureText: obscureText,
    );
  }
}
