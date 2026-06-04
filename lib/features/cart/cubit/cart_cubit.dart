import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/NetWork/product_repository.dart';
import 'package:mega_cart/core/customs/snackbar.dart';
import 'package:mega_cart/core/models/cart_model.dart';
import 'package:mega_cart/features/cart/data/cart_repository.dart';
import 'package:mega_cart/core/models/product.dart';
import 'package:mega_cart/features/cart/cubit/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepository _repository;
  final ProductRepository _productRepository; // إضافة ProductRepository

  CartCubit(this._repository, this._productRepository)
    : super(const CartState());

  Future<void> getCart() async {
    if (state.cartProducts.isEmpty) {
      emit(state.copyWith(status: CartStatus.loading));
    }

    try {
      final data = await _repository.getCart();
      if (data != null) {
        final cartModel = CartModel.fromJson(data as Map<String, dynamic>);

        // جلب تفاصيل المنتج الكاملة لكل عنصر في السلة
        final List<Product> fullProducts = [];
        for (var item in cartModel.items) {
          final result = await _productRepository.getProductDetails(
            item.productId,
          );
          result.fold((failure) {
            // يمكنك التعامل مع الخطأ هنا، مثلاً تسجيله أو تخطي المنتج
            debugPrint(
              'Failed to load product details for ${item.productId}: ${failure.message}',
            );
            // أو إضافة المنتج ببياناته الجزئية إذا لم تكن التفاصيل الكاملة ضرورية
            fullProducts.add(
              Product(
                id: item.productId,
                name: item.productName,
                price: item.price,
                coverPictureUrl: item.productImage ?? '',
                // باقي الحقول الافتراضية أو الفارغة
                description: '',
                stock: 0,
                rating: 0,
                reviewsCount: 0,
                color: '',
                weight: 0,
                discountPercentage: 0,
                productCode: '',
                arabicName: '',
                arabicDescription: '',
                productPictures: [],
                sellerId: '',
                categories: [],
              ),
            );
          }, (product) => fullProducts.add(product));
        }

        double total = cartModel.items.fold(
          0.0,
          (sum, item) => sum + (item.price * item.quantity),
        );

        emit(
          state.copyWith(
            status: CartStatus.success,
            cartData: cartModel,
            cartProducts: fullProducts,
            totalCartPrice: total,
          ),
        );
      }
    } catch (e) {
      _handleError(e, "Get Cart");
    }
  }

  Future<void> addToCart(Product product, {int quantity = 1}) async {
    try {
      emit(state.copyWith(status: CartStatus.loading));
      await _repository.addToCart(product.id, quantity);
      await getCart();
      HapticFeedback.mediumImpact();
      if (quantity > 0) {
        GlassSnackbar.show(
          message: 'productAddedToCart'.trParams({'productName': product.name}),
        );
      } else if (quantity < 0) {
        GlassSnackbar.show(
          message: 'productRemovedFromCart'.trParams({
            'productName': product.name,
          }), // Assuming a new translation key
        );
      }
    } catch (e) {
      _handleError(e, "Add To Cart");
    }
  }

  Future<void> updateQuantity(String cartItemId, int newQuantity) async {
    try {
      emit(state.copyWith(status: CartStatus.loading));
      await _repository.updateCartItemQuantity(cartItemId, newQuantity);
      await getCart();
      HapticFeedback.mediumImpact();
    } catch (e) {
      _handleError(e, "Update Quantity");
    }
  }

  Future<void> deleteCartItem(String cartItemId) async {
    try {
      emit(state.copyWith(status: CartStatus.loading));
      await _repository.deleteCartItem(cartItemId);
      HapticFeedback.mediumImpact();
      await getCart();
    } catch (e) {
      _handleError(e, "Delete Item");
    }
  }

  Future<void> clearCart() async {
    emit(state.copyWith(status: CartStatus.loading));
    try {
      if (state.cartData != null && state.cartData is CartModel) {
        final items = (state.cartData as CartModel).items;
        for (var item in items) {
          await _repository.deleteCartItem(item.id);
        }
        await getCart();
        GlassSnackbar.show(message: 'cartCleared'.tr);
      }
    } catch (e) {
      _handleError(e, "Clear Cart");
    }
  }

  Future<void> refreshCart() async {
    await getCart();
  }

  Future<void> toggleCart(Product product, {int quantity = 1}) async {
    if (isInCart(product.id)) {
      final item = (state.cartData as CartModel?)?.items.firstWhere(
        (element) => element.productId == product.id,
      );
      if (item != null) {
        await deleteCartItem(item.id);
      }
    } else {
      await addToCart(product, quantity: quantity);
    }
  }

  bool isInCart(String productId) {
    return state.cartProducts.any((p) => p.id == productId);
  }

  void _handleError(dynamic e, String methodName) {
    String message = e.toString();
    if (e is DioException) {
      // Use the sanitized error message from ErrorInterceptor
      message = e.error?.toString() ?? e.message ?? 'حدث خطأ غير متوقع';
    }
    emit(state.copyWith(status: CartStatus.failure, errorMessage: message));
    GlassSnackbar.show(
      message: 'errorOccurred'.trParams({'errorMessage': message}),
      isError: true,
    );
  }
}
