import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/utils/app_text_styles.dart';
import 'package:mega_cart/features/createProduct/controller/create_product_controller.dart';

class QuickActionsSection extends StatelessWidget {
  final CreateProductController controller;

  const QuickActionsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'quickActionsTitle'.tr,
          style: AppTextStyles.titleMedium.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => controller.fillWithSampleData(),
                icon: const Icon(Icons.auto_awesome),
                label: Text('fillFieldsOnlyButton'.tr),
                style: OutlinedButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  side: BorderSide(color: theme.colorScheme.outline),
                  backgroundColor: theme.colorScheme.surface,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => controller.fillAndSubmitSample(),
                icon: const Icon(Icons.send),
                label: Text('fillAndSubmitProductButton'.tr),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'quickActionsDescription'.tr,
          style: AppTextStyles.bodySmall.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
