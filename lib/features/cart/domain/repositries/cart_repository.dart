abstract class CartRepository {
  Future<dynamic> getCart();
  Future<void> addToCart(String productId, int quantity);
  Future<void> deleteCartItem(String cartItemId);
  Future<void> updateCartItemQuantity(String cartItemId, int quantity);
  Future<void> clearCart();
}
