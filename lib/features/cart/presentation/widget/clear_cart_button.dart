import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mega_cart/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:mega_cart/features/cart/presentation/cubit/cart_state.dart';

class ClearCartButton extends StatelessWidget {
  const ClearCartButton({super.key});

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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) => state.cartProducts.isNotEmpty
          ? IconButton(
              icon: const Icon(Icons.delete_sweep, color: Colors.red),
              onPressed: () => _showClearCartDialog(context),
            )
          : const SizedBox.shrink(),
    );
  }
}
