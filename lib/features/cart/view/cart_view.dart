import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_cart/features/cart/data/controller/cart_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mega_cart/features/cart/view/checkout_bottom_sheet.dart';

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
        // 1. عرض مؤشر التحميل إذا كانت العملية جارية (أو أول مرة)
        if (controller.isLoading.value &&
            (controller.cartData.value == null ||
                controller.cartProducts.isEmpty)) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. التحقق من الأخطاء
        if (controller.errorMessage.isNotEmpty &&
            controller.cartProducts.isEmpty) {
          return const Center(child: Text('حدث خطأ أثناء جلب البيانات'));
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

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // صورة المنتج
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: product.coverPictureUrl,
                        width: 85,
                        height: 85,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: Colors.grey[100]),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.image_not_supported),
                      ),
                    ),
                    const SizedBox(width: 15),
                    // تفاصيل المنتج
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'العدد: ${cartItem.quantity}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              Text(
                                '\$${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    // زر حذف المنتج الفردي
                    IconButton(
                      onPressed: () => controller.deleteCartItem(cartItem.id),
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                    ),
                  ],
                ),
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
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
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
                    const Text(
                      'إجمالي السلة',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '\$${controller.totalCartPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
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
                        child: const Text(
                          'Check Now',
                          style: TextStyle(fontSize: 16, color: Colors.white),
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
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'السلة فارغة',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
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
