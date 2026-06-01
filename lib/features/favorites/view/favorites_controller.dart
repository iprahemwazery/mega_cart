import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/models/product.dart';
import 'package:mega_cart/core/customs/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For jsonEncode and jsonDecode

class FavoritesController extends GetxController {
  static const _favoritesKey = 'favoriteProducts';

  // قائمة المنتجات المفضلة (Reactive list)
  var favoriteProducts = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
    // Listen for changes and save
    ever(favoriteProducts, (_) => saveFavorites());
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString(_favoritesKey);
    if (favoritesJson != null) {
      final List<dynamic> decodedData = jsonDecode(favoritesJson);
      favoriteProducts.assignAll(
        decodedData
            .map((item) => Product.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
    }
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList = favoriteProducts
        .map((product) => product.toJson())
        .toList();
    await prefs.setString(_favoritesKey, jsonEncode(jsonList));
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product.id)) {
      favoriteProducts.removeWhere((p) => p.id == product.id);
      _showCustomSnackBar(
        'تمت الإزالة من المفضلة',
        product.name,
        isAdded: false,
      );
      GlassSnackbar.show(
        message: 'تمت إزالة ${product.name} من المفضلة',
        isError: true,
      );
    } else {
      favoriteProducts.add(product);
      _showCustomSnackBar(
        'تمت الإضافة إلى المفضلة',
        product.name,
        isAdded: true,
      );
      GlassSnackbar.show(message: 'تمت إضافة ${product.name} إلى المفضلة');
    }
  }

  bool isFavorite(String productId) {
    return favoriteProducts.any((p) => p.id == productId);
  }

  void _showCustomSnackBar(
    String title,
    String message, {
    required bool isAdded,
  }) {
    // Get.snackbar(
    //   title,
    //   message,
    //   snackPosition: SnackPosition.BOTTOM, // يظهر من الأسفل
    //   backgroundColor: Colors.black.withOpacity(0.8),
    //   colorText: Colors.white,
    //   borderRadius: 8,
    //   margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
    //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    //   icon: Icon(
    //     isAdded ? Icons.favorite : Icons.favorite_border,
    //     color: isAdded ? Colors.red : Colors.orange,
    //     size: 20,
    //   ),
    //   duration: const Duration(seconds: 2),
    //   animationDuration: const Duration(milliseconds: 300),
    //   isDismissible: true,
    //   forwardAnimationCurve: Curves.easeOutCubic,
    //   reverseAnimationCurve: Curves.easeInCubic,
    //   barBlur: 0,
    //   overlayBlur: 0,
    // );
  }
}
