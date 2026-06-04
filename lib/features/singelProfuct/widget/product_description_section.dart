import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/models/product.dart';

class ProductDescriptionSection extends StatelessWidget {
  final Product product;
  final ThemeData theme;

  const ProductDescriptionSection({
    super.key,
    required this.product,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'aboutProduct'.tr,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          Get.locale?.languageCode == 'ar' &&
                  product.arabicDescription.isNotEmpty
              ? product.arabicDescription
              : product.description,
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.5,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
