import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mega_cart/features/favorites/cubit/favorites_cubit.dart';
import 'package:mega_cart/features/favorites/cubit/favorites_state.dart';
import 'package:mega_cart/features/singelProfuct/cubit/product_details_cubit.dart';
import 'package:mega_cart/features/singelProfuct/cubit/product_details_state.dart';
import 'package:mega_cart/core/customs/shimmer_loading.dart';
import '../widget/product_description_section.dart';
import '../widget/product_image_section.dart';
import '../widget/product_info_section.dart';
import '../widget/product_quantity_selector.dart';
import '../widget/product_details_bottom_bar.dart';

class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final dynamic args = Get.arguments;
    final String? productId = args is String ? args : null;
    if (productId == null || productId.isEmpty) {
      return Scaffold(body: Center(child: Text('productNotFound'.tr)));
    }
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              _buildBody(context, state),
              Positioned(
                top: 45,
                left: 15,
                child: CircleAvatar(
                  backgroundColor: Colors.white.withOpacity(0.7),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Get.back(),
                  ),
                ),
              ),
              if (state is ProductDetailsSuccess)
                Positioned(
                  top: 45,
                  right: 15,
                  child: CircleAvatar(
                    backgroundColor: Colors.white.withOpacity(0.7),
                    child: BlocBuilder<FavoritesCubit, FavoritesState>(
                      builder: (context, favState) {
                        final isFav = context.read<FavoritesCubit>().isFavorite(
                          state.product.id,
                        );
                        return IconButton(
                          onPressed: () => context
                              .read<FavoritesCubit>()
                              .toggleFavorite(state.product),
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.black,
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
          bottomNavigationBar: _buildBottomNavigationBar(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ProductDetailsState state) {
    if (state is ProductDetailsLoading) {
      return const ProductDetailsSkeleton();
    } else if (state is ProductDetailsSuccess) {
      final product = state.product;
      final currentQuantity = state.quantity;
      final theme = Theme.of(context);
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProductImageSection(product: product),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductInfoSection(product: product, theme: theme),
                  const SizedBox(height: 20),
                  ProductQuantitySelector(currentQuantity: currentQuantity),
                  const SizedBox(height: 25),
                  ProductDescriptionSection(product: product, theme: theme),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (state is ProductDetailsError) {
      return Center(
        child: Text('error'.trParams({'errorMessage': state.message})),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildBottomNavigationBar(
    BuildContext context,
    ProductDetailsState state,
  ) {
    if (state is! ProductDetailsSuccess) {
      return const SizedBox.shrink();
    }

    final product = state.product;
    final currentQuantity = state.quantity;
    final theme = Theme.of(context);

    return ProductDetailsBottomBar(
      product: product,
      currentQuantity: currentQuantity,
      theme: theme,
    );
  }
}
