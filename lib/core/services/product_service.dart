import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:mega_cart/core/NetWork/api_constans.dart';
import 'package:mega_cart/core/models/product.dart';
import 'package:mega_cart/core/services/session_manager.dart';

class ProductService {
  final Dio _dio = Dio();

  Future<ProductResponse> getProducts({
    String? searchTerm,
    String? category,
    double? minPrice,
    double? maxPrice,
    bool? isInStock,
    String? sortBy,
    String? sortOrder,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      // Get token from session
      final token = await SessionManager.getToken();
      final headers = <String, String>{'Content-Type': 'application/json'};

      // تجهيز البيانات تماماً كما في Postman
      final body = jsonEncode({
        'searchTerm': searchTerm,
        'category': category,
        'minPrice': minPrice,
        'maxPrice': maxPrice,
        'isInStock': isInStock,
        'sortBy': sortBy,
        'sortOrder': sortOrder,
        'page': page,
        'pageSize': pageSize,
      });

      final response = await _dio.request(
        '${ApiConstans.baseUrl}${ApiConstans.products}',
        options: Options(method: 'GET', headers: headers),
        data: body,
      );

      if (response.statusCode == 200) {
        debugPrint('ProductService raw response data: ${response.data}');
        return ProductResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to load products');
      }
    } on DioException catch (e) {
      debugPrint('DioException: ${e.toString()}');
      debugPrint('Response data: ${e.response?.data}');
      debugPrint('Response status: ${e.response?.statusCode}');
      throw Exception(
        'Error fetching products: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Error fetching products: $e');
    }
  }
}
