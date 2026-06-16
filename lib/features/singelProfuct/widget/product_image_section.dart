import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/customs/shimmer_loading.dart';
import 'package:mega_cart/features/home/data/models/product.dart';

class ProductImageSection extends StatelessWidget {
  final Product product;

  const ProductImageSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final imageHeight = 450.0;
        final hasImage =
            product.coverPictureUrl.isNotEmpty &&
            product.coverPictureUrl != "null" &&
            Uri.tryParse(product.coverPictureUrl)?.hasAbsolutePath == true;

        if (!hasImage) {
          return Container(
            height: imageHeight,
            width: maxWidth,
            color: Colors.grey[200],
            child: const Icon(Icons.image_not_supported, size: 100),
          );
        }

        return GestureDetector(
          onTap: () {
            Get.to(
              () => Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  iconTheme: const IconThemeData(color: Colors.white),
                ),
                extendBodyBehindAppBar: true,
                body: Center(
                  child: InteractiveViewer(
                    child: SizedBox(
                      width: maxWidth,
                      height: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: product.coverPictureUrl,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          child: CachedNetworkImage(
            imageUrl: product.coverPictureUrl,
            height: imageHeight,
            width: maxWidth,
            fit: BoxFit.cover,
            placeholder: (context, url) => ShimmerLoading(
              child: Container(
                height: imageHeight,
                width: maxWidth,
                color: Colors.white,
              ),
            ),
            errorWidget: (context, url, error) => Container(
              height: imageHeight,
              width: maxWidth,
              color: Colors.grey[200],
              child: const Icon(Icons.image_not_supported, size: 100),
            ),
          ),
        );
      },
    );
  }
}
