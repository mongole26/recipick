import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class RecipickInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  final bool autofocus;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextStyle? style;

  const RecipickInput({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.keyboardType,
    this.autofocus = false,
    this.prefixIcon,
    this.suffixIcon,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      autofocus: autofocus,
      style: style ?? const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: kInputFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadiusInput),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadiusInput),
          borderSide: const BorderSide(color: kPrimaryColor, width: 1.5),
        ),
      ),
    );
  }
}
