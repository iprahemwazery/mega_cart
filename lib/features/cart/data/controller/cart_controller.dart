import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/NetWork/api_constans.dart';
import 'package:mega_cart/core/customs/snackbar.dart';
import 'package:mega_cart/features/splashScreen/view/session_manager.dart';
import 'package:mega_cart/core/models/product.dart';
import 'package:mega_cart/core/models/cart_model.dart';

class CartController extends GetxController {
  // تهيئة مكتبة Dio
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiConstans.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    ),
  );

  // متغيرات مراقبة الحالة (Reactive Variables)
  final Rxn<CartModel> cartData = Rxn<CartModel>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // تحويل عناصر السلة إلى قائمة منتجات لتعرض في الـ GridView
  List<Product> get cartProducts =>
      cartData.value?.items.map((item) {
        return Product(
          id: item.productId,
          name: item.productName,
          price: item.price,
          coverPictureUrl: item.productImage ?? '',
          description: '',
          stock: 10, // قيم افتراضية لأن السلة لا تعيد كامل بيانات المنتج
          rating: 0,
          reviewsCount: 0,
          color: '',
          weight: 0,
          discountPercentage: 0,
          productCode: '',
          arabicName: '',
          arabicDescription: '',
          productPictures: [],
          sellerId: '',
          categories: [],
        );
      }).toList() ??
      [];

  // جلب إجمالي السعر لكل العناصر في السلة
  double get totalCartPrice =>
      cartData.value?.items.fold(
        0,
        (sum, item) => sum! + (item.price * item.quantity),
      ) ??
      0.0;

  @override
  void onInit() {
    super.onInit();
    refreshCart();
  }

  // دالة لتحديث السلة (تُستدعى عند فتح الشاشة)
  Future<void> refreshCart() async {
    debugPrint('--- Refreshing Cart Data ---');
    getCart(); // جلب السلة تلقائياً عند تشغيل الكنترولر
  }

  // دالة مساعدة لجلب إعدادات الطلب (التوكن)
  Future<Options> _getOptions() async {
    final token = await SessionManager.getToken();
    return Options(
      headers: {
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );
  }

  // 1. دالة الـ GET (جلب محتويات السلة)
  Future<void> getCart() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _dio.get('cart', options: await _getOptions());

      debugPrint('--- GET Cart Success ---');
      debugPrint('Response: ${response.data}');

      if (response.data != null) {
        cartData.value = CartModel.fromJson(
          response.data as Map<String, dynamic>,
        );
      }
    } catch (e) {
      _handleError(e, "Get Cart");
    } finally {
      isLoading.value = false;
    }
  }

  // 2. دالة الـ POST (إضافة منتج للسلة)
  Future<void> addToCart(Product product, {int quantity = 1}) async {
    try {
      isLoading.value = true;

      final Map<String, dynamic> data = {
        "productId": product.id,
        "quantity": quantity,
      };

      debugPrint('--- POST AddToCart Request ---');
      debugPrint('Payload: $data');

      final response = await _dio.post(
        'cart/items',
        data: data,
        options: await _getOptions(),
      );

      debugPrint('--- POST AddToCart Success ---');
      debugPrint('Status Code: ${response.statusCode}');

      // بعد الإضافة الناجحة، نقوم بتحديث بيانات السلة
      await getCart();

      HapticFeedback.mediumImpact();
      GlassSnackbar.show(
        message: 'productAddedToCart'.trParams({'productName': product.name}),
      ); // استخدام .trParams
    } catch (e) {
      _handleError(e, "Add To Cart");
    } finally {
      isLoading.value = false;
    }
  }

  // 3. حذف عنصر من السلة باستخدام الـ cartItemId
  Future<void> deleteCartItem(String cartItemId) async {
    try {
      isLoading.value = true;
      await _dio.delete('cart/items/$cartItemId', options: await _getOptions());
      HapticFeedback.mediumImpact();
      await getCart();
    } catch (e) {
      _handleError(e, "Delete Item");
    } finally {
      isLoading.value = false;
    }
  }

  // 4. دالة التحقق هل المنتج موجود في السلة
  bool isInCart(String productId) {
    return cartData.value?.items.any((item) => item.productId == productId) ??
        false;
  }

  // 5. دالة التبديل (إضافة أو حذف) المستخدمة في صفحة التفاصيل
  Future<void> toggleCart(Product product, {int quantity = 1}) async {
    if (isInCart(product.id)) {
      // البحث عن الـ cartItemId المرتبط بهذا المنتج لحذفه
      final item = cartData.value?.items.firstWhere(
        (element) => element.productId == product.id,
      );
      if (item != null) {
        await deleteCartItem(item.id);
      }
    } else {
      await addToCart(product, quantity: quantity);
    }
  }

  // 6. مسح السلة بالكامل
  Future<void> clearCart() async {
    try {
      isLoading.value = true;
      // إذا كان الـ API لا يدعم مسح الكل، نقوم بحذف العناصر واحداً تلو الآخر
      if (cartData.value != null) {
        for (var item in cartData.value!.items) {
          await _dio.delete(
            'cart/items/${item.id}',
            options: await _getOptions(),
          );
        }
        await getCart(); // تحديث السلة بعد المسح
        GlassSnackbar.show(message: 'cartCleared'.tr); // استخدام .tr
      }
    } catch (e) {
      _handleError(e, "Clear Cart");
    } finally {
      isLoading.value = false;
    }
  }

  // دالة احترافية لإدارة الأخطاء وطباعتها
  void _handleError(dynamic e, String methodName) {
    debugPrint('--- Error in $methodName ---');

    if (e is DioException) {
      final res = e.response;
      debugPrint('Status Code: ${res?.statusCode}');
      debugPrint('Error Data: ${res?.data}');
      debugPrint('Dio Message: ${e.message}');

      errorMessage.value =
          res?.data?['message'] ?? e.message ?? 'حدث خطأ غير متوقع';
    } else {
      debugPrint('Unknown Error: $e');
      errorMessage.value = e.toString();
    }

    GlassSnackbar.show(
      message: 'errorOccurred'.trParams({
        'errorMessage': errorMessage.value,
      }), // استخدام .trParams
      isError: true,
    );
  }
}
