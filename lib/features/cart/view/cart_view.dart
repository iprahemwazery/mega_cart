import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mega_cart/features/cart/data/cart_cubit.dart';
import 'package:mega_cart/features/cart/view/cart_state.dart';
import 'package:mega_cart/features/cart/view/checkout_bottom_sheet.dart';
import 'package:mega_cart/features/settings/view/cart_item_card.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  // دالة مساعدة لاستدعاء Cubit عند الحاجة
  void _showClearCartDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: Text('clearCartTitle'.tr),
        content: Text('clearCartMessage'.tr),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          TextButton(
            onPressed: () {
              context.read<CartCubit>().clearCart();
              Get.back();
            },
            child: Text('clear'.tr, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'emptyCart'.tr,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // استدعاء getCart عند بناء الويدجت لأول مرة
    context.read<CartCubit>().getCart();

    return Scaffold(
      appBar: AppBar(
        title: Text('cart'.tr),
        centerTitle: true,
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) => state.cartProducts.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.delete_sweep, color: Colors.red),
                    onPressed: () => _showClearCartDialog(context),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          // 1. عرض مؤشر التحميل إذا كانت العملية جارية (أو أول مرة)
          if (state.status == CartStatus.loading &&
              (state.cartData == null || state.cartProducts.isEmpty)) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. التحقق من الأخطاء
          if (state.status == CartStatus.failure &&
              state.cartProducts.isEmpty) {
            return Center(
              child: Text(state.errorMessage?.tr ?? 'fetchError'.tr),
            );
          }

          // 3. التحقق مما إذا كانت السلة فارغة بعد انتهاء التحميل
          if (state.cartProducts.isEmpty) {
            return _buildEmptyCart();
          }

          // 4. عرض البيانات باستخدام RefreshIndicator لتمكين السحب للتحديث
          return RefreshIndicator(
            onRefresh: () => context.read<CartCubit>().refreshCart(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.cartProducts.length,
              itemBuilder: (context, index) {
                final product = state.cartProducts[index];
                // البحث عن الـ cartItemId لهذا المنتج
                final cartItem = state.cartData?.items.firstWhere(
                  (item) => item.productId == product.id,
                );

                if (cartItem == null) return const SizedBox.shrink();

                return CartItemCard(
                  name: product.name,
                  price: product.price,
                  imageUrl: product.coverPictureUrl,
                  quantity: cartItem.quantity,
                  onAdd: () =>
                      context.read<CartCubit>().addToCart(product, quantity: 1),
                  onRemove: () => cartItem.quantity > 1
                      ? context.read<CartCubit>().updateQuantity(
                          cartItem.id,
                          cartItem.quantity - 1,
                        )
                      : null,
                  onDelete: () =>
                      context.read<CartCubit>().deleteCartItem(cartItem.id),
                );
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          // يظهر الشريط السفلي فقط إذا لم تكن السلة فارغة
          if (state.cartProducts.isEmpty ||
              state.status == CartStatus.loading) {
            return const SizedBox.shrink();
          }
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
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
                        '\$${state.totalCartPrice.toStringAsFixed(2)}',
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
        },
      ),
    );
  }
}
