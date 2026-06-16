import 'package:flutter/material.dart';
import 'package:mega_cart/core/utils/app_text_styles.dart';

class CreateProductTextField extends StatelessWidget {
  // Keep original name
  final TextEditingController? controller; // Added controller
  final String label; // Keep original name
  final String hint; // Keep original name
  final TextInputType keyboardType;
  final int maxLines;
  final String? Function(String?)? validator; // Added validator

  const CreateProductTextField({
    super.key,
    this.controller, // Made optional
    required this.label,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.validator, // Optional
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Removed explicit Text widget for label, InputDecoration handles it
        TextFormField(
          // Changed to TextFormField to use validator
          controller: controller, // Linked controller
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(color: theme.colorScheme.onSurface),
          validator: validator, // Linked validator
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
            labelText: label, // Using label for InputDecoration
            labelStyle: AppTextStyles.titleMedium.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            hintText: hint,
            hintStyle: AppTextStyles.hint.copyWith(color: theme.hintColor),
            errorStyle: AppTextStyles.bodySmall.copyWith(
              color: theme.colorScheme.error,
            ), // Style for error text
            floatingLabelBehavior:
                FloatingLabelBehavior.always, // Keep label visible
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.all(12),
            errorBorder: OutlineInputBorder(
              // Style for error border
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.colorScheme.error, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
