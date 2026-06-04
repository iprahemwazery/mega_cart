import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressInputField extends StatelessWidget {
  final Function(String) onChanged;
  const AddressInputField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'shippingAddressHint'.tr,
        prefixIcon: const Icon(Icons.location_on_outlined),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
      ),
    );
  }
}
