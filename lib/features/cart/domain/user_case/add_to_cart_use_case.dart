import 'package:mega_cart/features/cart/domain/repositries/cart_repository.dart';

class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  Future<void> call(String productId, int quantity) async {
    return await repository.addToCart(productId, quantity);
  }
}
