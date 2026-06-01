import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/NetWork/order_controller.dart';
import 'package:mega_cart/features/splashScreen/view/session_manager.dart';
import 'package:mega_cart/features/cart/data/controller/cart_controller.dart';

class CheckoutBottomSheet extends StatefulWidget {
  const CheckoutBottomSheet({super.key});

  @override
  State<CheckoutBottomSheet> createState() => _CheckoutBottomSheetState();
}

class _CheckoutBottomSheetState extends State<CheckoutBottomSheet> {
  final TextEditingController _couponController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cardController = TextEditingController();

  @override
  void dispose() {
    _couponController.dispose();
    _addressController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();
    final orderController = Get.put(OrderController());
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // مقبض السحب (Drag Handle)
          Container(
            height: 5,
            width: 50,
            decoration: BoxDecoration(
              color: theme.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'checkoutTitle'.tr,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          const Divider(height: 24),

          // حقل إدخال العنوان
          TextField(
            controller: _addressController,
            decoration: InputDecoration(
              hintText: 'shippingAddressHint'.tr,
              prefixIcon: const Icon(Icons.location_on_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              filled: true,
              fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.2),
            ),
          ),
          const SizedBox(height: 16),

          // حقل إدخال بيانات البطاقة
          TextField(
            controller: _cardController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'cardNumberHint'.tr,
              prefixIcon: const Icon(Icons.payment_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              filled: true,
              fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.2),
            ),
          ),
          const SizedBox(height: 16),

          // حقل الكوبون (اختياري)
          TextField(
            controller: _couponController,
            decoration: InputDecoration(
              hintText: 'couponCodeHint'.tr,
              prefixIcon: const Icon(Icons.confirmation_number_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              filled: true,
              fillColor: theme.colorScheme.surfaceVariant.withOpacity(0.2),
            ),
          ),
          const SizedBox(height: 24),

          // قسم ملخص الفاتورة
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildSummaryRow(
                  'subtotal'.tr,
                  '\$${controller.totalCartPrice.toStringAsFixed(2)}',
                ),
                const SizedBox(height: 8),
                _buildSummaryRow('deliveryFee'.tr, '\$5.00'),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(),
                ),
                _buildSummaryRow(
                  'grandTotal'.tr,
                  '\$${(controller.totalCartPrice + 5).toStringAsFixed(2)}',
                  isTotal: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // زر التأكيد النهائي
          SizedBox(
            width: double.infinity,
            child: Obx(
              () => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: orderController.isLoading.value
                    ? null
                    : () async {
                        if (_addressController.text.trim().isEmpty) {
                          Get.snackbar(
                            'alert'.tr,
                            'addressRequired'.tr,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.orange,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        // جلب التوكن الحقيقي من الـ SessionManager (مطلوب للـ Authorization)
                        final token = await SessionManager.getToken();
                        if (token == null || token.isEmpty) {
                          Get.snackbar(
                            'alert'.tr,
                            'loginRequiredForCheckout'.tr,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        // استدعاء دالة إتمام الطلب من الـ OrderController
                        final response = await orderController.checkout(
                          shippingAddressId:
                              "3fa85f64-5717-4562-b3fc-2c963f66afa6", // UUID تجريبي
                          paymentMethod: _cardController.text.trim().isNotEmpty
                              ? "Card" // القيمة النصية "Card"
                              : "Cash", // القيمة النصية "Cash"
                          token: token,
                        );

                        if (response != null) {
                          Get.back(); // إغلاق الـ Bottom Sheet
                          controller
                              .getCart(); // تحديث السلة لمسح العناصر بعد نجاح الطلب
                          Get.snackbar(
                            'orderPlacedTitle'.tr,
                            'orderPlacedMessage'.tr,
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        }
                      },
                child: orderController.isLoading.value
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        // This line was already correct
                        'confirmAndBuy'.tr,
                        style: const TextStyle(
                          // This line was already correct
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildInfoSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String content,
    required VoidCallback onEdit,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        TextButton(onPressed: onEdit, child: Text('change'.tr)),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? const Color(0xFF1D1B20) : Colors.grey[700],
            height: 1.4,
            letterSpacing: 0.3,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
            height: 1.4,
            color: const Color(0xFF1D1B20),
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }
}
