import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/utils/app_text_styles.dart';
import 'package:mega_cart/features/createProduct/controller/create_product_controller.dart';
import 'package:mega_cart/features/createProduct/widget/category_selection_section.dart';
import 'package:mega_cart/features/createProduct/widget/create_product_section.dart';
import 'package:mega_cart/features/createProduct/widget/create_product_submit_button.dart';
import 'package:mega_cart/features/createProduct/widget/create_product_text_field.dart';
import 'package:mega_cart/features/createProduct/widget/image_preview_widget.dart';
import 'package:mega_cart/features/createProduct/widget/picture_urls_section.dart';
import 'package:mega_cart/features/createProduct/widget/quick_actions_section.dart';

class CreateProductView extends StatelessWidget {
  CreateProductView({super.key});

  final CreateProductController controller = Get.put(CreateProductController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('createProductTitle'.tr),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        elevation: 0,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuickActionsSection(controller: controller),
            const SizedBox(height: 24),
            CreateProductSection(
              title: 'createProductTitle'.tr,
              children: [
                CreateProductTextField(
                  controller: controller.nameController,
                  label: 'productNameLabel'.tr,
                  hint: 'productNameHintEnglish'.tr,
                ),
                const SizedBox(height: 16),
                CreateProductTextField(
                  controller: controller.nameArabicController,
                  label: 'productNameLabelArabic'.tr,
                  hint: 'productNameHintArabic'.tr,
                ),
                const SizedBox(height: 16),
                CreateProductTextField(
                  controller: controller.descriptionController,
                  label: 'descriptionLabel'.tr,
                  hint: 'descriptionHintEnglish'.tr,
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                CreateProductTextField(
                  controller: controller.descriptionArabicController,
                  label: 'descriptionLabelArabic'.tr,
                  hint: 'descriptionHintArabic'.tr,
                  maxLines: 3,
                ),
              ],
            ),
            CreateProductSection(
              title: 'priceLabel'.tr,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CreateProductTextField(
                        controller: controller.priceController,
                        label: 'priceLabel'.tr,
                        hint: '99.99',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CreateProductTextField(
                        controller: controller.discountController,
                        label: 'discountPercentageLabel'.tr,
                        hint: '5',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: CreateProductTextField(
                        controller: controller.stockController,
                        label: 'stockLabel'.tr,
                        hint: '100',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CreateProductTextField(
                        controller: controller.weightController,
                        label: 'weightLabel'.tr,
                        hint: '1.5',
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CreateProductTextField(
                  controller: controller.colorController,
                  label: 'colorLabel'.tr,
                  hint: 'colorHint'.tr,
                ),
              ],
            ),
            CreateProductSection(
              title: 'mainImageUrlLabel'.tr,
              children: [
                CreateProductTextField(
                  controller: controller.coverPictureUrlController,
                  label: 'mainImageUrlLabel'.tr,
                  hint: 'https://example.com/image.jpg',
                ),
                ImagePreviewWidget(
                  controller: controller.coverPictureUrlController,
                ),
              ],
            ),
            CreateProductSection(
              title: 'productCategoriesTitle'.tr,
              children: [CategorySelectionSection(controller: controller)],
            ),
            CreateProductSection(
              title: 'additionalImageUrlsTitle'.tr,
              children: [PictureUrlsSection(controller: controller)],
            ),
            CreateProductSection(
              title: 'authenticationInfoTitle'.tr,
              children: [
                CreateProductTextField(
                  controller: controller.tokenController,
                  label: 'tokenLabelOptional'.tr,
                  hint: 'tokenHint'.tr,
                ),
                const SizedBox(height: 16),
                CreateProductTextField(
                  controller: controller.sellerIdController,
                  label: 'sellerIdLabelRequired'.tr,
                  hint: '3fa85f64-5717-4562-b3fc-2c963f66afa6',
                ),
                const SizedBox(height: 8),
                Text(
                  'sellerIdRequiredMessage'.tr,
                  style: AppTextStyles.hint.copyWith(color: theme.hintColor),
                ),
              ],
            ),
            const SizedBox(height: 24),
            CreateProductSubmitButton(controller: controller),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
