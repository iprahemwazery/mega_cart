import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:mega_cart/features/addProduct/presentation/widget/add_product_form_section.dart';
import 'package:mega_cart/features/addProduct/presentation/widget/add_product_text_field.dart';

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
            final uuidRegex = RegExp(
              r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
            );
            if (!uuidRegex.hasMatch(value)) {
              return 'invalidSellerIdFormatError'.tr;
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
