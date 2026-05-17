import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/utils/app_colors.dart';
import 'package:mega_cart/core/utils/app_text_styles.dart';
import 'package:mega_cart/features/createProduct/controller/create_product_controller.dart';

class CreateProductView extends StatelessWidget {
  CreateProductView({super.key});

  final controller = Get.put(CreateProductController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إنشاء منتج جديد'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(
              controller: controller.nameController,
              label: 'اسم المنتج',
              hint: 'أدخل اسم المنتج بالإنجليزية',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: controller.nameArabicController,
              label: 'اسم المنتج (عربي)',
              hint: 'أدخل اسم المنتج بالعربية',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: controller.descriptionController,
              label: 'الوصف',
              hint: 'أدخل وصف المنتج بالإنجليزية',
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: controller.descriptionArabicController,
              label: 'الوصف (عربي)',
              hint: 'أدخل وصف المنتج بالعربية',
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: controller.coverPictureUrlController,
              label: 'رابط الصورة الرئيسية',
              hint: 'https://example.com/image.jpg',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: controller.priceController,
              label: 'السعر',
              hint: '99.99',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: controller.stockController,
              label: 'الكمية',
              hint: '100',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: controller.weightController,
              label: 'الوزن',
              hint: '1.5',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: controller.colorController,
              label: 'اللون',
              hint: 'أحمر',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: controller.sellerIdController,
              label: 'معرف البائع',
              hint: '3fa85f64-5717-4562-b3fc-2c963f66afa6',
            ),
            const SizedBox(height: 24),
            _buildCategorySection(),
            const SizedBox(height: 24),
            _buildPictureUrlsSection(),
            const SizedBox(height: 32),
            _buildSubmitButton(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.titleMedium),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('فئات المنتج', style: AppTextStyles.titleMedium),
        const SizedBox(height: 8),
        Obx(() {
          return Wrap(
            spacing: 8,
            children: [
              ...controller.categoryIds.map(
                (id) => Chip(
                  label: Text(id),
                  onDeleted: () => controller.removeCategory(id),
                  deleteIcon: const Icon(Icons.close, size: 18),
                ),
              ),
              ActionChip(
                onPressed: () => _showAddCategoryDialog(),
                label: const Text('إضافة فئة'),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildPictureUrlsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('روابط الصور الإضافية', style: AppTextStyles.titleMedium),
        const SizedBox(height: 8),
        Obx(() {
          return Column(
            children: [
              ...controller.productPictureUrls.map(
                (url) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(url, style: AppTextStyles.bodySmall),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => controller.removeProductPictureUrl(url),
                    ),
                  ),
                ),
              ),
              if (controller.productPictureUrls.isNotEmpty)
                const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: () => _showAddPictureDialog(),
                icon: const Icon(Icons.add_a_photo),
                label: const Text('إضافة صورة'),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() {
      return SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: controller.isLoading.value
              ? null
              : () => controller.createProduct(),
          child: controller.isLoading.value
              ? const CircularProgressIndicator(color: Colors.white)
              : Text('إنشاء المنتج', style: AppTextStyles.button),
        ),
      );
    });
  }

  void _showAddCategoryDialog() {
    final categoryController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('إضافة فئة'),
        content: TextField(
          controller: categoryController,
          decoration: InputDecoration(
            hintText: 'أدخل معرف الفئة',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              if (categoryController.text.isNotEmpty) {
                controller.addCategory(categoryController.text.trim());
                Get.back();
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }

  void _showAddPictureDialog() {
    final urlController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: const Text('إضافة رابط صورة'),
        content: TextField(
          controller: urlController,
          decoration: InputDecoration(
            hintText: 'https://example.com/image.jpg',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              if (urlController.text.isNotEmpty) {
                controller.addProductPictureUrl(urlController.text.trim());
                Get.back();
              }
            },
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}
