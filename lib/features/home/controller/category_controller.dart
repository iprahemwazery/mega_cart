import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/NetWork/api_constans.dart';
import 'package:mega_cart/core/customs/snackbar.dart';
import 'package:mega_cart/core/models/category_model.dart';
import 'package:mega_cart/features/splashScreen/view/session_manager.dart';

class CategoryController extends GetxController {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstans.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    ),
  );

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> getCategories() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      final token = await SessionManager.getToken();
      final options = Options(
        headers: {
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
      );

      final response = await _dio.get(ApiConstans.categories, options: options);

      debugPrint('--- GET Categories Success ---');
      debugPrint('Response: ${response.data}');

      if (response.data != null &&
          response.data is List &&
          response.data.isNotEmpty) {
        final List<dynamic> responseList = response.data;
        if (responseList.isNotEmpty &&
            responseList[0] is Map &&
            responseList[0].containsKey('categories')) {
          final List<dynamic> categoriesJson = responseList[0]['categories'];
          categories.value = categoriesJson
              .map(
                (json) => CategoryModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        } else {
          errorMessage.value = 'Invalid categories response format';
          GlassSnackbar.show(message: errorMessage.value, isError: true);
        }
      } else {
        errorMessage.value = 'No categories found or invalid response';
        GlassSnackbar.show(message: errorMessage.value, isError: true);
      }
    } catch (e) {
      _handleError(e, "Get Categories");
    } finally {
      isLoading.value = false;
    }
  }

  void _handleError(dynamic e, String methodName) {
    debugPrint('--- Error in $methodName ---');
    hasError.value = true;

    if (e is DioException) {
      // Use the sanitized error message from ErrorInterceptor
      errorMessage.value =
          e.error?.toString() ?? e.message ?? 'حدث خطأ غير متوقع';
    } else {
      debugPrint('Unknown Error: $e');
      errorMessage.value = e.toString();
    }

    GlassSnackbar.show(
      message: 'حدث خطأ: ${errorMessage.value}',
      isError: true,
    );
  }
}
