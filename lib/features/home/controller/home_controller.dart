import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/models/product.dart';
import 'package:mega_cart/core/services/product_service.dart';
import 'package:mega_cart/features/splashScreen/view/session_manager.dart';

class HomeController extends GetxController {
  final ProductService _productService = ProductService();
  final RxList<Product> products = <Product>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasNextPage = true.obs;
  final RxInt currentPage = 1.obs;
  final RxString userEmail = ''.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString userName = ''.obs;
  final RxBool showCategories = false.obs;
  final RxBool isSearchOverlayVisible = false.obs;
  final RxString searchTerm = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    loadProducts();
    // إضافة debounce للانتظار 500ms بعد توقف الكتابة قبل تنفيذ البحث فعلياً
    debounce(
      searchTerm,
      (_) => loadProducts(),
      time: const Duration(milliseconds: 500),
    );
  }

  Future<void> loadUserData() async {
    try {
      final email = await SessionManager.getUserEmail();
      userEmail.value = email ?? '';
      userName.value = email != null ? email.split('@')[0] : '';
    } catch (e) {
      debugPrint('Error loading user data: $e');
      userEmail.value = '';
    }
  }

  Future<void> loadProducts({bool loadMore = false}) async {
    if (loadMore && !hasNextPage.value) return;

    if (loadMore) {
      isLoadingMore.value = true;
    } else {
      isLoading.value = true;
      products.clear();
      currentPage.value = 1;
      hasError.value = false;
      errorMessage.value = '';
    }

    try {
      final response = await _productService.getProducts(
        searchTerm: searchTerm.value,
        page: loadMore ? currentPage.value + 1 : 1,
        pageSize: 100,
      );

      if (loadMore) {
        products.addAll(response.items);
        currentPage.value++;
      } else {
        products.assignAll(response.items);
      }

      hasNextPage.value = response.hasNextPage;
      debugPrint(
        'HomeController - Products count: ${products.length}, Has next page: ${hasNextPage.value}',
      );
      hasError.value = false;
    } catch (e) {
      debugPrint('Error loading products: $e');
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }
}
