import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/utils/app_text_styles.dart';
import 'package:mega_cart/features/addProduct/presentation/cubit/add_product_cubit.dart';

class CategorySelectionSection extends StatelessWidget {
  const CategorySelectionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
        BlocBuilder<AddProductCubit, AddProductState>(
          builder: (context, state) {
            return Wrap(
              spacing: 8,
              children: [
                ...state.categoryIds.map(
                  (id) => Chip(
                    label: Text(id, style: theme.textTheme.bodyMedium),
                    backgroundColor: theme.colorScheme.surfaceVariant,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 10),
                    onDeleted: () =>
                        context.read<AddProductCubit>().removeCategory(id),
                    deleteIcon: Icon(
                      Icons.close,
                      size: 18,
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
                ActionChip(
                  onPressed: () => _showAddCategoryDialog(
                    context,
                    theme,
                    context.read<AddProductCubit>(),
                  ),
                  label: Text('addCategoryButton'.tr),
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                  labelStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _showAddCategoryDialog(
    BuildContext context,
    ThemeData theme,
    AddProductCubit cubit,
  ) {
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
                cubit.addCategory(categoryController.text.trim());
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
