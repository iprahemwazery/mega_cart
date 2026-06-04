import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mega_cart/features/CheckOut/cubit/checkout_cubit.dart';
import 'package:mega_cart/features/CheckOut/cubit/checkout_state.dart';

class CardNumberInputField extends StatelessWidget {
  final Function(String) onChanged;
  const CardNumberInputField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckoutCubit, CheckoutState>(
      buildWhen: (previous, current) => previous.cardType != current.cardType,
      builder: (context, state) {
        return TextField(
          onChanged: onChanged,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'cardNumberHint'.tr,
            prefixIcon: const Icon(Icons.payment_outlined),
            suffixIcon: _buildCardTypeIcon(state.cardType),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
          ),
        );
      },
    );
  }

  Widget? _buildCardTypeIcon(CardType cardType) {
    switch (cardType) {
      case CardType.visa:
        return const Icon(Icons.credit_card, color: Colors.blue);
      case CardType.mastercard:
        return const Icon(Icons.credit_card, color: Colors.orange);
      case CardType.amex:
        return const Icon(Icons.credit_card, color: Colors.green);
      case CardType.discover:
        return const Icon(Icons.credit_card, color: Colors.purple);
      case CardType.unknown:
        return null;
    }
  }
}
