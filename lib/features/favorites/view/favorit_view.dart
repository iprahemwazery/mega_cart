import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_cart/features/favorites/view/favorites_controller.dart';
import 'package:mega_cart/features/home/widget/product_card.dart';

class FavoritView extends StatelessWidget {
  const FavoritView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavoritesController());

    return Scaffold(
      appBar: AppBar(title: const Text('المفضلة'), centerTitle: true),
      body: Obx(() {
        if (controller.favoriteProducts.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'قائمة المفضلة فارغة',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: controller.favoriteProducts.length,
          itemBuilder: (context, index) {
            return ProductCard(product: controller.favoriteProducts[index]);
          },
        );
      }),
    );
  }
}
