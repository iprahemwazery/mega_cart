import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart'; // For .tr and GlassSnackbar
import 'package:mega_cart/core/NetWork/product_repository.dart';
// import 'package:mega_cart/core/customs/snackbar.dart'; // Removed as GlassSnackbar is used in UI
import 'package:mega_cart/core/models/create_product_request.dart';

part 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  final ProductRepository _productRepository;

  AddProductCubit(this._productRepository) : super(const AddProductInitial());

  void addCategory(String categoryId) {
    final updatedList = List<String>.from(state.categoryIds)..add(categoryId);
    emit(state.copyWith(categoryIds: updatedList));
  }

  void removeCategory(String categoryId) {
    final updatedList = state.categoryIds
        .where((id) => id != categoryId)
        .toList();
    emit(state.copyWith(categoryIds: updatedList));
  }

  void addProductPictureUrl(String url) {
    final updatedList = List<String>.from(state.productPictureUrls)..add(url);
    emit(state.copyWith(productPictureUrls: updatedList));
  }

  void removeProductPictureUrl(String url) {
    final updatedList = state.productPictureUrls
        .where((u) => u != url)
        .toList();
    emit(state.copyWith(productPictureUrls: updatedList));
  }

  void clearCategoriesAndPictures() {
    emit(state.copyWith(categoryIds: [], productPictureUrls: []));
  }

  Future<void> submitProduct({
    required String sellerId,
    required String name,
    required String description,
    required String nameArabic,
    required String descriptionArabic,
    required double price,
    required String coverPictureUrl,
    int? stock,
    double? weight,
    String? color,
    int? discountPercentage,
    String? token,
  }) async {
    emit(const AddProductLoading());

    // Basic validation (more comprehensive validation can be done in the UI layer)
    if (name.isEmpty) {
      emit(AddProductError('enterProductNameError'.tr));
      return;
    }
    if (description.isEmpty) {
      emit(AddProductError('enterProductDescriptionError'.tr));
      return;
    }
    if (price <= 0) {
      emit(AddProductError('enterPriceError'.tr));
      return;
    }
    if (sellerId.isEmpty) {
      emit(AddProductError('enterSellerIdError'.tr));
      return;
    }

    // GUID validation for sellerId
    final uuidRegex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    );
    if (!uuidRegex.hasMatch(sellerId)) {
      emit(AddProductError('invalidSellerIdFormatError'.tr));
      return;
    }

    try {
      final request = CreateProductRequest(
        name: name,
        description: description,
        nameArabic: nameArabic,
        descriptionArabic: descriptionArabic,
        coverPictureUrl: coverPictureUrl,
        price: price,
        stock: stock ?? 0,
        weight: weight ?? 0.0,
        sellerId: sellerId,
        color: color ?? '', // Default to empty string
        discountPercentage: discountPercentage ?? 0,
        categoryIds: state.categoryIds,
        productPictureUrls: state.productPictureUrls,
      );

      final result = await _productRepository.createProduct(
        request,
        token: token,
      );

      result.fold((failure) {
        emit(AddProductError(failure.toString()));
      }, (_) => emit(const AddProductSuccess()));
    } catch (e) {
      emit(AddProductError(e.toString()));
    }
  }
}
