import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/models/product.dart';

class ProductInfoSection extends StatelessWidget {
  final Product product;
  final ThemeData theme;

  const ProductInfoSection({
    super.key,
    required this.product,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                Get.locale?.languageCode == 'ar' &&
                        product.arabicName.isNotEmpty
                    ? product.arabicName
                    : product.name,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 5),
            Text(
              '${product.rating} (${product.reviewsCount} ${'reviews'.tr})',
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
            const Spacer(),
            Text(
              product.stock > 0 ? 'available'.tr : 'notAvailable'.tr,
              style: TextStyle(
                color: product.stock > 0 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
