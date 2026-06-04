import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mega_cart/features/cart/cubit/cart_cubit.dart';
import 'package:mega_cart/features/cart/view/cart_item_list.dart';
import 'package:mega_cart/features/cart/view/cart_loading_state.dart';
import 'package:mega_cart/features/cart/cubit/cart_state.dart';
import 'package:mega_cart/features/cart/view/cart_summary_section.dart';
import 'package:mega_cart/features/cart/view/clear_cart_button.dart';
import 'package:mega_cart/features/cart/view/empty_cart_state.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<CartCubit>().getCart();

    return Scaffold(
      appBar: AppBar(
        title: Text('cart'.tr),
        centerTitle: true,
        actions: const [ClearCartButton()],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.status == CartStatus.loading &&
              (state.cartData == null || state.cartProducts.isEmpty)) {
            return const CartLoadingState();
          }

          if (state.status == CartStatus.failure &&
              state.cartProducts.isEmpty) {
            return Center(
              child: Text(state.errorMessage?.tr ?? 'fetchError'.tr),
            );
          }

          if (state.cartProducts.isEmpty) {
            return const EmptyCartState();
          }

          return const CartItemList();
        },
      ),
      bottomNavigationBar: const CartSummarySection(),
    );
  }
}
