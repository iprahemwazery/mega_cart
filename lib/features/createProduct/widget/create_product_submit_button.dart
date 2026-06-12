import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/utils/app_text_styles.dart';
import 'package:mega_cart/features/createProduct/controller/create_product_controller.dart';

class CreateProductSubmitButton extends StatelessWidget {
  final CreateProductController controller;

  const CreateProductSubmitButton({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: theme.colorScheme.onSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: controller.isLoading.value
              ? null
              : () => controller.createProduct(),
          child: controller.isLoading.value
              ? const CircularProgressIndicator(color: Colors.white)
              : Text('createProductButton'.tr, style: AppTextStyles.button),
        ),
      );
    });
  }
}
