import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/models/product.dart';
import 'package:mega_cart/features/cart/cubit/cart_cubit.dart';
import 'package:mega_cart/features/cart/cubit/cart_state.dart';

class ProductDetailsBottomBar extends StatelessWidget {
  final Product product;
  final int currentQuantity;
  final ThemeData theme;

  const ProductDetailsBottomBar({
    super.key,
    required this.product,
    required this.currentQuantity,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth > 400
            ? 20.0
            : (constraints.maxWidth * 0.05).clamp(8.0, 20.0);

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 12.0,
          ),
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.05),
                spreadRadius: 2,
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SafeArea(
            child: Row(
              children: [
                Flexible(
                  flex: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'total'.tr,
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${(product.price * currentQuantity).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        minimumSize: const Size(0, 48),
                      ),
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        context.read<CartCubit>().toggleCart(
                          product,
                          quantity: currentQuantity,
                        );
                      },
                      child: BlocBuilder<CartCubit, CartState>(
                        builder: (context, cartState) {
                          final isInCart = context.read<CartCubit>().isInCart(
                            product.id,
                          );
                          return FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              isInCart ? 'removeFromCart'.tr : 'addToCart'.tr,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
