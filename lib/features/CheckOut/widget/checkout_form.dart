import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_cart/features/CheckOut/cubit/checkout_cubit.dart';
import 'package:mega_cart/features/CheckOut/widget/coupon_code_input_field.dart';
import 'address_input_field.dart';
import 'card_number_input_field.dart';

class CheckoutForm extends StatelessWidget {
  const CheckoutForm({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CheckoutCubit>();
    return Column(
      children: [
        AddressInputField(onChanged: cubit.onAddressChanged),
        const SizedBox(height: 16),
        CardNumberInputField(onChanged: cubit.onCardChanged),
        const SizedBox(height: 16),
        CouponCodeInputField(onChanged: cubit.onCouponChanged),
      ],
    );
  }
}
