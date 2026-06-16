import 'package:dio/dio.dart';
import 'package:mega_cart/core/NetWork/api_constans.dart';
import 'package:mega_cart/features/cart/domain/repositries/cart_repository.dart';
import 'package:mega_cart/features/splashScreen/view/session_manager.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class CartRepositoryImpl implements CartRepository {
  final Dio _dio;

  CartRepositoryImpl(this._dio) {
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
        compact: true,
      ),
    );
  }

  Future<Options> _getOptions() async {
    final token = await SessionManager.getToken();
    return Options(
      headers: {
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
  }

  @override
  Future<dynamic> getCart() async {
    final response = await _dio.get(
      '${ApiConstans.baseUrl}cart',
      options: await _getOptions(),
    );
    return response.data;
  }

  @override
  Future<void> addToCart(String productId, int quantity) async {
    await _dio.post(
      '${ApiConstans.baseUrl}cart/items',
      data: {"productId": productId, "quantity": quantity},
      options: await _getOptions(),
    );
  }

  @override
  Future<void> updateCartItemQuantity(String cartItemId, int quantity) async {
    await _dio.put(
      '${ApiConstans.baseUrl}cart/items/$cartItemId',
      data: {"quantity": quantity},
      options: await _getOptions(),
    );
  }

  @override
  Future<void> deleteCartItem(String cartItemId) async {
    await _dio.delete(
      '${ApiConstans.baseUrl}cart/items/$cartItemId',
      options: await _getOptions(),
    );
  }

  @override
  Future<void> clearCart() async {}
}
