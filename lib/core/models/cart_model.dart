class CartModel {
  final String id;
  final List<CartItem> items;
  final double totalPrice;

  CartModel({required this.id, required this.items, required this.totalPrice});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['cartId'] ?? '',
      items:
          (json['cartItems'] as List?)
              ?.map((item) => CartItem.fromJson(item))
              .toList() ??
          [],
      // ملاحظة: إذا كان الـ API لا يرسل totalPrice كحقل أساسي، يمكننا حسابه يدوياً
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
    );
  }
}

class CartItem {
  final String id;
  final String productId;
  final String productName;
  final String? productImage;
  final double price;
  final int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    this.productImage,
    required this.price,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['itemId'] ?? '',
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      productImage: json['productCoverUrl'],
      price: (json['finalPricePerUnit'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
    );
  }
}
