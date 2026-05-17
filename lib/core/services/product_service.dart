import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:mega_cart/core/NetWork/api_constans.dart';
import 'package:mega_cart/core/models/product.dart';
import 'package:mega_cart/core/models/create_product_request.dart';

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
      final headers = <String, String>{'Content-Type': 'application/json'};

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
        options: Options(
          method: 'GET',
          headers: headers,
          contentType: Headers.jsonContentType,
        ),
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

  Future<Product> createProduct(CreateProductRequest request) async {
    try {
      final headers = <String, String>{'Content-Type': 'application/json'};

      final response = await _dio.post(
        '${ApiConstans.baseUrl}${ApiConstans.products}',
        options: Options(
          headers: headers,
          contentType: Headers.jsonContentType,
        ),
        data: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Product created successfully: ${response.data}');
        return Product.fromJson(response.data);
      } else {
        throw Exception('Failed to create product');
      }
    } on DioException catch (e) {
      debugPrint('DioException: ${e.toString()}');
      debugPrint('Response data: ${e.response?.data}');
      debugPrint('Response status: ${e.response?.statusCode}');
      throw Exception(
        'Error creating product: ${e.response?.data ?? e.message}',
      );
    } catch (e) {
      throw Exception('Error creating product: $e');
    }
  }
}
