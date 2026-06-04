import 'package:flutter/material.dart';
import 'package:mega_cart/core/customs/shimmer_loading.dart';

class CartLoadingState extends StatelessWidget {
  const CartLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 3,
      itemBuilder: (context, index) => const CartItemSkeleton(),
    );
  }
}
