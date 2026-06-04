import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mega_cart/features/cart/cubit/cart_cubit.dart';
import 'package:mega_cart/features/cart/cubit/cart_state.dart';

class CheckoutSummary extends StatelessWidget {
  const CheckoutSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final subtotal = state.totalCartPrice;
          const delivery = 5.0;
          return Column(
            children: [
              _buildRow('subtotal'.tr, '\$${subtotal.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              _buildRow('deliveryFee'.tr, '\$${delivery.toStringAsFixed(2)}'),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(),
              ),
              _buildRow(
                'grandTotal'.tr,
                '\$${(subtotal + delivery).toStringAsFixed(2)}',
                isTotal: true,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
