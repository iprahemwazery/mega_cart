import 'package:get/get.dart';
import 'package:mega_cart/core/customs/snackbar.dart';
import 'package:mega_cart/core/models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartController extends GetxController {
  static const _cartKey = 'cartProducts';

  var cartProducts = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
    ever(cartProducts, (_) => saveCart());
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartJson = prefs.getString(_cartKey);
    if (cartJson != null) {
      final List<dynamic> decodedData = jsonDecode(cartJson);
      cartProducts.assignAll(
        decodedData
            .map((item) => Product.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    }
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList = cartProducts
        .map((product) => product.toJson())
        .toList();
    await prefs.setString(_cartKey, jsonEncode(jsonList));
  }

  void toggleCart(Product product) {
    if (isInCart(product.id)) {
      cartProducts.removeWhere((p) => p.id == product.id);
      GlassSnackbar.show(
        message: 'تمت إزالة ${product.name} من السلة',
        isError: true,
      );
    } else {
      cartProducts.add(product);
      GlassSnackbar.show(message: 'تمت إضافة ${product.name} إلى السلة');
    }
  }

  bool isInCart(String productId) {
    return cartProducts.any((p) => p.id == productId);
  }
}
