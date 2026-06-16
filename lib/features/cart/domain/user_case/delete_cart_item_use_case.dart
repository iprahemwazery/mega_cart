import 'package:mega_cart/features/cart/domain/repositries/cart_repository.dart';

class DeleteCartItemUseCase {
  final CartRepository repository;

  DeleteCartItemUseCase(this.repository);

  Future<void> call(String cartItemId) async {
    return await repository.deleteCartItem(cartItemId);
  }
}
