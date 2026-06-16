import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/customs/snackbar.dart';
import 'package:mega_cart/features/cart/data/model/cart_model.dart';
import 'package:mega_cart/features/cart/domain/repositries/cart_repository.dart';
import 'package:mega_cart/features/cart/domain/user_case/get_cart_use_case.dart';
import 'package:mega_cart/features/cart/domain/user_case/add_to_cart_use_case.dart';
import 'package:mega_cart/features/cart/domain/user_case/delete_cart_item_use_case.dart';

import 'package:mega_cart/features/home/data/models/product.dart';
import 'package:mega_cart/features/cart/presentation/cubit/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetCartUseCase _getCartUseCase;
  final DeleteCartItemUseCase _deleteCartItemUseCase;
  final AddToCartUseCase _addToCartUseCase;
  final CartRepository _repository;

  CartCubit(
    this._getCartUseCase,
    this._deleteCartItemUseCase,
    this._addToCartUseCase,
    this._repository,
  ) : super(const CartState());

  Future<void> getCart() async {
    if (state.cartProducts.isEmpty) {
      emit(state.copyWith(status: CartStatus.loading));
    }
    try {
      final result = await _getCartUseCase();
      if (result != null) {
        emit(
          state.copyWith(
            status: CartStatus.success,
            cartData: result.cartModel,
            cartProducts: result.fullProducts,
            totalCartPrice: result.totalCartPrice,
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
      await _addToCartUseCase(product.id, quantity);
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
      await _deleteCartItemUseCase(cartItemId);
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
