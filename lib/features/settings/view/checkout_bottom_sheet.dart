import 'package:flutter/material.dart';

class CheckoutBottomSheet extends StatelessWidget {
  final double subtotal;
  final double shipping;
  final VoidCallback onCheckout;

  const CheckoutBottomSheet({
    super.key,
    required this.subtotal,
    required this.shipping,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = subtotal + shipping;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          _buildSummaryRow(
            context,
            'Subtotal',
            '\$${subtotal.toStringAsFixed(2)}',
            false,
          ),
          const SizedBox(height: 12),
          _buildSummaryRow(
            context,
            'Shipping',
            '\$${shipping.toStringAsFixed(2)}',
            false,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(),
          ),
          _buildSummaryRow(
            context,
            'Total',
            '\$${total.toStringAsFixed(2)}',
            true,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onCheckout,
              child: const Text('Checkout Now'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value,
    bool isTotal,
  ) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? theme.textTheme.titleLarge
              : theme.textTheme.bodyLarge,
        ),
        Text(
          value,
          style: isTotal
              ? theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                )
              : theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
        ),
      ],
    );
  }
}
