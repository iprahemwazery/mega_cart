import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_cart/features/cart/cubit/cart_cubit.dart';
import 'package:mega_cart/features/cart/cubit/cart_state.dart';
import 'package:mega_cart/features/settings/view/cart_item_card.dart';
import 'package:mega_cart/features/order/view/page_animation_wrapper.dart';

class CartItemList extends StatelessWidget {
  const CartItemList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () => context.read<CartCubit>().refreshCart(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.cartProducts.length,
            itemBuilder: (context, index) {
              final product = state.cartProducts[index];
              final cartItem = state.cartData?.items.firstWhere(
                (item) => item.productId == product.id,
                orElse: () => throw Exception('Item not found'),
              );

              if (cartItem == null) return const SizedBox.shrink();

              final int reversedIndex = (state.cartProducts.length - 1) - index;
              return PageAnimationWrapper(
                index: reversedIndex,
                delay: Duration(milliseconds: 100 * reversedIndex),
                child: CartItemCard(
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
                ),
              );
            },
          ),
        );
      },
    );
  }
}
