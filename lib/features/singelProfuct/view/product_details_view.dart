import 'package:flutter/material.dart';
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
      return const Scaffold(
        body: Center(child: Text('عذراً، لم يتم العثور على المنتج')),
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
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عرض الصورة الرئيسية للمنتج
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
                          style: const TextStyle(
                            fontSize: 24,
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
                        '${product.rating} (${product.reviewsCount} تقييم)',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const Spacer(),
                      Text(
                        product.stock > 0 ? 'متوفر' : 'غير متوفر',
                        style: TextStyle(
                          color: product.stock > 0 ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  // الوصف
                  const Text(
                    'عن المنتج',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    product.description,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.black87,
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
      return Center(child: Text(state.message));
    }
    return const SizedBox.shrink();
  }

  Widget _buildBottomNavigationBar(ProductDetailsState state) {
    if (state is! ProductDetailsSuccess) {
      return const SizedBox.shrink();
    }

    final product = state.product;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          minimumSize: const Size(double.infinity, 55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: () => cartController.toggleCart(product),
        child: Obx(() {
          final isInCart = cartController.isInCart(product.id);
          return Text(
            isInCart ? 'إزالة من السلة' : 'أضف إلى السلة',
            style: const TextStyle(fontSize: 18, color: Colors.white),
          );
        }),
      ),
    );
  }
}
