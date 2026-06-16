import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mega_cart/features/home/data/models/product.dart';
import 'package:mega_cart/core/customs/snackbar.dart';
import 'package:mega_cart/features/favorites/cubit/favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  static const _favoritesKey = 'favoriteProducts';

  FavoritesCubit() : super(const FavoritesState()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString(_favoritesKey);
    if (favoritesJson != null) {
      final List<dynamic> decodedData = jsonDecode(favoritesJson);
      final favorites = decodedData
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
      emit(FavoritesState(favorites: favorites));
    }
  }

  Future<void> _saveFavorites(List<Product> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> jsonList = favorites
        .map((product) => product.toJson())
        .toList();
    await prefs.setString(_favoritesKey, jsonEncode(jsonList));
  }

  void toggleFavorite(Product product) {
    final currentFavorites = List<Product>.from(state.favorites);
    final isExist = currentFavorites.any((p) => p.id == product.id);

    if (isExist) {
      currentFavorites.removeWhere((p) => p.id == product.id);
      GlassSnackbar.show(
        message: 'تمت إزالة ${product.name} من المفضلة',
        isError: true,
      );
    } else {
      currentFavorites.add(product);
      GlassSnackbar.show(message: 'تمت إضافة ${product.name} إلى المفضلة');
    }

    emit(FavoritesState(favorites: currentFavorites));
    _saveFavorites(currentFavorites);
  }

  bool isFavorite(String productId) {
    return state.favorites.any((p) => p.id == productId);
  }
}
