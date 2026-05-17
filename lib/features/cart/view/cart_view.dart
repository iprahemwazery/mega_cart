import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/app_router.dart';
import 'package:mega_cart/features/cart/data/controller/cart_controller.dart';
import 'package:mega_cart/features/home/widget/product_card.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('السلة'),
        centerTitle: true,
        actions: [
          // Obx هنا تجعل الزر يختفي ويظهر تلقائياً حسب حالة السلة
          Obx(
            () => controller.cartProducts.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.delete_sweep, color: Colors.red),
                    onPressed: () => _showClearCartDialog(context, controller),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.cartProducts.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  'السلة فارغة',
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
          itemCount: controller.cartProducts.length,
          itemBuilder: (context, index) {
            final product = controller.cartProducts[index];
            return Stack(
              children: [
                GestureDetector(
                  onTap: () => Get.toNamed(
                    AppRoutes.productDetails,
                    arguments: product.id,
                  ),
                  child: ProductCard(product: product),
                ),
                // زر حذف المنتج الفردي
                Positioned(
                  top: 5,
                  right: 5,
                  child: GestureDetector(
                    onTap: () => controller.toggleCart(product),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }

  void _showClearCartDialog(BuildContext context, CartController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('مسح السلة'),
        content: const Text('هل تريد مسح جميع المنتجات من السلة؟'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              controller.clearCart();
              Get.back();
            },
            child: const Text('مسح', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
