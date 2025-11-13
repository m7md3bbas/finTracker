import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    this.validator,
    this.radius = 10,
    this.keyboardType,
    this.obscureText = false,
    this.expands,
    required this.hintText,
    this.suffixIcon,
    this.prefix,
    this.maxLines,
    this.minLines,
    this.labelText,
  });
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final double radius;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool? expands;
  final String hintText;
  final Widget? suffixIcon;
  final Widget? prefix;
  final int? maxLines;
  final int? minLines;
  final String? labelText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      keyboardType: keyboardType,
      maxLines: obscureText ? 1 : maxLines,
      minLines: minLines,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        prefix: prefix,
        labelText: labelText,
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
