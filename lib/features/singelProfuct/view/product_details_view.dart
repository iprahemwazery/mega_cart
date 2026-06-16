import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:mega_cart/features/favorites/cubit/favorites_cubit.dart';
import 'package:mega_cart/features/favorites/cubit/favorites_state.dart';
import 'package:mega_cart/core/customs/snackbar.dart';
import 'package:mega_cart/features/singelProfuct/cubit/product_details_cubit.dart';
import 'package:mega_cart/features/singelProfuct/cubit/product_details_state.dart';
import 'package:mega_cart/core/app_router.dart';
import 'package:mega_cart/core/customs/shimmer_loading.dart';
import 'package:mega_cart/features/order/widget/page_animation_wrapper.dart';
import '../widget/product_description_section.dart';
import '../widget/product_info_section.dart';
import '../widget/product_quantity_selector.dart';
import '../widget/product_details_bottom_bar.dart';
import 'package:mega_cart/features/home/data/models/product.dart';

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
              _buildBody(context, state, productId),
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
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        BlocBuilder<FavoritesCubit, FavoritesState>(
                          builder: (context, favState) {
                            final isFav = context
                                .read<FavoritesCubit>()
                                .isFavorite(state.product.id);
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
                        IconButton(
                          onPressed: () =>
                              _confirmDelete(context, state.product.id),
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.black,
                          ),
                        ),
                      ],
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

  Widget _buildBody(
    BuildContext context,
    ProductDetailsState state,
    String productId,
  ) {
    if (state is ProductDetailsLoading) {
      return const ProductDetailsSkeleton();
    } else if (state is ProductDetailsSuccess) {
      final product = state.product;
      final currentQuantity = state.quantity;
      final theme = Theme.of(context);
      return SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: PageAnimationWrapper.staggeredList(
              children: [
                ProductImageSlider(product: product),
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
          ),
        ),
      );
    } else if (state is ProductDetailsError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text('error'.trParams({'errorMessage': state.message})),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () =>
                  context.read<ProductDetailsCubit>().loadProduct(productId),
              child: Text('retry'.tr),
            ),
          ],
        ),
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

  void _confirmDelete(BuildContext context, String productId) {
    Get.defaultDialog(
      title: 'delete Product'.tr,
      middleText: 'This action cannot be undone'.tr,
      textCancel: 'cancel'.tr,
      textConfirm: 'delete'.tr,
      confirmTextColor: Colors.red,
      buttonColor: Colors.white,
      onConfirm: () async {
        Get.back();
        final result = await context.read<ProductDetailsCubit>().deleteProduct(
          productId,
        );
        result.fold(
          (failure) {
            GlassSnackbar.show(message: failure.message, isError: true);
          },
          (_) {
            Get.offAllNamed(AppRoutes.root);
            GlassSnackbar.show(message: 'productDeletedSuccess'.tr);
          },
        );
      },
    );
  }
}

class ProductImageSlider extends StatefulWidget {
  final Product product;
  const ProductImageSlider({super.key, required this.product});

  @override
  State<ProductImageSlider> createState() => _ProductImageSliderState();
}

class _ProductImageSliderState extends State<ProductImageSlider> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      widget.product.coverPictureUrl,
      ...widget.product.productPictures,
    ].where((url) => url.isNotEmpty).toList();

    if (images.isEmpty) {
      return const SizedBox(
        height: 350,
        child: Center(child: Icon(Icons.image_not_supported, size: 50)),
      );
    }

    return SizedBox(
      height: 350,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: images[index],
                fit: BoxFit.cover,
                memCacheHeight: 800,
                maxWidthDiskCache: 1000,
                width: double.infinity,
                placeholder: (context, url) => Center(
                  child: ShimmerLoading(
                    child: Container(
                      width: double.infinity,
                      height: 350,
                      color: Colors.white,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              );
            },
          ),
          if (images.length > 1)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  images.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentIndex == index ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: _currentIndex == index
                          ? Theme.of(context).primaryColor
                          : Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
