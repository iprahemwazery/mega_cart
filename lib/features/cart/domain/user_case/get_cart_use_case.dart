import 'package:mega_cart/features/cart/domain/repositries/cart_repository.dart';
import 'package:mega_cart/core/NetWork/product_repository.dart';
import 'package:mega_cart/features/cart/data/model/cart_model.dart';
import 'package:mega_cart/features/home/data/models/product.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

class GetCartUseCase {
  final CartRepository repository;
  final ProductRepository _productRepository;

  GetCartUseCase(this.repository, this._productRepository);

  Future<
    ({CartModel cartModel, List<Product> fullProducts, double totalCartPrice})?
  >
  call() async {
    final data = await repository.getCart();
    if (data == null) {
      return null;
    }

    final cartModel = CartModel.fromJson(data as Map<String, dynamic>);

    final List<Product> fullProducts = [];
    for (var item in cartModel.items) {
      final result = await _productRepository.getProductDetails(item.productId);
      result.fold((failure) {
        debugPrint(
          'Failed to load product details for ${item.productId}: ${failure.message}',
        );
        fullProducts.add(
          Product(
            id: item.productId,
            name: item.productName,
            price: item.price,
            coverPictureUrl: item.productImage ?? '',
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

    return (
      cartModel: cartModel,
      fullProducts: fullProducts,
      totalCartPrice: total,
    );
  }
}
