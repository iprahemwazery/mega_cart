import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mega_cart/features/singelProfuct/cubit/product_details_cubit.dart';

class ProductQuantitySelector extends StatelessWidget {
  final int currentQuantity;

  const ProductQuantitySelector({super.key, required this.currentQuantity});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'quantity'.tr,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildQuantityButton(
              context,
              icon: Icons.remove,
              onPressed: () =>
                  context.read<ProductDetailsCubit>().decrementQuantity(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '$currentQuantity',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildQuantityButton(
              context,
              icon: Icons.add,
              onPressed: () =>
                  context.read<ProductDetailsCubit>().incrementQuantity(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuantityButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Icon(icon, color: Theme.of(context).primaryColor),
        onPressed: () {
          HapticFeedback.lightImpact();
          onPressed();
        },
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      ),
    );
  }
}
