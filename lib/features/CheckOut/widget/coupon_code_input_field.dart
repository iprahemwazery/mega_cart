import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CouponCodeInputField extends StatelessWidget {
  final Function(String) onChanged;
  const CouponCodeInputField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'couponCodeHint'.tr,
        prefixIcon: const Icon(Icons.confirmation_number_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
      ),
    );
  }
}
