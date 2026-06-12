import 'package:flutter/material.dart';
import 'package:mega_cart/features/createProduct/widget/add_product_form_section.dart';
import 'package:mega_cart/features/createProduct/widget/add_product_text_field.dart';
import 'package:mega_cart/features/createProduct/widget/image_preview_widget.dart';

class AddProductPriceImageSection extends StatelessWidget {
  final TextEditingController priceController;
  final TextEditingController coverImageUrlController;

  const AddProductPriceImageSection({
    super.key,
    required this.priceController,
    required this.coverImageUrlController,
  });

  @override
  Widget build(BuildContext context) {
    return AddProductFormSection(
      title: 'السعر والصورة',
      children: [
        AddProductTextField(
          controller: priceController,
          labelText: 'السعر',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء إدخال السعر';
            }
            if (double.tryParse(value) == null) {
              return 'الرجاء إدخال سعر صحيح';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AddProductTextField(
          controller: coverImageUrlController,
          labelText: 'رابط صورة الغلاف',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء إدخال رابط صورة الغلاف';
            }
            // Basic URL validation
            final Uri? uri = Uri.tryParse(value);
            if (uri == null ||
                !uri.isAbsolute ||
                !uri.hasScheme ||
                !uri.hasAuthority) {
              return 'الرجاء إدخال رابط صحيح';
            }
            return null;
          },
        ),
        ImagePreviewWidget(controller: coverImageUrlController),
      ],
    );
  }
}
