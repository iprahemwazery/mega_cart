import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/utils/app_text_styles.dart';

class ImagePreviewWidget extends StatelessWidget {
  final TextEditingController controller;

  const ImagePreviewWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final url = value.text.trim();
        if (url.isEmpty) return const SizedBox.shrink();
        final uri = Uri.tryParse(url);
        if (uri == null || !uri.isAbsolute) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'invalidUrlPreview'.tr,
              style: AppTextStyles.hint.copyWith(color: theme.hintColor),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: url,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Container(
                height: 160,
                color: theme.colorScheme.surfaceVariant,
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
    );
  }
}
