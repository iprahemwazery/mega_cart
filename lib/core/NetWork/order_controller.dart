import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/NetWork/api_constans.dart';
import 'package:mega_cart/core/customs/snackbar.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class OrderController extends GetxController {
  // تهيئة مكتبة Dio بنفس الإعدادات المستخدمة في المشروع
  final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: ApiConstans.baseUrl,
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        )
        ..interceptors.add(
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseBody: true,
            error: true,
            compact: true,
          ),
        );

  // متغير تفاعلي لمراقبة حالة التحميل
  final RxBool isLoading = false.obs;

  // دالة الـ Checkout لإرسال طلب جديد
  Future<Map<String, dynamic>?> checkout({
    required String shippingAddressId,
    required dynamic
    paymentMethod, // تغيير النوع إلى dynamic للتجربة (String أو int)
    required String token,
  }) async {
    try {
      isLoading.value = true;
      debugPrint('--- POST Checkout Request ---');

      final response = await _dio.post(
        ApiConstans.checkout,
        data: {
          "shippingAddressId": shippingAddressId,
          "paymentMethod": paymentMethod,
          "couponCode": null,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      debugPrint('--- POST Checkout Success ---');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      _handleError(e, "Checkout");
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // إدارة الأخطاء وطباعتها باستخدام GlassSnackbar
  void _handleError(dynamic e, String methodName) {
    debugPrint('--- Error in $methodName ---');

    if (e is DioException) {
      // طباعة الرد الكامل من السيرفر في الـ Console لمعرفة سبب الرفض بالتفصيل
      debugPrint('Status Code: ${e.response?.statusCode}');
      debugPrint('Response Data: ${e.response?.data}');

      String message =
          e.response?.data?['message'] ?? e.message ?? 'حدث خطأ غير متوقع';
      GlassSnackbar.show(message: message, isError: true);
    } else {
      debugPrint('Unknown Error: $e');
      GlassSnackbar.show(message: e.toString(), isError: true);
    }
  }
}
