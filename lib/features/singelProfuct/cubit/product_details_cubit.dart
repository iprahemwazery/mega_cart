import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:mega_cart/core/NetWork/product_repository.dart';
import 'package:mega_cart/features/singelProfuct/cubit/product_details_state.dart';
import 'package:mega_cart/core/NetWork/failure.dart';
import 'package:mega_cart/core/models/product.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final ProductRepository repository;

  final String? initialProductId;

  ProductDetailsCubit(this.repository, {this.initialProductId})
    : super(ProductDetailsInitial()) {
    if (initialProductId != null) loadProduct(initialProductId!);
  }

  Future<void> loadProduct(String id) async {
    emit(ProductDetailsLoading());

    final Either<Failure, Product> result = await repository.getProductDetails(
      id,
    );

    result.fold(
      (failure) => emit(ProductDetailsError(failure.message)),
      (product) => emit(ProductDetailsSuccess(product, quantity: 1)),
    );
  }

  void updateQuantity(int newQuantity) {
    final currentState = state;
    if (currentState is ProductDetailsSuccess) {
      if (newQuantity >= 1 && newQuantity <= currentState.product.stock) {
        emit(
          ProductDetailsSuccess(currentState.product, quantity: newQuantity),
        );
      }
    }
  }

  void incrementQuantity() {
    if (state is ProductDetailsSuccess) {
      updateQuantity((state as ProductDetailsSuccess).quantity + 1);
    }
  }

  void decrementQuantity() {
    if (state is ProductDetailsSuccess) {
      updateQuantity((state as ProductDetailsSuccess).quantity - 1);
    }
  }

  Future<Either<Failure, dynamic>> deleteProduct(String id) async {
    return await repository.deleteProduct(id);
  }
}
