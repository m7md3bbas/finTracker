import 'package:flutter/material.dart';

class CustomTextfomfield extends StatelessWidget {
  const CustomTextfomfield({
    super.key,
    required this.controller,
    this.validator,
    this.radius = 10,
    this.keyboardType,
    this.obscureText = false,
    this.expands,
    required this.hintText,
    this.suffixIcon,
  });
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final double radius;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool? expands;
  final String hintText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(radius)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),

      expands: expands ?? false,
      obscureText: obscureText,
      controller: controller,
      validator: validator,
    );
  }
}
