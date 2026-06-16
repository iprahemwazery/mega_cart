import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:mega_cart/core/NetWork/api_constans.dart';
import 'package:mega_cart/features/home/data/models/product.dart';
import 'package:mega_cart/core/models/create_product_request.dart';
import 'package:mega_cart/core/NetWork/error_interceptor.dart';

class ApiService {
  final Dio dio;
  final String? token;

  ApiService(this.dio, {this.token}) {
    if (token != null) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
    dio.interceptors.add(ErrorInterceptor());
  }

  Future<Product> getProductById(String id) async {
    try {
      final response = await dio.get(
        '${ApiConstans.products}/$id',
        options: Options(
          responseType: ResponseType.json,
          headers: {'Accept': 'application/json'},
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          return Product.fromJson(data);
        }
        throw Exception('Invalid product response format');
      }

      throw Exception('Failed to load product details.');
    } on DioException catch (e) {
      final message = e.error?.toString() ?? 'unexpectedError'.tr;
      throw Exception(message);
    }
  }

  Future<ProductResponse> getProducts({
    String? searchTerm,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await dio.get(
        ApiConstans.products,
        queryParameters: {
          'searchTerm': searchTerm,
          'page': page,
          'pageSize': pageSize,
        },
      );
      if (response.data is! Map<String, dynamic>) {
        throw Exception(
          'Invalid response format: Expected a Map but got ${response.data.runtimeType}',
        );
      }
      return ProductResponse.fromJson(response.data);
    } on DioException catch (e) {
      final message = e.error?.toString() ?? 'unexpectedError'.tr;
      throw Exception(message);
    }
  }

  Future<void> addProduct(CreateProductRequest request) async {
    try {
      await dio.post(
        ApiConstans.products,
        data: request.toJson(),
        options: Options(
          responseType: ResponseType.json,
          headers: {'Accept': 'application/json'},
        ),
      );
    } on DioException catch (e) {
      final message = e.response?.data?.toString() ?? e.message;
      throw Exception('Add product failed: $message');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await dio.delete(
        '${ApiConstans.products}/$id',
        options: Options(
          responseType: ResponseType.json,
          headers: {'Accept': 'application/json'},
        ),
      );
    } on DioException catch (e) {
      final message = e.response?.data?.toString() ?? e.message;
      throw Exception('Delete product failed: $message');
    }
  }
}
