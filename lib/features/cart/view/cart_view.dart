import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_cart/features/cart/data/controller/cart_controller.dart';
import 'package:mega_cart/features/cart/view/checkout_bottom_sheet.dart';
import 'package:mega_cart/features/settings/view/cart_item_card.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CartController());
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('cart'.tr),
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
        // 1. عرض مؤشر التحميل إذا كانت العملية جارية (أو أول مرة)
        if (controller.isLoading.value &&
            (controller.cartData.value == null ||
                controller.cartProducts.isEmpty)) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. التحقق من الأخطاء
        if (controller.errorMessage.isNotEmpty &&
            controller.cartProducts.isEmpty) {
          return Center(child: Text('fetchError'.tr));
        }

        // 3. التحقق مما إذا كانت السلة فارغة بعد انتهاء التحميل
        if (controller.cartProducts.isEmpty) {
          return _buildEmptyCart();
        }

        // 4. عرض البيانات باستخدام RefreshIndicator لتمكين السحب للتحديث
        return RefreshIndicator(
          onRefresh: () => controller.refreshCart(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.cartProducts.length,
            itemBuilder: (context, index) {
              final product = controller.cartProducts[index];
              // البحث عن الـ cartItemId لهذا المنتج
              final cartItem = controller.cartData.value?.items.firstWhere(
                (item) => item.productId == product.id,
              );

              if (cartItem == null) return const SizedBox.shrink();

              return CartItemCard(
                name: product.name,
                price: product.price,
                imageUrl: product.coverPictureUrl,
                quantity: cartItem.quantity,
                onAdd: () => controller.addToCart(product, quantity: 1),
                onRemove: () => cartItem.quantity > 1
                    ? controller.addToCart(product, quantity: -1)
                    : null,
                onDelete: () => controller.deleteCartItem(cartItem.id),
              );
            },
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        // يظهر الشريط السفلي فقط إذا لم تكن السلة فارغة
        if (controller.cartProducts.isEmpty || controller.isLoading.value) {
          return const SizedBox.shrink();
        }
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.05),
                spreadRadius: 5,
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'totalCart'.tr,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '\$${controller.totalCartPrice.toStringAsFixed(2)}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.bottomSheet(
                            const CheckoutBottomSheet(),
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'checkoutNow'.tr,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      // This line was already correct
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            // This line was already correct
            Icons.shopping_cart_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16), // This line was already correct
          Text(
            'emptyCart'.tr,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ), // This line was already correct
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog(BuildContext context, CartController controller) {
    Get.dialog(
      AlertDialog(
        // This line was already correct
        title: Text('clearCartTitle'.tr),
        content: Text('clearCartMessage'.tr),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ), // This line was already correct
          TextButton(
            onPressed: () {
              controller.clearCart();
              Get.back();
            },
            child: Text(
              'clear'.tr,
              style: const TextStyle(color: Colors.red),
            ), // This line was already correct
          ),
        ],
      ),
    );
  }
}
