import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/utils/app_text_styles.dart';
import 'package:mega_cart/features/addProduct/presentation/cubit/add_product_cubit.dart';

class PictureUrlsSection extends StatelessWidget {
  const PictureUrlsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
        BlocBuilder<AddProductCubit, AddProductState>(
          builder: (context, state) {
            return Column(
              children: [
                ...state.productPictureUrls.map(
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
                        icon: Icon(
                          Icons.delete,
                          color: theme.colorScheme.error,
                        ),
                        onPressed: () => context
                            .read<AddProductCubit>()
                            .removeProductPictureUrl(url),
                      ),
                    ),
                  ),
                ),
                if (state.productPictureUrls.isNotEmpty)
                  const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () => _showAddPictureDialog(context, theme),
                  icon: const Icon(Icons.add_a_photo),
                  label: Text('addImageButton'.tr),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  void _showAddPictureDialog(BuildContext context, ThemeData theme) {
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
                context.read<AddProductCubit>().addProductPictureUrl(
                  urlController.text.trim(),
                );
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
