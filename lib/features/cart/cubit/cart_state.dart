import 'package:mega_cart/core/models/product.dart';

enum CartStatus { initial, loading, success, failure }

class CartState {
  final CartStatus status;
  final List<Product> cartProducts;
  final dynamic cartData;
  final double totalCartPrice;
  final String? errorMessage;

  const CartState({
    this.status = CartStatus.initial,
    this.cartProducts = const [],
    this.cartData,
    this.totalCartPrice = 0.0,
    this.errorMessage,
  });

  CartState copyWith({
    CartStatus? status,
    List<Product>? cartProducts,
    dynamic cartData,
    double? totalCartPrice,
    String? errorMessage,
  }) {
    return CartState(
      status: status ?? this.status,
      cartProducts: cartProducts ?? this.cartProducts,
      cartData: cartData ?? this.cartData,
      totalCartPrice: totalCartPrice ?? this.totalCartPrice,
      errorMessage: errorMessage,
    );
  }
}
