import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mega_cart/core/customs/snackbar.dart';
import 'package:mega_cart/core/models/create_product_request.dart';
import 'package:mega_cart/core/services/product_service.dart';
import 'package:mega_cart/features/splashScreen/view/session_manager.dart';

class CreateProductController extends GetxController {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final nameArabicController = TextEditingController();
  final descriptionArabicController = TextEditingController();
  final coverPictureUrlController = TextEditingController();
  final priceController = TextEditingController();
  final stockController = TextEditingController();
  final discountController = TextEditingController();
  final weightController = TextEditingController();
  final colorController = TextEditingController();
  final tokenController = TextEditingController();
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
    discountController.dispose();
    weightController.dispose();
    colorController.dispose();
    tokenController.dispose();
    sellerIdController.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
    _loadToken();
    sellerIdController.text = 'd051dbf3-f5d8-410d-0e50-08de06562562';
  }

  void _loadToken() async {
    final token = await SessionManager.getToken();
    if (token != null && token.isNotEmpty) {
      tokenController.text = token;
    }
  }

  Future<void> createProduct() async {
    if (!_validateForm()) return;

    isLoading.value = true;

    try {
      final request = CreateProductRequest(
        name: nameController.text.trim(),
        description: descriptionController.text.trim(),
        nameArabic: nameArabicController.text.trim(),
        descriptionArabic: descriptionArabicController.text.trim(),
        coverPictureUrl: coverPictureUrlController.text.trim(),
        price: double.parse(priceController.text.trim()),
        stock: int.parse(stockController.text.trim()),
        weight: double.parse(weightController.text.trim()),
        sellerId: sellerIdController.text.trim(),
        color: colorController.text.trim(),
        discountPercentage:
            int.tryParse(
              discountController.text.trim().isEmpty
                  ? '0'
                  : discountController.text.trim(),
            ) ??
            0,
        categoryIds: categoryIds.toList(),
        productPictureUrls: productPictureUrls.toList(),
      );

      final productService = ProductService(
        token: tokenController.text.trim().isEmpty
            ? null
            : tokenController.text.trim(),
      );

      await productService.createProduct(request);

      Get.back(result: true);
      GlassSnackbar.show(message: 'productCreatedSuccessMessage'.tr);
    } catch (e) {
      GlassSnackbar.show(
        message: 'errorOccurredMessage'.trParams({'error': e.toString()}),
        isError: true,
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateForm() {
    if (nameController.text.trim().isEmpty) {
      _showError('enterProductNameError'.tr);
      return false;
    }
    if (descriptionController.text.trim().isEmpty) {
      _showError('enterProductDescriptionError'.tr);
      return false;
    }
    if (priceController.text.trim().isEmpty) {
      _showError('enterPriceError'.tr);
      return false;
    }
    if (stockController.text.trim().isEmpty) {
      _showError('enterStockError'.tr);
      return false;
    }

    final sellerId = sellerIdController.text.trim();
    if (sellerId.isEmpty) {
      _showError('enterSellerIdError'.tr);
      return false;
    }

    final guidRegex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    );
    if (!guidRegex.hasMatch(sellerId)) {
      _showError('invalidSellerIdFormatError'.tr);
      return false;
    }

    return true;
  }

  void _showError(String message) {
    GlassSnackbar.show(message: message, isError: true);
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
    discountController.clear();
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

  void fillWithSampleData() {
    sellerIdController.text = 'd051dbf3-f5d8-410d-0e50-08de06562562';
    nameController.text = 'Aviator Sunglasses';
    descriptionController.text =
        'Classic aviator sunglasses with UV protection';
    nameArabicController.text = 'نظارة أفياتور';
    descriptionArabicController.text =
        'نظارة شمسية كلاسيكية مع حماية من الأشعة فوق البنفسجية';
    coverPictureUrlController.text =
        'https://images.unsplash.com/photo-1572635196237-14b3f281503f?q=80&w=1000';
    priceController.text = '1200';
    stockController.text = '25';
    weightController.text = '0.2';
    colorController.text = 'Black';
    discountController.text = '5';
    categoryIds.clear();
    productPictureUrls.clear();
  }

  Future<void> fillAndSubmitSample() async {
    fillWithSampleData();
    await createProduct();
  }
}
