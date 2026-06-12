import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:mega_cart/features/createProduct/widget/add_product_form_section.dart';
import 'package:mega_cart/features/createProduct/widget/add_product_text_field.dart';

import 'package:uuid/uuid.dart'; // For GUID validation

class AddProductAuthenticationSection extends StatelessWidget {
  final TextEditingController sellerIdController;
  final TextEditingController tokenController;

  const AddProductAuthenticationSection({
    super.key,
    required this.sellerIdController, // Make sellerId required
    required this.tokenController,
  });

  @override
  Widget build(BuildContext context) {
    return AddProductFormSection(
      title: 'معلومات المصادقة',
      children: [
        AddProductTextField(
          controller: sellerIdController,
          labelText: 'معرف البائع (Seller ID) - اختياري',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'enterSellerIdError'.tr; // Using translation key
            }
            try {
              Uuid.parse(value);
            } catch (_) {
              return 'invalidSellerIdFormatError'.tr; // Using translation key
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AddProductTextField(
          controller: tokenController,
          labelText: 'Token (اختياري)', // This token is for the API service
        ),
      ],
    );
  }
}
