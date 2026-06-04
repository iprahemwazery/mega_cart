import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutHeader extends StatelessWidget {
  const CheckoutHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'checkoutTitle'.tr,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close_rounded),
        ),
      ],
    );
  }
}
