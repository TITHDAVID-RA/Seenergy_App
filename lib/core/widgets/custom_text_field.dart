import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Reusable form text field with custom label, icon, and styling.
class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: AppColors.textLabel,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onChanged: onChanged,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
            ),
            prefixIcon: Icon(prefixIcon, color: AppColors.iconMuted, size: 20),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}

