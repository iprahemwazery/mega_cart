import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/customs/shimmer_loading.dart';
import 'package:mega_cart/core/models/product.dart';

class ProductImageSection extends StatelessWidget {
  final Product product;

  const ProductImageSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return (product.coverPictureUrl.isNotEmpty &&
            product.coverPictureUrl != "null" &&
            Uri.tryParse(product.coverPictureUrl)?.hasAbsolutePath == true)
        ? GestureDetector(
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
                      child: CachedNetworkImage(
                        imageUrl: product.coverPictureUrl,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                ),
              );
            },
            child: CachedNetworkImage(
              imageUrl: product.coverPictureUrl,
              height: 450,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => ShimmerLoading(
                child: Container(height: 450, color: Colors.white),
              ),
              errorWidget: (context, url, error) => Container(
                height: 450,
                color: Colors.grey[200],
                child: const Icon(Icons.image_not_supported, size: 100),
              ),
            ),
          )
        : Container(
            height: 450,
            color: Colors.grey[200],
            child: const Icon(Icons.image_not_supported, size: 100),
          );
  }
}
