import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/utils/app_text_styles.dart';
import 'package:mega_cart/features/addProduct/presentation/cubit/add_product_cubit.dart';

class QuickActionsSection extends StatelessWidget {
  final AddProductCubit cubit;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController nameArabicController;
  final TextEditingController descriptionArabicController;
  final TextEditingController coverPictureUrlController;
  final TextEditingController priceController;
  final TextEditingController stockController;
  final TextEditingController discountController;
  final TextEditingController weightController;
  final TextEditingController colorController;
  final TextEditingController tokenController;
  final TextEditingController sellerIdController;
  final VoidCallback onAction; // إضافة callback لإعادة بناء الواجهة

  const QuickActionsSection({
    super.key,
    required this.cubit,
    required this.nameController,
    required this.descriptionController,
    required this.nameArabicController,
    required this.descriptionArabicController,
    required this.coverPictureUrlController,
    required this.priceController,
    required this.stockController,
    required this.discountController,
    required this.weightController,
    required this.colorController,
    required this.tokenController,
    required this.sellerIdController,
    required this.onAction,
  });

  void _fillSampleData() {
    sellerIdController.text = 'd051dbf3-f5d8-410d-0e50-08de06562562';
    nameController.text = 'Aviator Sunglasses';
    descriptionController.text =
        'Classic aviator sunglasses with UV protection';
    nameArabicController.text = 'نظارة أفياتور';
    descriptionArabicController.text =
        'نظارة شمسية كلاسيكية مع حماية من الأشعة فوق البنفسجية';
    coverPictureUrlController.text =
        'https://images.unsplash.com/photo-1572635196237-14b3f281503f?q=80&w=1000';
    priceController.text = '1200';
    stockController.text = '25';
    weightController.text = '0.2';
    colorController.text = 'Black';
    discountController.text = '5';
    // تنظيف القوائم في الكيوبت كما كان يحدث في GetX
    cubit.clearCategoriesAndPictures();
    onAction(); // استدعاء الـ callback بعد ملء البيانات
  }

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
                onPressed: _fillSampleData,
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
                onPressed: () {
                  _fillSampleData(); // تعبئة البيانات
                  // الإرسال مباشرة كما في fillAndSubmitSample
                  cubit.submitProduct(
                    sellerId: sellerIdController.text.trim(),
                    name: nameController.text.trim(),
                    description: descriptionController.text.trim(),
                    nameArabic: nameArabicController.text.trim(),
                    descriptionArabic: descriptionArabicController.text.trim(),
                    price: double.tryParse(priceController.text.trim()) ?? 0.0,
                    coverPictureUrl: coverPictureUrlController.text.trim(),
                    stock: int.tryParse(stockController.text.trim()),
                    weight: double.tryParse(weightController.text.trim()),
                    color: colorController.text.trim(),
                    discountPercentage: int.tryParse(
                      discountController.text.trim(),
                    ),
                    token: tokenController.text.trim().isEmpty
                        ? null
                        : tokenController.text.trim(),
                  );
                },
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
