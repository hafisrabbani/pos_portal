import 'package:flutter/material.dart';
import 'package:pos_portal/utils/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final int maxLength;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.maxLength = 500, // Set default max length to 500
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.multiline,
      obscureText: obscureText,
      minLines: 2,
      maxLines: 10,
      maxLength: maxLength, // Set max length
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(),
        hintStyle: TextStyle(color: MyColors.neutral), // Mengatur warna hintText menjadi abu-abu
        labelStyle: TextStyle(color: MyColors.neutral), // Mengatur warna labelText menjadi abu-abu
      ),
    );
  }
}
