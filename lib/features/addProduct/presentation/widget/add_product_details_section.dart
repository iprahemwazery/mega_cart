import 'package:flutter/material.dart';
import 'package:mega_cart/features/addProduct/presentation/widget/add_product_form_section.dart';
import 'package:mega_cart/features/addProduct/presentation/widget/add_product_text_field.dart';

class AddProductDetailsSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController nameArabicController;
  final TextEditingController descriptionArabicController;

  const AddProductDetailsSection({
    super.key,
    required this.nameController,
    required this.descriptionController,
    required this.nameArabicController,
    required this.descriptionArabicController,
  });

  @override
  Widget build(BuildContext context) {
    return AddProductFormSection(
      title: 'تفاصيل المنتج',
      children: [
        AddProductTextField(
          controller: nameController,
          labelText: 'اسم المنتج (إنجليزي)',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء إدخال اسم المنتج';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AddProductTextField(
          controller: descriptionController,
          labelText: 'وصف المنتج (إنجليزي)',
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'الرجاء إدخال وصف المنتج';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        AddProductTextField(
          controller: nameArabicController,
          labelText: 'اسم المنتج (عربي) - اختياري',
        ),
        const SizedBox(height: 16),
        AddProductTextField(
          controller: descriptionArabicController,
          labelText: 'وصف المنتج (عربي) - اختياري',
          maxLines: 3,
        ),
      ],
    );
  }
}
