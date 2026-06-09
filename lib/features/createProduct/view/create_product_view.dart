import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/utils/app_text_styles.dart';
import 'package:mega_cart/features/createProduct/controller/create_product_controller.dart';

class CreateProductView extends StatelessWidget {
  CreateProductView({super.key});

  final controller = Get.put(CreateProductController());

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
            _buildTextField(
              theme: theme,
              controller: controller.nameController,
              label: 'productNameLabel'.tr,
              hint: 'productNameHintEnglish'.tr,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              theme: theme,
              controller: controller.nameArabicController,
              label: 'productNameLabelArabic'.tr,
              hint: 'productNameHintArabic'.tr,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              theme: theme,
              controller: controller.descriptionController,
              label: 'descriptionLabel'.tr,
              hint: 'descriptionHintEnglish'.tr,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              theme: theme,
              controller: controller.descriptionArabicController,
              label: 'descriptionLabelArabic'.tr,
              hint: 'descriptionHintArabic'.tr,
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              theme: theme,
              controller: controller.coverPictureUrlController,
              label: 'mainImageUrlLabel'.tr,
              hint: 'https://example.com/image.jpg',
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller.coverPictureUrlController,
              builder: (context, value, _) {
                final url = value.text.trim();
                if (url.isEmpty) return const SizedBox.shrink();
                final uri = Uri.tryParse(url);
                if (uri == null || !uri.isAbsolute) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Text(
                      'invalidUrlPreview'.tr,
                      style: AppTextStyles.hint.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      url,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => Container(
                        height: 160,
                        color: Colors.grey[200],
                        child: Center(
                          child: Text(
                            'errorLoadingImage'.tr,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              theme: theme,
              controller: controller.discountController,
              label: 'discountPercentageLabel'.tr,
              hint: '5',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              theme: theme,
              controller: controller.priceController,
              label: 'priceLabel'.tr,
              hint: '99.99',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              theme: theme,
              controller: controller.stockController,
              label: 'stockLabel'.tr,
              hint: '100',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              theme: theme,
              controller: controller.weightController,
              label: 'weightLabel'.tr,
              hint: '1.5',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              theme: theme,
              controller: controller.colorController,
              label: 'colorLabel'.tr,
              hint: 'colorHint'.tr,
            ),
            const SizedBox(height: 16),
            Text(
              'authenticationInfoTitle'.tr,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            _buildTextField(
              theme: theme,
              controller: controller.tokenController,
              label: 'tokenLabelOptional'.tr,
              hint: 'tokenHint'.tr,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              theme: theme,
              controller: controller.sellerIdController,
              label: 'sellerIdLabelRequired'.tr,
              hint: '3fa85f64-5717-4562-b3fc-2c963f66afa6',
            ),
            const SizedBox(height: 8),
            Text(
              'sellerIdRequiredMessage'.tr,
              style: AppTextStyles.hint.copyWith(color: theme.hintColor),
            ),
            const SizedBox(height: 24),
            _buildCategorySection(theme),
            const SizedBox(height: 24),
            _buildPictureUrlsSection(theme),
            const SizedBox(height: 32),
            _buildQuickActions(theme),
            const SizedBox(height: 12),
            _buildSubmitButton(theme),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(ThemeData theme) {
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

  Widget _buildTextField({
    required ThemeData theme,
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.titleMedium.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(color: theme.colorScheme.onSurface),
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
            hintText: hint,
            hintStyle: AppTextStyles.hint.copyWith(color: theme.hintColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'productCategoriesTitle'.tr,
          style: AppTextStyles.titleMedium.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          return Wrap(
            spacing: 8,
            children: [
              ...controller.categoryIds.map(
                (id) => Chip(
                  label: Text(id, style: theme.textTheme.bodyMedium),
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                  onDeleted: () => controller.removeCategory(id),
                  deleteIcon: Icon(
                    Icons.close,
                    size: 18,
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
              ActionChip(
                onPressed: () => _showAddCategoryDialog(theme),
                label: Text('addCategoryButton'.tr),
                backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                labelStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildPictureUrlsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'additionalImageUrlsTitle'.tr,
          style: AppTextStyles.titleMedium.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          return Column(
            children: [
              ...controller.productPictureUrls.map(
                (url) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(
                      url,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: theme.colorScheme.error),
                      onPressed: () => controller.removeProductPictureUrl(url),
                    ),
                  ),
                ),
              ),
              if (controller.productPictureUrls.isNotEmpty)
                const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => _showAddPictureDialog(theme),
                icon: const Icon(Icons.add_a_photo),
                label: Text('addImageButton'.tr),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildSubmitButton(ThemeData theme) {
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
          child:
              controller
                  .isLoading
                  .value // Changed to controller.isLoading.value
              ? const CircularProgressIndicator(
                  color: Colors.white,
                ) // Changed to controller.isLoading.value
              : Text('createProductButton'.tr, style: AppTextStyles.button),
        ),
      );
    });
  }

  void _showAddCategoryDialog(ThemeData theme) {
    final categoryController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: Text('addCategoryDialogTitle'.tr),
        content: TextField(
          controller: categoryController,
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
            hintText: 'enterCategoryIdHint'.tr,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancelButton'.tr),
          ),
          TextButton(
            onPressed: () {
              if (categoryController.text.isNotEmpty) {
                controller.addCategory(categoryController.text.trim());
                Get.back();
              }
            },
            child: Text('addButton'.tr),
          ),
        ],
      ),
    );
  }

  void _showAddPictureDialog(ThemeData theme) {
    final urlController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: Text('addImageUrlDialogTitle'.tr),
        content: TextField(
          controller: urlController,
          decoration: InputDecoration(
            filled: true,
            fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
            hintText: 'https://example.com/image.jpg',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancelButton'.tr),
          ),
          TextButton(
            onPressed: () {
              if (urlController.text.isNotEmpty) {
                controller.addProductPictureUrl(urlController.text.trim());
                Get.back();
              }
            },
            child: Text('addButton'.tr),
          ),
        ],
      ),
    );
  }
}
