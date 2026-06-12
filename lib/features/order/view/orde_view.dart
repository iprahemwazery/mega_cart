import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mega_cart/features/order/widget/order_card_widget.dart';
import 'package:mega_cart/features/order/cubit/order_cubit.dart';
import 'package:mega_cart/features/order/cubit/order_state.dart';
import 'package:mega_cart/features/order/widget/page_animation_wrapper.dart';

class OrderView extends StatelessWidget {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'orders'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: BlocBuilder<OrderCubit, OrderHistoryState>(
        builder: (context, state) {
          if (state.status == OrderStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == OrderStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.wifi_off_rounded,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(state.errorMessage ?? 'fetchError'.tr),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.read<OrderCubit>().loadOrders(),
                    child: Text('retry'.tr),
                  ),
                ],
              ),
            );
          }

          if (state.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'noOrders'.tr,
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 54),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => context.read<OrderCubit>().loadOrders(),
            child: AnimationLimiter(
              child: ListView.builder(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: 100,
                ),
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  final int reversedIndex = (state.orders.length - 1) - index;
                  return PageAnimationWrapper(
                    index: reversedIndex,
                    delay: Duration(milliseconds: 100 * reversedIndex),
                    child: OrderCardWidget(order: order),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
