import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/app_router.dart';
import 'package:mega_cart/core/customs/shimmer_loading.dart';
import 'package:mega_cart/core/models/product.dart';
import 'package:mega_cart/features/home/cubit/home_cubit.dart';
import 'package:mega_cart/features/home/cubit/home_state.dart';
import 'package:mega_cart/features/home/widget/product_card.dart';
import 'package:mega_cart/features/order/widget/page_animation_wrapper.dart';

class ProductsContent extends StatelessWidget {
  const ProductsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocSelector<
      HomeCubit,
      HomeState,
      ({
        HomeStatus status,
        List<Product> products,
        bool hasNextPage,
        bool isLoadingMore,
      })
    >(
      selector: (state) => (
        status: state.status,
        products: state.products,
        hasNextPage: state.hasNextPage,
        isLoadingMore: state.isLoadingMore,
      ),
      builder: (context, stateValues) {
        final status = stateValues.status;
        final products = stateValues.products;
        final hasNextPage = stateValues.hasNextPage;
        final isLoadingMore = stateValues.isLoadingMore;

        if (status == HomeStatus.loading && products.isEmpty) {
          return GridView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(top: 16, bottom: 80),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: 6,
            itemBuilder: (context, index) => const ProductCardSkeleton(),
          );
        }

        if (status == HomeStatus.failure && products.isEmpty) {
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
                Text('fetchError'.tr, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.read<HomeCubit>().loadProducts(),
                  child: Text('retry'.tr),
                ),
              ],
            ),
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'New Arrivals'.tr,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async =>
                    context.read<HomeCubit>().loadProducts(isRefresh: true),
                child: GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 80),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: products.length + (hasNextPage ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == products.length) {
                      if (isLoadingMore) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: ProductCardSkeleton(),
                        );
                      }
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        context.read<HomeCubit>().loadProducts(loadMore: true);
                      });
                      return const SizedBox.shrink();
                    }
                    final product = products[index];
                    return PageAnimationWrapper(
                      index: index,
                      delay: Duration(milliseconds: 50 * index),
                      child: GestureDetector(
                        onTap: () => Get.toNamed(
                          AppRoutes.detail,
                          arguments: product.id,
                        ),
                        child: ProductCard(product: product),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
