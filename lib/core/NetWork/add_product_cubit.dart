import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mega_cart/core/NetWork/product_repository.dart';

abstract class AddProductState {}

class AddProductInitial extends AddProductState {}

class AddProductLoading extends AddProductState {}

class AddProductSuccess extends AddProductState {}

class AddProductError extends AddProductState {
  final String message;
  AddProductError(this.message);
}

class AddProductCubit extends Cubit<AddProductState> {
  final ProductRepository _repository;
  AddProductCubit(this._repository) : super(AddProductInitial());

  Future<void> submitProduct({
    required String sellerId,
    required String name,
    required String description,
    required String nameArabic,
    required String descriptionArabic,
    required double price,
    required String coverPictureUrl,
  }) async {
    emit(AddProductLoading());
    final result = await _repository.addProduct(
      sellerId: sellerId,
      name: name,
      description: description,
      nameArabic: nameArabic,
      descriptionArabic: descriptionArabic,
      price: price,
      coverPictureUrl: coverPictureUrl,
    );

    result.fold(
      (error) => emit(AddProductError(error.message)),
      (_) => emit(AddProductSuccess()),
    );
  }
}
