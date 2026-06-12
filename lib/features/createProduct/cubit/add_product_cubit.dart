import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:get/get.dart'; // For .tr and GlassSnackbar
import 'package:mega_cart/core/NetWork/product_repository.dart';
import 'package:mega_cart/core/customs/snackbar.dart';
import 'package:mega_cart/core/models/create_product_request.dart';
import 'package:uuid/uuid.dart'; // For GUID validation

part 'add_product_state.dart';

class AddProductCubit extends Cubit<AddProductState> {
  final ProductRepository _productRepository;

  AddProductCubit(this._productRepository) : super(const AddProductInitial());

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
    List<String>? categoryIds,
    List<String>? productPictureUrls,
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
    try {
      Uuid.parse(sellerId);
    } catch (_) {
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
        stock: stock ?? 0, // Default to 0 if not provided
        weight: weight ?? 0.0, // Default to 0.0 if not provided
        sellerId: sellerId,
        color: color ?? '', // Default to empty string
        discountPercentage: discountPercentage ?? 0,
        categoryIds: categoryIds ?? [],
        productPictureUrls: productPictureUrls ?? [],
      );

      final result = await _productRepository.createProduct(
        request,
        token: token,
      );

      result.fold((failure) {
        emit(AddProductError(failure.toString()));
        GlassSnackbar.show(message: failure.toString(), isError: true);
      }, (_) => emit(const AddProductSuccess()));
    } catch (e) {
      String errorMessage = 'errorOccurredMessage'.trParams({
        'error': e.toString(),
      });
      emit(AddProductError(errorMessage));
      GlassSnackbar.show(message: errorMessage, isError: true);
    }
  }

  // Helper to show error messages (can be moved to UI if preferred)
  void _showError(String message) {
    GlassSnackbar.show(message: message, isError: true);
  }

  // You might want to add methods for filling sample data here as well,
  // or keep that logic in the UI for quick actions.
  // For now, it's assumed the UI will handle sample data filling and then call submitProduct.
}
