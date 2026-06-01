import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mega_cart/core/NetWork/api_constans.dart';
import 'package:mega_cart/core/NetWork/api_service.dart';
import 'package:mega_cart/features/singelProfuct/data/product_repository.dart';
import 'package:mega_cart/features/singelProfuct/data/product_details_cubit.dart';
import 'package:mega_cart/features/singelProfuct/data/product_details_state.dart';
import 'package:mega_cart/features/cart/data/controller/cart_controller.dart';
import 'package:mega_cart/features/favorites/view/favorites_controller.dart';

class ProductDetailsView extends StatefulWidget {
  const ProductDetailsView({super.key});

  @override
  State<ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<ProductDetailsView> {
  late final FavoritesController favoritesController;
  late final CartController cartController;
  int _quantity = 1;
  @override
  void initState() {
    super.initState();
    favoritesController = Get.put(FavoritesController());
    cartController = Get.put(CartController());
  }

  @override
  Widget build(BuildContext context) {
    final dynamic args = Get.arguments;
    final String? productId = args is String ? args : null;
    if (productId == null || productId.isEmpty) {
      return Scaffold(
        // This line was already correct
        // Removed const because Text widget inside is not const
        body: Center(child: Text('productNotFound'.tr)),
      );
    }
    return BlocProvider(
      create: (context) {
        final dio = Dio(BaseOptions(baseUrl: ApiConstans.baseUrl));
        final apiService = ApiService(dio);
        final repository = ProductRepositoryImpl(apiService);

        return ProductDetailsCubit(repository)..loadProduct(productId);
      },
      child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                _buildBody(state),
                // زر الرجوع المخصص فوق الصورة
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
                      child: Obx(() {
                        final isFav = favoritesController.isFavorite(
                          state.product.id,
                        );
                        return IconButton(
                          onPressed: () =>
                              favoritesController.toggleFavorite(state.product),
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.black,
                          ),
                        );
                      }),
                    ),
                  ),
              ],
            ),
            bottomNavigationBar: _buildBottomNavigationBar(state),
          );
        },
      ),
    );
  }

  Widget _buildBody(ProductDetailsState state) {
    if (state is ProductDetailsLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ProductDetailsSuccess) {
      final product = state.product;
      final theme = Theme.of(context);
      // final l10n = AppLocalizations.of(context)!; // لم نعد نستخدم AppLocalizations
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (product.coverPictureUrl.isNotEmpty &&
                    product.coverPictureUrl != "null" &&
                    Uri.tryParse(product.coverPictureUrl)?.hasAbsolutePath ==
                        true)
                ? GestureDetector(
                    onTap: () {
                      Get.to(
                        () => Scaffold(
                          backgroundColor: Colors.black,
                          appBar: AppBar(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            iconTheme: const IconThemeData(color: Colors.white),
                          ),
                          extendBodyBehindAppBar: true,
                          body: Center(
                            child: InteractiveViewer(
                              child: CachedNetworkImage(
                                imageUrl: product.coverPictureUrl,
                                fit: BoxFit.contain,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: CachedNetworkImage(
                      imageUrl: product.coverPictureUrl,
                      height: 450, // جعل الصورة أكبر
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 450,
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 450,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported, size: 100),
                      ),
                    ),
                  )
                : Container(
                    height: 450,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported, size: 100),
                  ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الاسم والسعر
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          product.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '\$${product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // التقييم وحالة المخزون
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 5),
                      Text(
                        '${product.rating} (${product.reviewsCount} ${'reviews'.tr})', // Assuming 'reviews' is a translation key
                        style: TextStyle(
                          // Removed nested TextStyle
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        product.stock > 0 ? 'available'.tr : 'notAvailable'.tr,
                        style: TextStyle(
                          color: product.stock > 0 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // اختيار الكمية
                  Text(
                    'quantity'.tr,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _buildQuantityButton(
                        icon: Icons.remove,
                        onPressed: () {
                          if (_quantity > 1) {
                            setState(() {
                              _quantity--;
                            });
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          '$_quantity',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _buildQuantityButton(
                        icon: Icons.add,
                        onPressed: () {
                          if (_quantity < product.stock) {
                            setState(() {
                              _quantity++;
                            });
                          } else {
                            Get.snackbar('تنبيه', 'maxStockReached'.tr);
                          } // This line was already correct
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  // الوصف
                  Text(
                    'aboutProduct'.tr,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.description,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
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

  Widget _buildQuantityButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Icon(icon, color: Theme.of(context).primaryColor),
        onPressed: () {
          HapticFeedback.lightImpact();
          onPressed();
        },
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      ),
    );
  }

  Widget _buildBottomNavigationBar(ProductDetailsState state) {
    if (state is! ProductDetailsSuccess) {
      return const SizedBox.shrink();
    }

    final product = state.product;
    final theme = Theme.of(context);
    // final l10n = AppLocalizations.of(context)!; // لم نعد نستخدم AppLocalizations

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'total'.tr,
                  style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '\$${(product.price * _quantity).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 25),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  HapticFeedback.lightImpact();
                  cartController.toggleCart(product, quantity: _quantity);
                },
                child: Obx(() {
                  final isInCart = cartController.isInCart(product.id);
                  return Text(
                    isInCart ? 'removeFromCart'.tr : 'addToCart'.tr,
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
