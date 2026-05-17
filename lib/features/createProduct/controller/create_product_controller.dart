import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/models/create_product_request.dart';
import 'package:mega_cart/core/services/product_service.dart';

class CreateProductController extends GetxController {
  final ProductService _productService = ProductService();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final nameArabicController = TextEditingController();
  final descriptionArabicController = TextEditingController();
  final coverPictureUrlController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final weightController = TextEditingController();
  final colorController = TextEditingController();
  final sellerIdController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxList<String> categoryIds = <String>[].obs;
  final RxList<String> productPictureUrls = <String>[].obs;

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    nameArabicController.dispose();
    descriptionArabicController.dispose();
    coverPictureUrlController.dispose();
    priceController.dispose();
    stockController.dispose();
    weightController.dispose();
    colorController.dispose();
    sellerIdController.dispose();
    super.onClose();
  }

  Future<void> createProduct() async {
    if (!_validateForm()) return;

    isLoading.value = true;

    try {
      final request = CreateProductRequest(
        sellerId: sellerIdController.text.trim(),
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        nameArabic: nameArabicController.text.trim(),
        descriptionArabic: descriptionArabicController.text.trim(),
        coverPictureUrl: coverPictureUrlController.text.trim(),
        price: double.parse(priceController.text.trim()),
        stock: int.parse(stockController.text.trim()),
        weight: double.parse(weightController.text.trim()),
        color: colorController.text.trim(),
        discountPercentage: 0, // افتراضي
        categoryIds: categoryIds.toList(),
        productPictureUrls: productPictureUrls.toList(),
      );

      await _productService.createProduct(request);

      Get.snackbar(
        'نجح',
        'تم إنشاء المنتج بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      _clearForm();
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateForm() {
    if (nameController.text.trim().isEmpty) {
      _showError('أدخل اسم المنتج');
      return false;
    }
    if (descriptionController.text.trim().isEmpty) {
      _showError('أدخل وصف المنتج');
      return false;
    }
    if (priceController.text.trim().isEmpty) {
      _showError('أدخل السعر');
      return false;
    }
    if (stockController.text.trim().isEmpty) {
      _showError('أدخل الكمية');
      return false;
    }

    final sellerId = sellerIdController.text.trim();
    if (sellerId.isEmpty) {
      _showError('أدخل معرف البائع (GUID)');
      return false;
    }

    // التحقق من تنسيق GUID باستخدام RegExp
    final guidRegex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    );
    if (!guidRegex.hasMatch(sellerId)) {
      _showError(
        'معرف البائع يجب أن يكون بتنسيق GUID صحيح (مثال: 3fa85f64-5717-4562-b3fc-2c963f66afa6)',
      );
      return false;
    }

    return true;
  }

  void _showError(String message) {
    Get.snackbar(
      'تحقق من البيانات',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  void _clearForm() {
    nameController.clear();
    descriptionController.clear();
    nameArabicController.clear();
    descriptionArabicController.clear();
    coverPictureUrlController.clear();
    priceController.clear();
    stockController.clear();
    weightController.clear();
    colorController.clear();
    sellerIdController.clear();
    categoryIds.clear();
    productPictureUrls.clear();
  }

  void addCategory(String categoryId) {
    if (!categoryIds.contains(categoryId)) {
      categoryIds.add(categoryId);
    }
  }

  void removeCategory(String categoryId) {
    categoryIds.remove(categoryId);
  }

  void addProductPictureUrl(String url) {
    if (!productPictureUrls.contains(url)) {
      productPictureUrls.add(url);
    }
  }

  void removeProductPictureUrl(String url) {
    productPictureUrls.remove(url);
  }
}
