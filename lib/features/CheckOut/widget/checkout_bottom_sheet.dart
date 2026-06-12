import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/NetWork/order_controller.dart';
import 'package:mega_cart/features/CheckOut/widget/checkout_form.dart';
import 'package:mega_cart/features/CheckOut/widget/checkout_header.dart';
import 'package:mega_cart/features/CheckOut/widget/checkout_summary.dart';
import 'package:mega_cart/features/CheckOut/widget/handle_bar.dart';
import 'package:mega_cart/features/CheckOut/view/checkout_action_button.dart';
import 'package:mega_cart/features/cart/cubit/cart_cubit.dart';
import 'package:mega_cart/features/CheckOut/cubit/checkout_cubit.dart';
import 'package:mega_cart/features/CheckOut/cubit/checkout_state.dart';

class CheckoutBottomSheet extends StatelessWidget {
  const CheckoutBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckoutCubit(Get.put(OrderController())),
      child: const _CheckoutBottomSheetContent(),
    );
  }
}

class _CheckoutBottomSheetContent extends StatelessWidget {
  const _CheckoutBottomSheetContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<CheckoutCubit, CheckoutState>(
      listener: (context, state) {
        if (state.status == CheckoutStatus.success) {
          Get.back();
          context.read<CartCubit>().getCart();
          Get.snackbar(
            'orderPlacedTitle'.tr,
            'orderPlacedMessage'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else if (state.status == CheckoutStatus.failure) {
          Get.snackbar(
            'alert'.tr,
            state.errorMessage!.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
          context.read<CheckoutCubit>().clearStatus();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const HandleBar(),
              const SizedBox(height: 24),
              const CheckoutHeader(),
              const Divider(height: 24),
              const CheckoutForm(),
              const SizedBox(height: 24),
              const CheckoutSummary(),
              const SizedBox(height: 32),
              const CheckoutActionButton(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
